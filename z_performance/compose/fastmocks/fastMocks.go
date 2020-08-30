package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path"
	"sort"
	"strconv"
	"strings"
	"time"
)

//Takes command line parameters for the port to listen on and the mock API responses to load
// Reads a header variable called X-Delay and implements an x Millisecond API Delay to match what was requested
// Reads a header variable called X-Test-Script for Logging the caller's test case. This makes it easy to verify test results against the log files
// Reads a header variable called X-Gateway for logging the gateway that is being tested. This makes it easy to verify test results against the log files
// Creates a Root path that shows a list of all of the valid Mock API endpoints hosted on this instance

var (
	mockApiMap        map[string]interface{}
	shouldLogRequests bool = false
)

const (
	Ldate         = 1 << iota     // the date in the local time zone: 2009/01/23
	Ltime                         // the time in the local time zone: 01:23:23
	Lmicroseconds                 // microsecond resolution: 01:23:23.123123.  assumes Ltime.
	Llongfile                     // full file name and line number: /a/b/c/d.go:23
	Lshortfile                    // final file name element and line number: d.go:23. overrides Llongfile
	LUTC                          // if Ldate or Ltime is set, use UTC rather than the local time zone
	LstdFlags     = Ldate | Ltime // initial values for the standard logger
)

func main() {
	log.SetFlags(Ldate | Ltime | LUTC | Llongfile)

	fileContainingMockApiData, portToListenOn := getCommandLineParameters()

	requestsEnv := os.Getenv("LOG_REQUESTS")
	if strings.ToUpper(requestsEnv) == "TRUE" {
		shouldLogRequests = true
	}

	getMockApiDataFrom(fileContainingMockApiData)

	mapMockApiResponsesToUrlPaths()

	fmt.Printf("\n\nSpinning Up a Mock Server on Port: %s \n\n", portToListenOn)
	http.ListenAndServe(portToListenOn, nil)
}

func mapMockApiResponsesToUrlPaths() {

	http.HandleFunc("/", indexPageHandler)

	for k, v := range mockApiMap {
		fmt.Println("Configured a Handler for Mock API Endpoint: ", k)
		bytes, _ := json.Marshal(v)
		response := string(bytes)
		http.HandleFunc(k, mockApiHandler(response))
	}

}

func getCommandLineParameters() (string, string) {

	//Define the command line parameters, validate them and provide error message to user for incorrect usage
	fileNamePtr := flag.String("cf", "", "The name of the config file with Mock APIs and responses i.e. -cf=config_file_name.JSON")
	portToListenOnPtr := flag.Int("p", 8000, "The port to listen on. ")
	flag.Parse()

	portToListenOn := strings.Join([]string{":", strconv.Itoa(int(*portToListenOnPtr))}, "")

	if *fileNamePtr == "" {
		printHelpText()
		os.Exit(1)
	}

	return *fileNamePtr, portToListenOn

}

func printHelpText() {

	fmt.Println("\n mockSomeAPIs serves up Mock APIs. It reads a JSON file that contains the mock API data to return. The file format is:")
	fmt.Println("\n     { 'URL Path 1' : { 'A' : 'Response Object to Return' }, 'URL Path 2' : { 'Another' : 'Response Object to Return'} }")
	fmt.Println("\n An Index page is created that will present a list of all of the valid Mock API endpoints hosted on this instance of mockSomeApis.")
	fmt.Println(" It is located at http://localhost:port/ ")
	fmt.Println("\n When Calling a Mock API endpoint, various HTTP Headers will change the behavior of mockSomeAPIs. You can change the headers on every single request if you like.")
	fmt.Println("     X-Delay: x                    will cause an x Millisecond Delay before sending the mock API Response")
	fmt.Println("     X-Test-Script: scriptName     will add the test script name to the mock API Transaction Log file")
	fmt.Println("     X-Test-Case: testCaseName     will add the name of the Gateway being used to the mock API Transaction Log File")
	fmt.Println("\n Command Line Parameters are:")
	flag.PrintDefaults()

}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func indexPageHandler(w http.ResponseWriter, r *http.Request) {

	filePath := path.Join("templates", "index.html")
	tmpl, err := template.ParseFiles(filePath)
	if err != nil {
		log.Println("Error Parsing template file (index.html) ", err.Error())
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if err := tmpl.Execute(w, mockApiMap); err != nil {
		log.Println("Error Executing template on index.html ", err.Error())
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func mockApiHandler(apiResponse string) http.HandlerFunc {

	//Use a closure to return a different version of this function for every API that we are mocking

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		//Delay sending the response if we were asked to
		delay, err := strconv.Atoi(r.Header.Get("X-Delay"))
		if err == nil {
			time.Sleep(time.Duration(delay) * time.Millisecond)
		}

		//Set the timestamp Header so the tester knows that this data is fresh....and other typical headers
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Connection", "Keep-Alive")
		w.Header().Set("Date", time.Now().Format(time.RFC1123Z))
		w.Header().Set("Keep-Alive", "timeout=5") // set this to the duration of the load test

		//Add Log entries that can be used for load test reports or other analytics later
		if shouldLogRequests {
			log.Printf("sourceIP: %s; requestURI : %s; X-Test-Script: %s; X-Test-Case: %s; X-Delay : %s;", r.RemoteAddr, r.RequestURI, r.Header.Get("X-Test-Script"), r.Header.Get("X-Test-Case"), r.Header.Get("X-Delay"))
		}
		fmt.Fprintln(w, apiResponse)

	})
}

func getMockApiDataFrom(fileName string) {

	dat, err := ioutil.ReadFile(fileName)
	check(err)

	err = json.Unmarshal([]byte(dat), &mockApiMap)
	check(err)

	sortAndPrintEndpoints()
}

func sortAndPrintEndpoints() {

	//Sort the Endpoints for display
	var endPoints []string
	for k, _ := range mockApiMap {
		endPoints = append(endPoints, k)
	}
	sort.Strings(endPoints)

	//Display what we found
	for _, endPoint := range endPoints {
		bytesResponse, _ := json.Marshal(mockApiMap[endPoint])
		stringResponse := string(bytesResponse)
		fmt.Printf("Found Mock API Endpoint: %s \t Length : %d\n", endPoint, len(stringResponse))
	}
	fmt.Println("============================")

}
