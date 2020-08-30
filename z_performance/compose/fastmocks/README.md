# mockSomeAPIs
This is a high performance Mock API Utility. It is intended to scale to very high transaction volumes for "break it" load testing of component in front of it. It reliably scales to 95,000 transactions per second on a single c4.2xlarge server. That component can be an API Gateway, an API that orchestrates other APIs or any other type of app that needs RESTful Mock Endpoints.

I tried a lot of other API Mocking tools and most of them focused on having a lot of features and therefore much lower scalability. So, I wrote my own focused on exactly what we needed. Very low overhead and very high throughput. It doesn't have a lot of features. It simply loads up a JSON configuration file that defines all of the mock endpoints and then serves them up. You can pick which port it listens on. 

The file format is:
```javascript
{
  "URL Path 1": {
    "A": "Response Object to Return"
  },
  "URL Path 2": {
    "Another": "Response Object to Return"
  }
}
```

[API_Small_Set.json](https://github.kdc.capitalone.com/xby099/mockSomeAPIs/blob/master/API_Small_Set.json) has a simple example. See the other JSON Files for more realistic responses from Digital Wallet Unit tests. 


It reads in the file of URI Endpoints and response objects and creates an Index page to conveniently list all of the valid Mock API endpoints hosted on that instance of mockSomeApis. The index page is located at http://localhost:port/

It takes 2 parameters:
* -p port
* -cf Configuration file name

When Calling a Mock API endpoint, various HTTP Headers will change the behavior of mockSomeAPIs. You can change the headers on every single request if you like.

* X-Delay: x                    
...will cause an x Millisecond Delay before sending the mock API Response

* X-Test-Script: scriptName     
...will add the test script name to the mock API Transaction Log file

* X-Test-Case: testCaseName   
...will add the name of the Gateway being used to the mock API Transaction Log File

Feel free to add features if you like !
