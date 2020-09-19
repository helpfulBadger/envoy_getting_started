package envoy.authz

fullyPopulated = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"{\n    \"bodyKey1\": \"bodyValue1\",\n    \"bodyKey2\": \"bodyValue2\"\n}","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6Indvcmtmb3JjZUlEUC1FUzI1NiJ9.ewogICAgImlzcyI6ICJ3b3JrZm9yY2VJZGVudGl0eS5leGFtcGxlLmNvbSIsCiAgICAic3ViIjogIndvcmtmb3JjZUlkZW50aXR5OjQwNjMxOSIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm1QUGR3SjdKcnIyTVF6UyIKfQ.BelPJ0lBnn5RaW1GwaIXWLPeDCk5vXXFna2rwyzze5549JlYIcXc7q2SKqK22hVFWFcJxpqHjCfDpbfCypLrpA","app-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6IkFQSUdXLUVTMjU2In0.ewogICAgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiYXBpZ2F0ZXdheTphcHBfMTIzNDU2IiwKICAgICJhdWQiOiBbICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgInByb3RlY3RlZC1zdHVmZi5leGFtcGxlLmNvbSJdLAogICAgImF6cCI6ICJhcHBfMTIzNDU2IiwKICAgICJjbGllbnRfaWQiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIlhjT3BRZTJ2cVRxMWtueSIsCiAgICAiZ3JhbnQiOiAiY2xpZW50X2NyZWRlbnRpYWxzIiwKICAgICJvd25pbmdMZWdhbEVudGl0eSI6ICJFeGFtcGxlIENvLiIsCiAgICAic2NvcGVzIjogWwogICAgICAicmV3YXJkczpyZWFkIiwKICAgICAgInJld2FyZHM6cmVkZWVtIgogICAgXSwKICAgICJraWQiOiAiQVBJR1ctRVMyNTYiCn0.q2ES4cOOFSJMBgHGGnZfx6sNQk8UJ21Oejq1_99EVjIvAVZen3ZuN9HWaJjX8VsVjuYPg2pR2OjDk9tQhdI0Qg","subject-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6ImN1c3RJRFAtRVMyNTYifQ.ewogICAgImlzcyI6ICJjdXN0b21lcklkZW50aXR5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiY3VzdG9tZXJJZGVudGl0eTpEQm00RkJjbFNEMjYxRzIiLAogICAgInByb2ZpbGVSZWZJRCI6ICIzNDk4MzU5OHNma2g5dzg3OTg3OThkIiwKICAgICJjdXN0b21lclJlZklEIjogIkRCbTRGQmNsU0QyNjFHMiIsCiAgICAiY29uc2VudElEIjogIjQzNzhhZmQ0ZiIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm84VDJoeHJhZUZ6SVE2cCIsCiAgICAibm9uY2UiOiAibi0wUzZfV3pBMk1qIiwKICAgICJhY3IiOiAidXJuOm1hY2U6aW5jb21tb246aWFwOnNpbHZlciIsCiAgICAiYW1yIjogWwogICAgICAiZmFjZSIsCiAgICAgICJmcHQiLAogICAgICAiZ2VvIiwKICAgICAgIm1mYSIKICAgIF0sCiAgICAidm90IjogIlAxLkNjLkFjIiwKICAgICJ2dG0iOiAiaHR0cHM6Ly9leGFtcGxlLm9yZy92b3QtdHJ1c3QtZnJhbWV3b3JrIgp9.nUztCfQuRZoknUp2_IkefNqUDyVf6HIaJv6hHkLaRv5cX237Kas_W_gWxLIuuhtyZzus4nz92YqdwG93ZfhSFA","session-id":"123456-1","request-id":"123456-2","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJib2R5RGlnZXN0IjogIjYwMDA5Y2VjNWI1MzUyNzBhMGI4Mzg5Y2VhNjdjODk0ZmFlOTU0OWMxN2IyY2VlZjhmODI0Y2RlM2ExMGIxNGUiLCAiY3JlYXRlZCI6IDE2MDA1NTgxOTIxOTQ5MjA2NTksICJoZWFkZXJEaWdlc3QiOiAiODczMjliYTgzODNmZjM5YjQwNzQ2YWEyMmU4ZDRlZTU4ZmFjYzVhYzQ3MGNhYzQxMGVmYjZlNTQ5Zjc1NzRmYiIsICJoZWFkZXJzIjogWyJhY3Rvci10b2tlbiIsICJhcHAtdG9rZW4iLCAic3ViamVjdC10b2tlbiIsICJzZXNzaW9uLWlkIiwgInJlcXVlc3QtaWQiXSwgImhvc3QiOiAibG9jYWxob3N0OjgwODAiLCAibWV0aG9kIjogIlBPU1QiLCAicGF0aCI6ICIvcG9zdCJ9.hKFerW-4Ht5PWO2oY6NI1xlAWSNCDyQYrYy83crxD76IkQJ2o3SVeNkyUxkpqU5p3aTrmve0M9xadh0RASApOC5BqmnD0e9erEovXJ3K8DscbOkLS73N072gwmrtmaPr2o5oErw2OVOOxsxSVbjm3lpCchjpEjmbPNF2wZN76cR0R56mi2nSOKTUnCx24VmSy1IAo_MethZ0rRwJhyoDCyPInTvPAMSmAWfELLwpdTFfP6jtV6f7FPad0nioRo_aPu6fQkrvrs3S1PpeytJauZ0tv0MCH9dZ9n6Sq6L6bAGVd4Txd3lGCGmDHmPEEvvDcJIBBzsP6isoCim89a8DAg","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
fullyPopulatedJws = {
    "bodyDigest": "60009cec5b535270a0b8389cea67c894fae9549c17b2ceef8f824cde3a10b14e",
    "headerDigest": "87329ba8383ff39b40746aa22e8d4ee58facc5ac470cac410efb6e549f7574fb",
    "host": "localhost:8080",
    "method": "POST",
    "path": "/post"
}

emptyBodyAndHeaders = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJib2R5RGlnZXN0IjogImUzYjBjNDQyOThmYzFjMTQ5YWZiZjRjODk5NmZiOTI0MjdhZTQxZTQ2NDliOTM0Y2E0OTU5OTFiNzg1MmI4NTUiLCAiY3JlYXRlZCI6IDE2MDA1NTgwOTUzMDI0MzI5ODEsICJoZWFkZXJEaWdlc3QiOiAiMTc1Njk4OWIwOGExZjBhMDMyMzU4MDZkYTEwNDBmYzYwYmRmNmVlYzNhNzZiYTI5YTFiMTcxMjUyZGQ5MmRkYSIsICJoZWFkZXJzIjogWyJhY3Rvci10b2tlbiIsICJhcHAtdG9rZW4iLCAic3ViamVjdC10b2tlbiIsICJzZXNzaW9uLWlkIiwgInJlcXVlc3QtaWQiXSwgImhvc3QiOiAibG9jYWxob3N0OjgwODAiLCAibWV0aG9kIjogIlBPU1QiLCAicGF0aCI6ICIvcG9zdCJ9.noDylksd5y66tffWS1ndSUlB_I4ZphMBO5o9G07rx7f0gXZ81DEV9ftBv3Mpcb82s_RSpfjaR9-QEP6U8HlllXQsOZWMHdlWvmHYp5qkwHRBj2GLzZrKtz2IYEzefXaxAdOcoS5Q18Cr0eRneqbxUsdcFo3CAQpJbEINIo7SLTdMW4B92A-5Rpe0kEQn2dtIDRFCFwSQWbwJfxUTPiMvWDP8_5DZQOwxWYwwRvwM4ulZdpj-80Gmj73EASeAnIcVdB6UAODqdtAJ0Q7RlaqoZTX5kQy_KAr_PylzWVqKYlQWYnUXKM_sUpTpE5I5syOTFtvT8B1kOtiIO8sAfOcnhw","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
emptyBodyAndHeadersJws = {
    "bodyDigest": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
    "headerDigest": "1756989b08a1f0a03235806da1040fc60bdf6eec3a76ba29a1b171252dd92dda",
    "host": "localhost:8080",
    "method": "POST",
    "path": "/post"
}

missingBodyAndHeaders = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","Digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJib2R5RGlnZXN0IjogImUzYjBjNDQyOThmYzFjMTQ5YWZiZjRjODk5NmZiOTI0MjdhZTQxZTQ2NDliOTM0Y2E0OTU5OTFiNzg1MmI4NTUiLCAiY3JlYXRlZCI6IDE2MDA1NTg0Mzc3OTkwOTYwMjAsICJoZWFkZXJEaWdlc3QiOiAiNDQxMzZmYTM1NWIzNjc4YTExNDZhZDE2ZjdlODY0OWU5NGZiNGZjMjFmZTc3ZTgzMTBjMDYwZjYxY2FhZmY4YSIsICJoZWFkZXJzIjogWyJhY3Rvci10b2tlbiIsICJhcHAtdG9rZW4iLCAic3ViamVjdC10b2tlbiIsICJzZXNzaW9uLWlkIiwgInJlcXVlc3QtaWQiXSwgImhvc3QiOiAibG9jYWxob3N0OjgwODAiLCAibWV0aG9kIjogIlBPU1QiLCAicGF0aCI6ICIvcG9zdCJ9.XWwo0obIteuoRo8vgVhC38E7SHwI9zvKKhVTgw9ydgZuwix8bagH_7sPPHWxJUInoKhTMHNmJGRG797ZnCc3r9PttkdhQTl7AGDY1JSZdzLe22UhO_U3z9kOlKhlQoYqrbwRfcJGr-V0sdIdrFQL1JNvRrc2NVSReiFrjQUdV8CmY6Pw37Qr7DSlQvuI9VhChi5sAaMjQHiocRL1mmT5zKWqq6Vxm-o3Ipz3-czz-Vj3Eft3bHKyG8ewUYjNsY0k_MhCJwlsag3VsU_jT99Gm8iBsviORgxWcFlme3mVkd7DsUZkQ_RJ1If_9_Uq37R9gXhtKId-DV7TbWvw7yXK7g","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
missingBodyAndHeadersJws = {
    "bodyDigest": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
    "headerDigest": "44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a",
    "host": "localhost:8080",
    "method": "POST",
    "path": "/post"
}

# Fully populated request
test_fully_populated_req_bodyHash_matches {
    bodyHash   == fullyPopulatedJws.bodyDigest   with input as fullyPopulated
}

test_fully_populated_req_headerHash_matches {
    headerHash == fullyPopulatedJws.headerDigest with input as fullyPopulated
}

test_fully_populated_req_allowed {
    allow.allowed with input as fullyPopulated
}

# The request has a body and all of our critical headers but they are empty
test_empty_Body_And_Headers_req_bodyHash_matches {
    bodyHash   == emptyBodyAndHeadersJws.bodyDigest   with input as emptyBodyAndHeaders
}

test_empty_Body_And_Headers_req_headerHash_matches {
    headerHash == emptyBodyAndHeadersJws.headerDigest with input as emptyBodyAndHeaders
}

test_empty_Body_And_Headers_req_allowed {
    allow.allowed with input as emptyBodyAndHeaders
}

# The request is missing a body and all of our critical headers
test_missing_Body_And_Headers_req_bodyHash_matches {
    bodyHash   == missingBodyAndHeadersJws.bodyDigest   with input as missingBodyAndHeaders
}

test_missing_Body_And_Headerss_req_headerHash_matches {
    headerHash == missingBodyAndHeadersJws.headerDigest with input as missingBodyAndHeaders
}

test_missing_Body_And_Headers_req_allowed {
    allow.allowed with input as missingBodyAndHeaders
}
