package istio.authz

import input.attributes.request.http as http_request

default allow = false

allow = response {
  http_request.method == "GET"
  response := {
      "allowed": true,
      "headers": {"X-Auth-User": "1234"}
  }
}
