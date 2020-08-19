package jws.examples.v1

test_valid_tokens_allowed {
    result.verify_example.isValid
    result.decode_verify_example.isValid
}
