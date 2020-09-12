package envoy.authz

import input.attributes.request.http as http_request

import input.attributes.request.http.headers["actor-token"] as actorToken
import input.attributes.request.http.headers["app-token"] as appToken

actor = p {
  [ _, p, _ ] := io.jwt.decode(actorToken)	
}

app  = p {
  [ _, p, _ ] :=  io.jwt.decode(appToken)	
}

endpoints = [{"id":"001","method":"GET","pattern":"/api/customer"},{"id":"002","method":"POST","pattern":"/api/customer"},{"id":"003","method":"DELETE","pattern":"/api/customer/*"},{"id":"004","method":"GET","pattern":"/api/customer/*"},{"id":"005","method":"POST","pattern":"/api/customer/*"},{"id":"006","method":"PUT","pattern":"/api/customer/*"},{"id":"007","method":"GET","pattern":"/api/customer/*/account"},{"id":"008","method":"POST","pattern":"/api/customer/*/account"},{"id":"009","method":"DELETE","pattern":"/api/customer/*/account/*"},{"id":"010","method":"GET","pattern":"/api/customer/*/account/*"},{"id":"011","method":"PUT","pattern":"/api/customer/*/account/*"},{"id":"012","method":"GET","pattern":"/api/customer/*/messages"},{"id":"013","method":"POST","pattern":"/api/customer/*/messages"},{"id":"014","method":"DELETE","pattern":"/api/customer/*/messages/*"},{"id":"015","method":"GET","pattern":"/api/customer/*/messages/*"},{"id":"016","method":"POST","pattern":"/api/customer/*/messages/*"},{"id":"017","method":"PUT","pattern":"/api/customer/*/messages/*"},{"id":"018","method":"GET","pattern":"/api/customer/*/order"},{"id":"019","method":"POST","pattern":"/api/customer/*/order"},{"id":"020","method":"DELETE","pattern":"/api/customer/*/order/*"},{"id":"021","method":"GET","pattern":"/api/customer/*/order/*"},{"id":"022","method":"POST","pattern":"/api/customer/*/order/*"},{"id":"023","method":"PUT","pattern":"/api/customer/*/order/*"},{"id":"024","method":"GET","pattern":"/api/customer/*/paymentcard"},{"id":"025","method":"POST","pattern":"/api/customer/*/paymentcard"},{"id":"026","method":"DELETE","pattern":"/api/customer/*/paymentcard/*"},{"id":"027","method":"GET","pattern":"/api/customer/*/paymentcard/*"},{"id":"028","method":"POST","pattern":"/api/customer/*/paymentcard/*"},{"id":"029","method":"PUT","pattern":"/api/customer/*/paymentcard/*"},{"id":"030","method":"DELETE","pattern":"/api/featureFlags"},{"id":"031","method":"GET","pattern":"/api/featureFlags"},{"id":"032","method":"POST","pattern":"/api/featureFlags"},{"id":"033","method":"PUT","pattern":"/api/featureFlags"},{"id":"034","method":"GET","pattern":"/api/order"},{"id":"035","method":"POST","pattern":"/api/order"},{"id":"036","method":"DELETE","pattern":"/api/order/*"},{"id":"037","method":"GET","pattern":"/api/order/*"},{"id":"038","method":"POST","pattern":"/api/order/*"},{"id":"039","method":"PUT","pattern":"/api/order/*"},{"id":"040","method":"GET","pattern":"/api/order/*/payment"},{"id":"041","method":"POST","pattern":"/api/order/*/payment"},{"id":"042","method":"DELETE","pattern":"/api/order/*/payment/*"},{"id":"043","method":"GET","pattern":"/api/order/*/payment/*"},{"id":"044","method":"POST","pattern":"/api/order/*/payment/*"},{"id":"045","method":"PUT","pattern":"/api/order/*/payment/*"},{"id":"046","method":"GET","pattern":"/api/product"},{"id":"047","method":"POST","pattern":"/api/product"},{"id":"048","method":"DELETE","pattern":"/api/product/*"},{"id":"049","method":"GET","pattern":"/api/product/*"},{"id":"050","method":"POST","pattern":"/api/product/*"},{"id":"051","method":"PUT","pattern":"/api/product/*"},{"id":"052","method":"GET","pattern":"/api/shipment"},{"id":"053","method":"POST","pattern":"/api/shipment"},{"id":"054","method":"DELETE","pattern":"/api/shipment/*"},{"id":"055","method":"GET","pattern":"/api/shipment/*"},{"id":"056","method":"POST","pattern":"/api/shipment/*"},{"id":"057","method":"PUT","pattern":"/api/shipment/*"}]

apiPermissions = {
  "app_123456": [ "001","004","007","010","012","015","018","021","024","027","031","034","037","040","043","046","049","052","055"],
  "app_000123":[
    "001", "002", "003", "004", "005", "006", "007", "008", "009", "010", 
    "011", "012", "013", "014", "015", "016", "017", "018", "019", "020",
    "021", "022", "023", "024", "025", "026", "027", "028", "029", "030",
    "031", "032", "033", "034", "035", "036", "037", "038", "039", "040",
    "041", "042", "043", "044", "045", "046", "047", "048", "049", "050",
    "051", "052", "053", "054", "055", "056", "057",
  ]
}

idProviderPermissions = {
  "app_123456":["customerIdentity.example.com"],
  "app_000123":["workforceIdentity.example.com"]
}

endpointID = epID {
  some i
  endpoints[i].method == http_request.method
  p := trim_right( http_request.path, "/")  #strip trailing slash if present
  glob.match( lower(endpoints[i].pattern), ["/"], lower(p) )
  epID := endpoints[i].id
} else = "none"

default apiPermittedForClient = false
apiPermittedForClient {
  apiPermissions[ app.client_id ][_] == endpointID
}

default userTypeAppropriateForClient = false
userTypeAppropriateForClient {
  idProviderPermissions[ app.client_id ][_] == actor.iss
}

messages[ msg ]{
  not apiPermittedForClient
  msg := {
    "id"  : "1",
    "priority"  : "5",
    "message" : "The requested API Endpoint is not permitted for the client application"
  }
}

messages[ msg ]{
  not userTypeAppropriateForClient
  msg := {
    "id"  : "2",
    "priority"  : "5",
    "message" : "The authenticated user type is not allowed for the client application"
  }
}

default decision = false
decision {
  apiPermittedForClient
  userTypeAppropriateForClient
}

allow = response {
  response := {
    "allowed": decision,
    "headers": {
      "X-Authenticated-User": "true", 
      "X-Authenticated-App": "true",
      "Endpoint-ID": endpointID,
      "Content-Type": "application/json"
    },
    "body" : json.marshal(
                      {
                        "Authorized-User-Type": userTypeAppropriateForClient,
                        "Authorized-Endpoint": apiPermittedForClient,
                        "Authorization-Failures" : messages,
                        "Requested-Path": http_request.path,
                        "Requested-Method": http_request.method
                      })
  }
} 
