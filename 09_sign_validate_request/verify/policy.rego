package envoy.authz

import input.attributes.request.http as http_request
import input.attributes.request.http.headers["digest"] as digest

jwks = `{
  "keys": [
    {
      "use": "sig",
      "kty": "EC",
      "kid": "APIGW-ES256",
      "crv": "P-256",
      "alg": "ES256",
      "x": "g3uF5OZrWsU6yKJhv0FQxhALlmNbw6_Wa9_exT3-eNA",
      "y": "lJbCP1oz0vDs6Dxd_3my5Ga5fLSXRDzQVbTTlt9pr98"
    },
    {
      "use": "sig",
      "kty": "EC",
      "kid": "custIDP-ES256",
      "crv": "P-256",
      "alg": "ES256",
      "x": "HmVjNgoTIECfvja3E7WZX2H1OzXtvDhD5_SSMXGYxZU",
      "y": "ugCW-AoKaSyNqIbyNUgRWMJ8WY6s2W78YI2LdVVTGcY"
    },
    {
      "use": "sig",
      "kty": "EC",
      "kid": "workforceIDP-ES256",
      "crv": "P-256",
      "alg": "ES256",
      "x": "_Vg3wsKsY9XH5E5aPn2SLUTUljgum2TXnDY7m73p2Ek",
      "y": "rSbvTXUdPnFpJq5zqgRLMMAQP8bJ7UcggP1ERkEibGI"
    },
    {
      "use": "sig",
      "kty": "RSA",
      "kid": "APIGW-RS256",
      "alg": "RS256",
      "n": "thiAsWa8crD-RhGbAewoYjyWpgZpaFKHWqzqAM2iCJ94eQnSwFJJcFayOklSfKK8tUUYulG7FQijpdBLVzbilPtpYK8HjHoLZBLrvNPbEvwlMCVMDX5ttyn1lJV-6momFwuV6EJFnPMXJQU3KTX_QeFejiamxmYQsakyWxxDtTWJ1XAlvtIX3k0osQbFrLbF5SGIwAk9UBFlm2B_3M0lbqu6w8eOxgSc3z-Owd6maYu2Q43MZv-opjObHNfcc60o90iOO9pY5_qSkJt7Slf2cuKU6eOUjsoSCOgValKngogup_itt7LJkrt-ugFiwUITEt6V6MY1MHEw1RgM75N_iQ",
      "e": "AQAB"
    },
    {
      "use": "sig",
      "kty": "RSA",
      "kid": "custIDP-RS256",
      "alg": "RS256",
      "n": "z6AtZ3MpSZ1dd-AFyfxk5stjIrbLa8GLSq0GPqZ5RciZIkv-ad-phosgPSDvG1Nx4pcZcENrXAdMA6v6FjRvdGT0EH9CU2vXTu5kCmGP1vV1WfzFdL3K-mswnEaT6-9bO4-m6SEmR3J3YV5QwFVvxIVJqFSmLIggl1PVCM0pXCYb6vkcacg24E-vh6J28LdZmQFqmWHrF7mOL59oz1Gx8ePOr4WnqhP991DeIpzgiofGAS7QQSiNQoKvtizITk3-kcpjWmdw0Zh32xmhsUCu4NKn8DjY2dJ2-WwcL3KK__E0WBJt3I97Nr-m88BSEVl3-P--fsRiEgIP1Co2ulGMbQ",
      "e": "AQAB"
    },
    {
      "use": "sig",
      "kty": "RSA",
      "kid": "workforceIDP-RS256",
      "alg": "RS256",
      "n": "ucjZ1pagZuXL4GkFXzG7llZbhPUkl1GzG2vyE0YC3NCvgf2WS67KRH6ck_iMHsWraaPdEcbB8t6ftr0qEXC1ciwVc656Q4V4L_-pxWcD1XMfdiZoViaKyMlq1QzB55XgzM1g7cvgg6_rCmTEmTo3-LUvFd7HxpdHdkYz0U_EUmEB8amz3NxR3LaB-STyxnlsRDrIKmYqDNaPqArdn44INwkGeuJUir0ojw5gdbbazT1NIsuJb2y0zHXuu9ESnyKB8N40ydYe2ECxkdynOQaHt8tCKWhh3F32VwOOuZx34RuVSA_bQraGrduVBd05fEdsPUxq38f1-Z7I5YuokqE_Dw",
      "e": "AQAB"
    }
  ]
}`

verified_digest = v {
  [isValid, _, payload ] := io.jwt.decode_verify( digest, 
  { 
      "cert": jwks,
      "aud": "apigateway.example.com"  # <-- Required since the token contains an `aud` claim in the payload
  })
  v := {
    "isValid": isValid,
    "payload": payload
  }
}

criticalHeaders = verified_digest.payload.headers
filteredHeaders = object.filter( http_request.headers, criticalHeaders )	
headerString = json.marshal( filteredHeaders )
headerHash = crypto.sha256( headerString )

headersMatch {
  headerHash == verified_digest.payload.headerDigest
}

default body = ""
body = b {
  b := http_request.body
}
bodyHash = crypto.sha256( body )

bodiesMatch {
  bodyHash == verified_digest.payload.bodyDigest
}

hostsMatch {
  http_request.host == verified_digest.payload.host
}

methodsMatch {
  http_request.method == verified_digest.payload.method
}

pathsMatch {
  http_request.path == verified_digest.payload.path
}

requestDuration = time.now_ns() - verified_digest.payload.created

withinRecencyWindow {
  requestDuration < 34159642955430000
}


messages[ msg ]{
	not verified_digest.isValid
  msg := {
    "id"  : "1",
    "priority"  : "1",
    "message" : "Request SIGNATURE IS NOT VALID"
  }
}

messages[ msg ]{
	not withinRecencyWindow
  verified_digest.isValid
  msg := {
    "id"  : "2",
    "priority"  : "5",
    "message" : "Request is not within the recency window"
  }
}

messages[ msg ]{
	not pathsMatch
  verified_digest.isValid
  msg := {
    "id"  : "3",
    "priority"  : "5",
    "message" : "Request path does not match signature"
  }
}

messages[ msg ]{
	not methodsMatch
  verified_digest.isValid
  msg := {
    "id"  : "4",
    "priority"  : "5",
    "message" : "Request method does not match signature"
  }
}

messages[ msg ]{
	not hostsMatch
  verified_digest.isValid
  msg := {
    "id"  : "5",
    "priority"  : "5",
    "message" : "Request host does not match signature"
  }
}

messages[ msg ]{
	not bodiesMatch
  verified_digest.isValid
  msg := {
    "id"  : "6",
    "priority"  : "5",
    "message" : "Request body does not match signature"
  }
}

messages[ msg ]{
	not headersMatch
  verified_digest.isValid
  msg := {
    "id"  : "7",
    "priority"  : "5",
    "message" : "Critical request headers do not match signature"
  }
}

messages[ msg ]{
	not headersMatch
  verified_digest.isValid
  msg := {
    "id"  : "8",
    "priority"  : "5",
    "message" : "Request is outside the recency window"
  }
}

default decision = false
decision {
  methodsMatch
  pathsMatch
  hostsMatch
  headersMatch
  bodiesMatch
  withinRecencyWindow
}

default headerValue = "false"
headerValue = h {
  decision
  h := "true"
}

allow = {
  "allowed": decision,
  "headers": {
    "Valid-Request": headerValue
  },
  "body" : json.marshal({ "Authorization-Failures": messages })
}
