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
