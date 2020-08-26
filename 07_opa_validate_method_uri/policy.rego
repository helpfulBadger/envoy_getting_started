package istio.authz

import input.attributes.request.http as http_request

import input.attributes.request.http.headers["actor-token"] as actorToken
import input.attributes.request.http.headers["app-token"] as appToken

actor = p {
  [ _, p, _ ] := io.jwt.decode(actorToken)	
}

app  = p {
  [ _, p, _ ] :=  io.jwt.decode(appToken)	
}

default allow = false

endpoints = [
  { "id": "001", "method": "GET",    "pattern": "/api/customer" },     # Get all customers or a set based on search criteria
  { "id": "002", "method": "POST",   "pattern": "/api/customer" },
  { "id": "003", "method": "GET",    "pattern": "/api/customer/*" },   # Get the profile of a spefic customer
  { "id": "004", "method": "PUT",    "pattern": "/api/customer/*" },
  { "id": "005", "method": "DELETE", "pattern": "/api/customer/*" },

  { "id": "006", "method": "GET",    "pattern": "/api/customer/*/account" },  # Get all accounts for a specific customer or a set based on a search criteria
  { "id": "007", "method": "POST",   "pattern": "/api/customer/*/account" },
  { "id": "008", "method": "GET",    "pattern": "/api/customer/*/account/*" }, # Get a specific customer account
  { "id": "009", "method": "PUT",    "pattern": "/api/customer/*/account/*" },
  { "id": "010", "method": "DELETE", "pattern": "/api/customer/*/account/*" },

  { "id": "011", "method": "GET",    "pattern": "/api/customer/*/order"   },   # Get all orders for a specific customer or a set based on a search criteria
  { "id": "012", "method": "POST",   "pattern": "/api/customer/*/order"   },
  { "id": "013", "method": "GET",    "pattern": "/api/customer/*/order/*"   }, # Get a specific order for a specific customer
  { "id": "014", "method": "PUT",    "pattern": "/api/customer/*/order/*"   },
  { "id": "015", "method": "DELETE", "pattern": "/api/customer/*/order/*"   },

  { "id": "016", "method": "GET",    "pattern": "/api/customer/*/paymentcard" }, # Get all payment cards for a specific customer or a set based on a search criteria
  { "id": "017", "method": "POST",   "pattern": "/api/customer/*/paymentcard" },
  { "id": "018", "method": "GET",    "pattern": "/api/customer/*/paymentcard/*" },  # Get a specific payment card for a specific customer
  { "id": "019", "method": "PUT",    "pattern": "/api/customer/*/paymentcard/*" },
  { "id": "020", "method": "DELETE", "pattern": "/api/customer/*/paymentcard/*" },

  { "id": "021", "method": "GET",    "pattern": "/api/customer/*/messages" },  # Get all servicing messages for a specific customer or a set based on a search criteria
  { "id": "022", "method": "POST",   "pattern": "/api/customer/*/messages" },
  { "id": "023", "method": "GET",    "pattern": "/api/customer/*/messages/*" },   # Get a specific servicing message for a specific customer
  { "id": "024", "method": "PUT",    "pattern": "/api/customer/*/messages/*" },
  { "id": "025", "method": "DELETE", "pattern": "/api/customer/*/messages/*" },

  { "id": "026", "method": "GET",    "pattern": "/api/product" },  # Get all available products or a set based on a search criteria
  { "id": "027", "method": "POST",   "pattern": "/api/product" },
  { "id": "028", "method": "GET",    "pattern": "/api/product/*" }, # Get a specific product
  { "id": "029", "method": "PUT",    "pattern": "/api/product/*" },
  { "id": "030", "method": "DELETE", "pattern": "/api/product/*" },

  { "id": "031", "method": "GET",    "pattern": "/api/order"   }, # Get all orders for all customers or a set based on a search criteria
  { "id": "032", "method": "POST",   "pattern": "/api/order"   },
  { "id": "033", "method": "GET",    "pattern": "/api/order/*"   }, # Get a specific order
  { "id": "034", "method": "PUT",    "pattern": "/api/order/*"   },
  { "id": "035", "method": "DELETE", "pattern": "/api/order/*"   },
  
  { "id": "036", "method": "GET",    "pattern": "/api/order/*/payment" }, # Get all payments for a specific order or a set based on a search criteria
  { "id": "037", "method": "POST",   "pattern": "/api/order/*/payment" },
  { "id": "038", "method": "GET",    "pattern": "/api/order/*/payment/*" },  # Get a specific payment for a specific order
  { "id": "039", "method": "PUT",    "pattern": "/api/order/*/payment/*" },
  { "id": "040", "method": "DELETE", "pattern": "/api/order/*/payment/*" },

  { "id": "041", "method": "GET",    "pattern": "/api/shipment" },   # Get all shipments for all customers or a set based on a search criteria
  { "id": "042", "method": "POST",   "pattern": "/api/shipment" },
  { "id": "043", "method": "GET",    "pattern": "/api/shipment/*" },  # Get a specific shipment
  { "id": "044", "method": "PUT",    "pattern": "/api/shipment/*" },
  { "id": "045", "method": "DELETE", "pattern": "/api/shipment/*" },

  { "id": "046", "method": "GET",    "pattern": "/api/featureFlags/" },  # Get all feature flags
  { "id": "047", "method": "POST",   "pattern": "/api/featureFlags/" },  # Replace all feature flags
  { "id": "048", "method": "PUT",    "pattern": "/api/featureFlags/" },  # Update feature flags
  { "id": "049", "method": "DELETE", "pattern": "/api/featureFlags/" }
]

apiPermissions = {
  "app_123456":["001", "003", "006", "008", "011", "013", "016", "018", "021", "023",  "026", "028", "031", "033", "036", "038", "041", "043"],
  "app_123457":[
    "001", "002", "003", "004", "005", "006", "007", "008", "009", "010", 
    "011", "012", "013", "014", "015", "016", "017", "018", "019", "020",
    "021", "022", "023", "024", "025", "026", "027", "028", "029", "030",
    "031", "032", "033", "034", "035", "036", "037", "038", "039", "040",
    "041", "042", "043", "044", "045", "046", "047", "048", "049"
    ]
}

idProviderPermissions = {
  "app_001":["customerIdentity.example.com"],
  "app_002":["workforceIdentity.example.com"]
}

allow = response {
  apiPermissions[ app.client_id ][_] == endpointID
  idProviderPermissions[ app.client_id ] == actor.iss
  response := {
      "allowed": true,
      "headers": {
        "X-Authorized-User": "true", 
        "X-Authorized-App": "true",
        "X-Authorized-App-User-Type": "true",
        "X-Authorized-Endpoint": "true"
      }
  }
}

endpointID = epID {
  some i
  endpoints[i].method == http_request.method
  p := trim_right( http_request.path, "/")  #strip trailing slash 
  glob.match(endpoints[i].pattern, ["/"], p)
  epID := endpoints[i].id
}
