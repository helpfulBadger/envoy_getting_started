package envoy.authz

import input.attributes.request.http as http_request
import input.attributes.request.http.headers["subject-token"] as subject
import input.attributes.request.http.headers["actor-token"] as actor
import input.attributes.request.http.headers["app-token"] as app

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

default allow = {
  "allowed": false,
  "headers": {
    "Authenticated": "false",
    "Reason": "General failure"
  }
}

allow = response {
  verify_subject
  verify_actor
  verify_app

  response := {
    "allowed": true,
    "headers": {
      "Customer-Authenticated": customerAuthenticated,
      "Agent-Authenticated": agentAuthenticated,
      "App-Authenticated": appAuthenticated
    }
  }
} else = {
  "allowed": false,
  "headers": {
    "Customer-Authenticated": customerAuthenticated,
    "Agent-Authenticated": agentAuthenticated,
    "App-Authenticated": appAuthenticated
  }
}

headers = {}

default customerAuthenticated = "false"
customerAuthenticated = validated {
  verify_subject
  validated := "true"
}

default agentAuthenticated = "false"
agentAuthenticated =  validated {
  verify_actor
  validated := "true"
}

default appAuthenticated = "false"
appAuthenticated =  validated {
  verify_app
  validated := "true"
}

verify_subject {
    io.jwt.verify_es256(subject, jwks)
}

verify_subject {
    io.jwt.verify_rs256(subject, jwks)
}

verify_actor {
    io.jwt.verify_es256(actor, jwks)
}

verify_actor {
    io.jwt.verify_rs256(actor, jwks)
}

verify_app {
    io.jwt.verify_rs256(app, jwks)
}

verify_app {
    io.jwt.verify_es256(app, jwks)
}
