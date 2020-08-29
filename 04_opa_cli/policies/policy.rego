package envoy.authz

import input.attributes.request.http as http_request

default allow = {
      "allowed": false,
      "headers": {"X-Auth-User": ""}
  }

allow = response {
  http_request.method == "GET"
  response := {
      "allowed": true,
      "headers": {"X-Auth-User": "1234"}
  }
}
