package jws.examples.v2

import input.input.attributes.request.http as http_request
import input.input.attributes.request.http.headers["subject-token"] as subject
import input.input.attributes.request.http.headers["actor-token"] as actor
import input.input.attributes.request.http.headers["app-token"] as app

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
    }
  ]
}`

decode_verify_subject = { "isValid": isValid, "header": header, "payload": payload } {
     [isValid, header, payload] := io.jwt.decode_verify( subject, 
        { 
            "cert": jwks,
            "aud": "apigateway.example.com"  # <-- Required since the token contains an `aud` claim in the payload
        })
}

decode_verify_actor = { "isValid": isValid, "header": header, "payload": payload } {
     [isValid, header, payload] := io.jwt.decode_verify( actor, 
        { 
            "cert": jwks,
            "aud": "apigateway.example.com"  # <-- Required since the token contains an `aud` claim in the payload
        })
}

decode_verify_app = { "isValid": isValid, "header": header, "payload": payload } {
     [isValid, header, payload] := io.jwt.decode_verify( app, 
        { 
            "cert": jwks,
            "aud": "apigateway.example.com"  # <-- Required since the token contains an `aud` claim in the payload
        })
}

result = {
    "decode_verify_subject": decode_verify_subject,
    "decode_verify_actor": decode_verify_actor,
    "decode_verify_app": decode_verify_app
}
