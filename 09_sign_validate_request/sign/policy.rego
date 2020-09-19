package envoy.authz

import input.attributes.request.http as http_request

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

signingKey = {"use":"sig","kty":"RSA","kid":"APIGW-RS256","alg":"RS256","n":"thiAsWa8crD-RhGbAewoYjyWpgZpaFKHWqzqAM2iCJ94eQnSwFJJcFayOklSfKK8tUUYulG7FQijpdBLVzbilPtpYK8HjHoLZBLrvNPbEvwlMCVMDX5ttyn1lJV-6momFwuV6EJFnPMXJQU3KTX_QeFejiamxmYQsakyWxxDtTWJ1XAlvtIX3k0osQbFrLbF5SGIwAk9UBFlm2B_3M0lbqu6w8eOxgSc3z-Owd6maYu2Q43MZv-opjObHNfcc60o90iOO9pY5_qSkJt7Slf2cuKU6eOUjsoSCOgValKngogup_itt7LJkrt-ugFiwUITEt6V6MY1MHEw1RgM75N_iQ","e":"AQAB","d":"h10jnbyvbdrgypmfzwgM5SoBGx49EU34TJGpyjsSrrJNTjzdLBZ_fUEVcHq9FOWsvlvFDAxhtDsd289Bkm28dd-G8FZsmCLJgPUHxPEAM9a4llfDd2x6huRsKK4REJUkB5GXOHa7ZPbYR67e2IXJYOH19loJNAb_dfI--rfCJVuLibNngOpa3y5vRH8dmEdUpFbqXiWO-Ri8jPYvCuflPXzELFDFjVKIM7HwpbwfmpNPT2FNPr-8Ufyi1PZ79OgJQ87NZetKbR0eHJEi1YRUTNWxM0hHaM2R4eCRx9N8D0-e8HVUsoZ5290aCr8OyGxkJRy3xBWbZRvlSdYVUxwhGQ","p":"5sdc-Z_hgal72a54H9CF5q5tOGv-S5uqMkOET-jvmmLHyS4PdbYnCw35ZJKkN74MrUmHsp8JLfaTnlrzKWNnI7mWiOijhIhjf1Mb0sIgdCo4HGB_ZrgzJUeFe1u1OMfoUEEpJeSeigUkGvmJahVimazpRH9EKcXGouISn0PpAac","q":"yf8avkuYYcbsfodlEm0RymVr1jlJOlUIAfipWl-ikDMHEW7vKw29_bzqoCT3iwVQ2LldzIPorLkZdj-3W1gjI3-hpAZQFP50HT80hNFIc32s-M9gZwvLN2Ag0ynWnXiNnM0WW7eR1ZWa48oW60DmxnovOHVdr0Fjh4o5YY6xu08","dp":"MaeRrLAm4DQsTsEIXagLN4AuReaOl4wNybTXQi5XZ3t7iyDa-LPRoMJH98jJhqjgp2RbyyYG3pngV0EwcqZNqdUju596l2iVJ-8k3GsienwfCJQGtX5KmunRoaIw0t_Ib4Qlq16Ochn7E8a_N1EUnwYiRrevXeGNBLzpztTYzJ8","dq":"A6u-Ka0oBMbfr2D4hkAzLZFwR0FdQlEfRyHkuf647pPu0fNJJ2glhsHzJZvmX8Fl-bpMqRXQmar3en2n8GIGqXN9VYTD2c3SAGIQq0U-YtLq3M6v-s9tDwGRNyUwgEYblLjpahtI7C--09rtVbMlPoAj8Yu4eyHeFC1_43T7Z-M","qi":"HcOr0HMJQYfAJrCeONGGhM7cKJnvRmHTNXA8d_i79iDmEvAYi-EwiRoJSuT-6a9dARwAILUhFL77clOxNav3APO6dOOD7TkbD9QqRsbP8eUNEg_TMbP_GgM63l4PzDnkwhN-aWqfhBbmwFtv3_yXIw-t2sJnUW04HoDvw1ixrzo"}
criticalHeaders = ["actor-token", "app-token", "subject-token", "session-id", "request-id"]
filteredHeaders = object.filter( http_request.headers, criticalHeaders )	
headerString = json.marshal( filteredHeaders )
headerHash = crypto.sha256( headerString )

default body = ""
body = b {
  b := http_request.body
}

bodyHash = crypto.sha256( body )

# jws Request Signature Token
requestDigest = {
  "method": http_request.method,
  "path": http_request.path,
  "host": http_request.host,
  "created": time.now_ns(),
  "headers": criticalHeaders,
  "headerDigest": headerHash,
  "bodyDigest": bodyHash
}

digestHeader = io.jwt.encode_sign({ "typ": "JWT", "alg": "RS256" }, requestDigest, signingKey )

allow = {
  "allowed": true, # Outbound requests are always allowed. This policy simply signs the request
  "headers": {
    "Digest": digestHeader
  }
}
