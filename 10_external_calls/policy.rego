package envoy.authz

import input.attributes.request.http as http_request

default allow = {
  "allowed": false,
  "headers": {"x-ext-auth-allow": "no"},
  "body": "{\n    \"string\": \"Unauthorized Request\",\n    \"integer\": 1,\n    \"real number\": 2.5,\n    \"array\":[ \"string 1\", \"string 2\" ],\n    \"object\":{\"key\":\"value\"}\n}\n\n\n\n",
  "http_status": 403
}

allow = response {
  http_request.method == "POST"
  response := {
      "allowed": true,
      "headers": {"X-Auth-User": "1234"}
  }
}


traceHeaders =  [ "x-b3-parentspanid", "x-b3-sampled", "x-b3-spanid", "x-b3-traceid", "x-request-id" ]
forwardHeaders = object.filter( http_request.headers, traceHeaders )	


http.send({
  "method": "post",
  "url": "http://httpbin.org/anything?myArg=myString",
  "headers": forwardHeaders,
  "body": {
    "decision": true,
    "count": 1,
    "anArray": [
      "word 1",
      "word 2",
      "word 3"
    ],
    "anObject": {
      "key": "value"
    }
  }
})


resp1.body.json.decision
resp1.headers.Date

#Field	                     Required   	Type	              Description
#raw_body	                      no	        string	            HTTP message body to include in request. The value WILL NOT be serialized. Use this for non-JSON messages.
#headers	                      no	        object	            HTTP headers to include in the request (e.g,. {"X-Opa": "rules"}).
#force_json_decode	            no	        boolean	            Decode the HTTP response message body as JSON even if the Content-Type header is missing. Default: false.
#cache	                        no	        boolean	            Cache HTTP response across OPA queries. Default: false.
