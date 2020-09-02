package envoy.authz

import input.attributes.request.http as http_request

default allow = {
  "allowed": false,
  "headers": {"x-ext-auth-allow": "no"},
  "body": "Unauthorized Request\n\n",
  "http_status": 403
}

allow = response {
  http_request.method == "POST"
  response := {
      "allowed": true,
      "headers": {"X-Auth-User": "1234"}
  }
}
