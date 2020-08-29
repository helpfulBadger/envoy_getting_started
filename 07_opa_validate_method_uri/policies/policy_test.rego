package envoy.authz


test1 = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"192.168.208.3"}}}},"metadata_context":{},"request":{"http":{"headers":{":authority":"localhost:8080",":method":"DELETE",":path":"/api/shipment/12345","accept":"*/*","accept-encoding":"gzip, deflate, br","actor-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6Indvcmtmb3JjZUlEUC1FUzI1NiJ9.ewogICAgImlzcyI6ICJ3b3JrZm9yY2VJZGVudGl0eS5leGFtcGxlLmNvbSIsCiAgICAic3ViIjogIndvcmtmb3JjZUlkZW50aXR5OjQwNjMxOSIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm1QUGR3SjdKcnIyTVF6UyIKfQ.RYXZtWlcERiN19RI7KVeZivGE0pc5l59zPf3Uew6TqyxZQYPnq8NGJVATjuHVVXckwY3VM430K-if77L8yHeRA","app-token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IkFQSUdXLVJTMjU2In0.ewogICAgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiYXBpZ2F0ZXdheTphcHBfMDAwMTIzIiwKICAgICJhdWQiOiBbICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgInByb3RlY3RlZC1zdHVmZi5leGFtcGxlLmNvbSJdLAogICAgImF6cCI6ICJhcHBfMDAwMTIzIiwKICAgICJjbGllbnRfaWQiOiAiYXBwXzAwMDEyMyIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIlhjT3BRZTJ2cVRxNjYxayIsCiAgICAiZ3JhbnQiOiAiY2xpZW50X2NyZWRlbnRpYWxzIiwKICAgICJvd25pbmdMZWdhbEVudGl0eSI6ICJFeGFtcGxlIENvLiIsCiAgICAic2NvcGVzIjogWwogICAgICAicmV3YXJkczpyZWFkIiwKICAgICAgInJld2FyZHM6cmVkZWVtIgogICAgXSwKICAgICJraWQiOiAiQVBJR1ctRVMyNTYiCn0.mjU1vCnm19zMjLuEj0pE3Cbuq26K4ZWHxeUNccFsP3wEvTYMfDsu3NvXvxeK2S5vKeVh6EIqZEvhsYrJ0o5GZxY8L3NoXIYjbsrHvjenFrP7itgZpicf6PlSW7QaoQvJ4Ux9Fmv8PzjYGc1WS3nYhPOQXZH5jEGLDdtV-6QGh5-3K0Dzgt7XBg1CSo071wkBf-H7uu6a2BkwiPmjUE8JcGSwhwM3GMVfGca65ydJH9uqlCf91MvhUa5-ruJ1jA_mEE88_qfzqQ93zW7S5J68rY5jhOKfHMx7veYYGfXFTsRjvJ7wtSIZ1ECtuYhpOQW3i58j6Gp45mB1vSm0QqsX0A","cache-control":"no-cache","postman-token":"d8413e89-01b5-4fd3-b4e3-72b15763e825","user-agent":"PostmanRuntime/7.26.3","x-forwarded-proto":"http","x-request-id":"713f5cc1-d1ad-4bfc-b794-fc682c177409"},"host":"localhost:8080","id":"10438214656175419268","method":"DELETE","path":"/api/shipment/12345","protocol":"HTTP/1.1"},"time":{"nanos":387736000,"seconds":1598647550}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":39420},"address":"192.168.208.1"}}}}},"parsed_body":null,"parsed_path":["api","shipment","12345"],"parsed_query":{},"truncated_body":false}
test2 = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.21.0.4"}}}},"metadata_context":{},"request":{"http":{"headers":{":authority":"localhost:8080",":method":"PUT",":path":"/api/customer/12345/account/12345","accept":"*/*","actor-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6Indvcmtmb3JjZUlEUC1FUzI1NiJ9.ewogICAgImlzcyI6ICJ3b3JrZm9yY2VJZGVudGl0eS5leGFtcGxlLmNvbSIsCiAgICAic3ViIjogIndvcmtmb3JjZUlkZW50aXR5OjQwNjMxOSIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm1QUGR3SjdKcnIyTVF6UyIKfQ.RYXZtWlcERiN19RI7KVeZivGE0pc5l59zPf3Uew6TqyxZQYPnq8NGJVATjuHVVXckwY3VM430K-if77L8yHeRA","app-token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IkFQSUdXLVJTMjU2In0.ewogICAgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiYXBpZ2F0ZXdheTphcHBfMDAwMTIzIiwKICAgICJhdWQiOiBbICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgInByb3RlY3RlZC1zdHVmZi5leGFtcGxlLmNvbSJdLAogICAgImF6cCI6ICJhcHBfMDAwMTIzIiwKICAgICJjbGllbnRfaWQiOiAiYXBwXzAwMDEyMyIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIlhjT3BRZTJ2cVRxNjYxayIsCiAgICAiZ3JhbnQiOiAiY2xpZW50X2NyZWRlbnRpYWxzIiwKICAgICJvd25pbmdMZWdhbEVudGl0eSI6ICJFeGFtcGxlIENvLiIsCiAgICAic2NvcGVzIjogWwogICAgICAicmV3YXJkczpyZWFkIiwKICAgICAgInJld2FyZHM6cmVkZWVtIgogICAgXSwKICAgICJraWQiOiAiQVBJR1ctRVMyNTYiCn0.mjU1vCnm19zMjLuEj0pE3Cbuq26K4ZWHxeUNccFsP3wEvTYMfDsu3NvXvxeK2S5vKeVh6EIqZEvhsYrJ0o5GZxY8L3NoXIYjbsrHvjenFrP7itgZpicf6PlSW7QaoQvJ4Ux9Fmv8PzjYGc1WS3nYhPOQXZH5jEGLDdtV-6QGh5-3K0Dzgt7XBg1CSo071wkBf-H7uu6a2BkwiPmjUE8JcGSwhwM3GMVfGca65ydJH9uqlCf91MvhUa5-ruJ1jA_mEE88_qfzqQ93zW7S5J68rY5jhOKfHMx7veYYGfXFTsRjvJ7wtSIZ1ECtuYhpOQW3i58j6Gp45mB1vSm0QqsX0A","postman-token":"48d83665-8c5f-4539-8ac1-4445bbfa019c","user-agent":"curl/7.61.0","x-forwarded-proto":"http","x-request-id":"61349185-8434-4339-88b7-5bf06c600662"},"host":"localhost:8080","id":"5393826568282986917","method":"PUT","path":"/api/customer/12345/account/12345","protocol":"HTTP/1.1"},"time":{"nanos":974318000,"seconds":1598657018}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":35794},"address":"172.21.0.1"}}}}},"parsed_body":null,"parsed_path":["api","customer","12345","account"],"parsed_query":{},"truncated_body":false}

test_valid_request_allow_1 {
    allow with input as test1
}

test_valid_request_allowed_1 {
    allow.allowed with input as test1
}

test_valid_request_messages_1 {
    messages with input as test1
}

test_valid_request_apiPermittedForClient_1 {
    apiPermittedForClient with input as test1
}

test_valid_request_userTypeAppropriateForClient_1 {
    userTypeAppropriateForClient with input as test1
}

test_valid_decision_1 {
    decision with input as test1
}



test_valid_request_allow_2 {
    allow with input as test2
}

test_valid_request_allowed_2 {
    allow.allowed with input as test2
}

test_valid_request_messages_2 {
    messages with input as test2
}

test_valid_request_apiPermittedForClient_2 {
    apiPermittedForClient with input as test2
}

test_valid_request_userTypeAppropriateForClient_2 {
    userTypeAppropriateForClient with input as test2
}

test_valid_decision_2 {
    decision with input as test2
}


