package jws.examples.v1

es256_token = "eyJ0eXAiOiAiSldUIiwgImFsZyI6ICJFUzI1NiJ9.eyJuYmYiOiAxNDQ0NDc4NDAwLCAiaXNzIjogInh4eCJ9.lArczfN-pIL8oUU-7PU83u-zfXougXBZj6drFeKFsPEoVhy9WAyiZlRshYqjTSXdaw8yw2L-ovt4zTUZb2PWMg"

jwks = `{
    "keys": [{
        "kty":"EC",
        "crv":"P-256",
        "x":"z8J91ghFy5o6f2xZ4g8LsLH7u2wEpT2ntj8loahnlsE",
        "y":"7bdeXLH61KrGWRdh7ilnbcGQACxykaPKfmBccTHIOUo"
    }]
}`

verify_example = { "isValid": isValid} {
    isValid := io.jwt.verify_es256(es256_token, jwks)
}

decode_example = {"header": header, "payload": payload, "signature": signature} {
    [header, payload, signature] := io.jwt.decode(es256_token)
}

decode_verify_example = { "isValid": isValid, "header": header, "payload": payload } {
     [isValid, header, payload] := io.jwt.decode_verify(es256_token, { "cert": jwks, "iss": "xxx", })
}

result = {
    "verify_example": verify_example,
    "decode_example": decode_example,
    "decode_verify_example": decode_verify_example
}
