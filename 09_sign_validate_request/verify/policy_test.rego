package envoy.authz

fullyPopulated = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"{\n    \"bodyKey1\": \"bodyValue1\",\n    \"bodyKey2\": \"bodyValue2\"\n}","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6Indvcmtmb3JjZUlEUC1FUzI1NiJ9.ewogICAgImlzcyI6ICJ3b3JrZm9yY2VJZGVudGl0eS5leGFtcGxlLmNvbSIsCiAgICAic3ViIjogIndvcmtmb3JjZUlkZW50aXR5OjQwNjMxOSIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm1QUGR3SjdKcnIyTVF6UyIKfQ.BelPJ0lBnn5RaW1GwaIXWLPeDCk5vXXFna2rwyzze5549JlYIcXc7q2SKqK22hVFWFcJxpqHjCfDpbfCypLrpA","app-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6IkFQSUdXLUVTMjU2In0.ewogICAgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiYXBpZ2F0ZXdheTphcHBfMTIzNDU2IiwKICAgICJhdWQiOiBbICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgInByb3RlY3RlZC1zdHVmZi5leGFtcGxlLmNvbSJdLAogICAgImF6cCI6ICJhcHBfMTIzNDU2IiwKICAgICJjbGllbnRfaWQiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIlhjT3BRZTJ2cVRxMWtueSIsCiAgICAiZ3JhbnQiOiAiY2xpZW50X2NyZWRlbnRpYWxzIiwKICAgICJvd25pbmdMZWdhbEVudGl0eSI6ICJFeGFtcGxlIENvLiIsCiAgICAic2NvcGVzIjogWwogICAgICAicmV3YXJkczpyZWFkIiwKICAgICAgInJld2FyZHM6cmVkZWVtIgogICAgXSwKICAgICJraWQiOiAiQVBJR1ctRVMyNTYiCn0.q2ES4cOOFSJMBgHGGnZfx6sNQk8UJ21Oejq1_99EVjIvAVZen3ZuN9HWaJjX8VsVjuYPg2pR2OjDk9tQhdI0Qg","subject-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6ImN1c3RJRFAtRVMyNTYifQ.ewogICAgImlzcyI6ICJjdXN0b21lcklkZW50aXR5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiY3VzdG9tZXJJZGVudGl0eTpEQm00RkJjbFNEMjYxRzIiLAogICAgInByb2ZpbGVSZWZJRCI6ICIzNDk4MzU5OHNma2g5dzg3OTg3OThkIiwKICAgICJjdXN0b21lclJlZklEIjogIkRCbTRGQmNsU0QyNjFHMiIsCiAgICAiY29uc2VudElEIjogIjQzNzhhZmQ0ZiIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm84VDJoeHJhZUZ6SVE2cCIsCiAgICAibm9uY2UiOiAibi0wUzZfV3pBMk1qIiwKICAgICJhY3IiOiAidXJuOm1hY2U6aW5jb21tb246aWFwOnNpbHZlciIsCiAgICAiYW1yIjogWwogICAgICAiZmFjZSIsCiAgICAgICJmcHQiLAogICAgICAiZ2VvIiwKICAgICAgIm1mYSIKICAgIF0sCiAgICAidm90IjogIlAxLkNjLkFjIiwKICAgICJ2dG0iOiAiaHR0cHM6Ly9leGFtcGxlLm9yZy92b3QtdHJ1c3QtZnJhbWV3b3JrIgp9.nUztCfQuRZoknUp2_IkefNqUDyVf6HIaJv6hHkLaRv5cX237Kas_W_gWxLIuuhtyZzus4nz92YqdwG93ZfhSFA","session-id":"123456-1","request-id":"123456-2","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICI2MDAwOWNlYzViNTM1MjcwYTBiODM4OWNlYTY3Yzg5NGZhZTk1NDljMTdiMmNlZWY4ZjgyNGNkZTNhMTBiMTRlIiwgImNyZWF0ZWQiOiAxNjAwNTYyNDc1NzU1OTQ1NjYzLCAiaGVhZGVyRGlnZXN0IjogIjg3MzI5YmE4MzgzZmYzOWI0MDc0NmFhMjJlOGQ0ZWU1OGZhY2M1YWM0NzBjYWM0MTBlZmI2ZTU0OWY3NTc0ZmIiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.Ym33kNnuzNVxWh1loAUww4uIOVLcHjwoigZPN2DBtwuqe2DzTEuj449Hsao5GgP44s6OQKHxCINdhx4UHFgAq7RwvdDLf2SYd-_JZhMUvFod0yzIxJbJrhULXmH7lhXlzUtc_m9RqB3-tSjkFdulH5AYlSlPMN_aAo-ADqisAkrsVRYLDBqY3FTqTIauyMVeKQEWUavmTYqhsCbbZARXxe8QLhiVByR4GShRFWV8hlEEAS_MGd6EXqwlCjcsSS6Nmz3WKSj8cYBLM_qaoU6UdbFUmsnsuiipUMlz9NwXq67Opt-MQa5mdMZzcCLqZ2Q_U7iTVxFvzVEsUzdNf7QH9Q","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
emptyBodyAndHeaders = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICJlM2IwYzQ0Mjk4ZmMxYzE0OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1IiwgImNyZWF0ZWQiOiAxNjAwNTYyNjg4MTMyMzcwOTI0LCAiaGVhZGVyRGlnZXN0IjogIjE3NTY5ODliMDhhMWYwYTAzMjM1ODA2ZGExMDQwZmM2MGJkZjZlZWMzYTc2YmEyOWExYjE3MTI1MmRkOTJkZGEiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.QJ_JdJwaXoLkf6_PPSarILFEcb1_Izj3x1lt3kVyzMIBV4T7DJ7FNzpcqU6-xwu_MCa4wAipLkyDX7YoKStjpnFIEP65MtJrVcPEvjhidg5svR9Zj2tBtpmUq7n8r4bhBxgQReG4KGk8FYxogD8TSc47AS721yP-cdi__2ov2-oDSSd1DXDvcuh63FhPqob7wfpsrnzs9tfza2_aiaJ8D_b8ku4zH8cB74RAd051ECsbukticgW3PEDoTCSRs78PzSzeBPccrzE0CQMZSc8qAT63MYa-CfoaKsVgPS3Zv9KO-o7PnJO2Z7stqvvA3IWH48pMPZvbnSjZwTl9lrv2ew","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
missingBodyAndHeaders = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","digest": "eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICJlM2IwYzQ0Mjk4ZmMxYzE0OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1IiwgImNyZWF0ZWQiOiAxNjAwNTYyODU0NzI3MzM2NTAzLCAiaGVhZGVyRGlnZXN0IjogIjQ0MTM2ZmEzNTViMzY3OGExMTQ2YWQxNmY3ZTg2NDllOTRmYjRmYzIxZmU3N2U4MzEwYzA2MGY2MWNhYWZmOGEiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.mRkhrzRV1osp5rroDLPMIyb95dY3w48sPpF2kgWALtFBclf69YPUafhWsMu3Zwyc0Zc2eJBW0D_BWk5z0P8-GbPHgQt-W3ZQ90zh1wtfj6DKHAsDikHcKccepQlmbPm7zpWdPWsgw6RdMEl2KeFCqJuqIebvPWe7owVYydl40IuS4qt_qgSbK532i40vNKi36qvAxCBUQPoCADE6sBAo3ewnxcRI077eZgtY1u3ZqmBDv4POMIERhUqHQyBDkxFLH8EHUkNPPDahsMQyA7-uQxgxZ8gUT4w8Im6ZwQ448gyGyJSTBavTq_rf1L-167Y0nVaBEWgYJE-5J-wC7ZAgBg","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
missingDigest = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
invalidDigest = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICIiLCAiY3JlYXRlZCI6IDE2MDA1NjI2ODgxMzIzNzA5MjQsICJoZWFkZXJEaWdlc3QiOiAiIiwgImhlYWRlcnMiOiBbImFjdG9yLXRva2VuIiwgImFwcC10b2tlbiIsICJzdWJqZWN0LXRva2VuIiwgInNlc3Npb24taWQiLCAicmVxdWVzdC1pZCJdLCAiaG9zdCI6ICJsb2NhbGhvc3Q6ODA4MCIsICJpc3MiOiAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJtZXRob2QiOiAiUE9TVCIsICJwYXRoIjogIi9wb3N0In0.QJ_JdJwaXoLkf6_PPSarILFEcb1_Izj3x1lt3kVyzMIBV4T7DJ7FNzpcqU6-xwu_MCa4wAipLkyDX7YoKStjpnFIEP65MtJrVcPEvjhidg5svR9Zj2tBtpmUq7n8r4bhBxgQReG4KGk8FYxogD8TSc47AS721yP-cdi__2ov2-oDSSd1DXDvcuh63FhPqob7wfpsrnzs9tfza2_aiaJ8D_b8ku4zH8cB74RAd051ECsbukticgW3PEDoTCSRs78PzSzeBPccrzE0CQMZSc8qAT63MYa-CfoaKsVgPS3Zv9KO-o7PnJO2Z7stqvvA3IWH48pMPZvbnSjZwTl9lrv2ew","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
alteredPath = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"localhost:8080",":method":"POST",":path":"/tamperedPath","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICJlM2IwYzQ0Mjk4ZmMxYzE0OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1IiwgImNyZWF0ZWQiOiAxNjAwNTYyNjg4MTMyMzcwOTI0LCAiaGVhZGVyRGlnZXN0IjogIjE3NTY5ODliMDhhMWYwYTAzMjM1ODA2ZGExMDQwZmM2MGJkZjZlZWMzYTc2YmEyOWExYjE3MTI1MmRkOTJkZGEiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.QJ_JdJwaXoLkf6_PPSarILFEcb1_Izj3x1lt3kVyzMIBV4T7DJ7FNzpcqU6-xwu_MCa4wAipLkyDX7YoKStjpnFIEP65MtJrVcPEvjhidg5svR9Zj2tBtpmUq7n8r4bhBxgQReG4KGk8FYxogD8TSc47AS721yP-cdi__2ov2-oDSSd1DXDvcuh63FhPqob7wfpsrnzs9tfza2_aiaJ8D_b8ku4zH8cB74RAd051ECsbukticgW3PEDoTCSRs78PzSzeBPccrzE0CQMZSc8qAT63MYa-CfoaKsVgPS3Zv9KO-o7PnJO2Z7stqvvA3IWH48pMPZvbnSjZwTl9lrv2ew","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/tamperedPath","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
alteredMethod = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"localhost:8080",":method":"PUT",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICJlM2IwYzQ0Mjk4ZmMxYzE0OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1IiwgImNyZWF0ZWQiOiAxNjAwNTYyNjg4MTMyMzcwOTI0LCAiaGVhZGVyRGlnZXN0IjogIjE3NTY5ODliMDhhMWYwYTAzMjM1ODA2ZGExMDQwZmM2MGJkZjZlZWMzYTc2YmEyOWExYjE3MTI1MmRkOTJkZGEiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.QJ_JdJwaXoLkf6_PPSarILFEcb1_Izj3x1lt3kVyzMIBV4T7DJ7FNzpcqU6-xwu_MCa4wAipLkyDX7YoKStjpnFIEP65MtJrVcPEvjhidg5svR9Zj2tBtpmUq7n8r4bhBxgQReG4KGk8FYxogD8TSc47AS721yP-cdi__2ov2-oDSSd1DXDvcuh63FhPqob7wfpsrnzs9tfza2_aiaJ8D_b8ku4zH8cB74RAd051ECsbukticgW3PEDoTCSRs78PzSzeBPccrzE0CQMZSc8qAT63MYa-CfoaKsVgPS3Zv9KO-o7PnJO2Z7stqvvA3IWH48pMPZvbnSjZwTl9lrv2ew","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"PUT","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
alteredHost = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"tamperedHost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICJlM2IwYzQ0Mjk4ZmMxYzE0OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1IiwgImNyZWF0ZWQiOiAxNjAwNTYyNjg4MTMyMzcwOTI0LCAiaGVhZGVyRGlnZXN0IjogIjE3NTY5ODliMDhhMWYwYTAzMjM1ODA2ZGExMDQwZmM2MGJkZjZlZWMzYTc2YmEyOWExYjE3MTI1MmRkOTJkZGEiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.QJ_JdJwaXoLkf6_PPSarILFEcb1_Izj3x1lt3kVyzMIBV4T7DJ7FNzpcqU6-xwu_MCa4wAipLkyDX7YoKStjpnFIEP65MtJrVcPEvjhidg5svR9Zj2tBtpmUq7n8r4bhBxgQReG4KGk8FYxogD8TSc47AS721yP-cdi__2ov2-oDSSd1DXDvcuh63FhPqob7wfpsrnzs9tfza2_aiaJ8D_b8ku4zH8cB74RAd051ECsbukticgW3PEDoTCSRs78PzSzeBPccrzE0CQMZSc8qAT63MYa-CfoaKsVgPS3Zv9KO-o7PnJO2Z7stqvvA3IWH48pMPZvbnSjZwTl9lrv2ew","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"tamperedHost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
alteredHeaders = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"tamperedHeader","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICJlM2IwYzQ0Mjk4ZmMxYzE0OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1IiwgImNyZWF0ZWQiOiAxNjAwNTYyNjg4MTMyMzcwOTI0LCAiaGVhZGVyRGlnZXN0IjogIjE3NTY5ODliMDhhMWYwYTAzMjM1ODA2ZGExMDQwZmM2MGJkZjZlZWMzYTc2YmEyOWExYjE3MTI1MmRkOTJkZGEiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.QJ_JdJwaXoLkf6_PPSarILFEcb1_Izj3x1lt3kVyzMIBV4T7DJ7FNzpcqU6-xwu_MCa4wAipLkyDX7YoKStjpnFIEP65MtJrVcPEvjhidg5svR9Zj2tBtpmUq7n8r4bhBxgQReG4KGk8FYxogD8TSc47AS721yP-cdi__2ov2-oDSSd1DXDvcuh63FhPqob7wfpsrnzs9tfza2_aiaJ8D_b8ku4zH8cB74RAd051ECsbukticgW3PEDoTCSRs78PzSzeBPccrzE0CQMZSc8qAT63MYa-CfoaKsVgPS3Zv9KO-o7PnJO2Z7stqvvA3IWH48pMPZvbnSjZwTl9lrv2ew","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}
alteredBody = {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.22.0.4"}}}},"metadata_context":{},"request":{"http":{"body":"tamperedBody","headers":{":authority":"localhost:8080",":method":"POST",":path":"/post","accept":"*/*","content-length":"62","content-type":"application/json","user-agent":"curl/7.61.0","x-envoy-auth-partial-body":"false","x-forwarded-proto":"http","actor-token":"","app-token":"","subject-token":"","session-id":"","request-id":"","digest":"eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCJ9.eyJhdWQiOiBbImFwaWdhdGV3YXkuZXhhbXBsZS5jb20iLCAicHJvdGVjdGVkLWFwaS5leGFtcGxlLmNvbSJdLCAiYm9keURpZ2VzdCI6ICJlM2IwYzQ0Mjk4ZmMxYzE0OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1IiwgImNyZWF0ZWQiOiAxNjAwNTYyNjg4MTMyMzcwOTI0LCAiaGVhZGVyRGlnZXN0IjogIjE3NTY5ODliMDhhMWYwYTAzMjM1ODA2ZGExMDQwZmM2MGJkZjZlZWMzYTc2YmEyOWExYjE3MTI1MmRkOTJkZGEiLCAiaGVhZGVycyI6IFsiYWN0b3ItdG9rZW4iLCAiYXBwLXRva2VuIiwgInN1YmplY3QtdG9rZW4iLCAic2Vzc2lvbi1pZCIsICJyZXF1ZXN0LWlkIl0sICJob3N0IjogImxvY2FsaG9zdDo4MDgwIiwgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgIm1ldGhvZCI6ICJQT1NUIiwgInBhdGgiOiAiL3Bvc3QifQ.QJ_JdJwaXoLkf6_PPSarILFEcb1_Izj3x1lt3kVyzMIBV4T7DJ7FNzpcqU6-xwu_MCa4wAipLkyDX7YoKStjpnFIEP65MtJrVcPEvjhidg5svR9Zj2tBtpmUq7n8r4bhBxgQReG4KGk8FYxogD8TSc47AS721yP-cdi__2ov2-oDSSd1DXDvcuh63FhPqob7wfpsrnzs9tfza2_aiaJ8D_b8ku4zH8cB74RAd051ECsbukticgW3PEDoTCSRs78PzSzeBPccrzE0CQMZSc8qAT63MYa-CfoaKsVgPS3Zv9KO-o7PnJO2Z7stqvvA3IWH48pMPZvbnSjZwTl9lrv2ew","x-request-id":"e57e2ce7-6c6f-41c2-a26d-4ffa0469c4dd"},"host":"localhost:8080","id":"7329120557391604930","method":"POST","path":"/post","protocol":"HTTP/1.1","size":62},"time":{"nanos":660785000,"seconds":1600543206}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":44932},"address":"172.22.0.1"}}}}},"parsed_body":{"bodyKey1":"bodyValue1","bodyKey2":"bodyValue2"},"parsed_path":["post"],"parsed_query":{},"truncated_body":false}

test_fully_populated_signed_req_allowed {
    allow.allowed with input as fullyPopulated
}

test_empty_body_and_headers_req_allowed {
    allow.allowed with input as emptyBodyAndHeaders
}

test_missing_body_and_headers_req_allowed {
    allow.allowed with input as missingBodyAndHeaders
}

test_missing_digest_not_allowed {
    not allow.allowed with input as missingDigest
    not verified_digest.isValid with input as missingDigest
}

test_invalid_digest_not_allowed {
    not allow.allowed with input as invalidDigest
    not verified_digest.isValid with input as invalidDigest
}

test_altered_path_not_allowed {
    not allow.allowed with input as alteredPath
    verified_digest.isValid with input as alteredPath
    not decision with input as alteredPath
    bodiesMatch with input as alteredPath
    headersMatch with input as alteredPath
    hostsMatch  with input as alteredPath
    methodsMatch  with input as alteredPath
    not pathsMatch  with input as alteredPath
    # We would also write tests for "messages": [], if this was for production use
    # we would also test withinRecencyWindow if this was production
}

test_altered_method_not_allowed {
    not allow.allowed with input as alteredMethod
    verified_digest.isValid with input as alteredMethod
    not decision with input as alteredMethod
    bodiesMatch with input as alteredMethod
    headersMatch with input as alteredMethod
    hostsMatch with input as alteredMethod
    not methodsMatch with input as alteredMethod
    pathsMatch with input as alteredMethod
    # We would also write tests for "messages": [], if this was for production use
    # we would also test withinRecencyWindow if this was production    
}

test_altered_host_not_allowed {
    not allow.allowed with input as alteredHost
    verified_digest.isValid with input as alteredHost
    not decision with input as alteredHost
    bodiesMatch with input as alteredHost
    headersMatch with input as alteredHost
    not hostsMatch with input as alteredHost
    methodsMatch with input as alteredHost
    pathsMatch with input as alteredHost
    # We would also write tests for "messages": [], if this was for production use
    # we would also test withinRecencyWindow if this was production        
}

test_altered_headers_not_allowed {
    not allow.allowed with input as alteredHeaders
    verified_digest.isValid with input as alteredHeaders
    not decision with input as alteredHeaders
    bodiesMatch with input as alteredHeaders
    not headersMatch with input as alteredHeaders
    hostsMatch with input as alteredHeaders
    methodsMatch with input as alteredHeaders
    pathsMatch with input as alteredHeaders
    # We would also write tests for "messages": [], if this was for production use
    # we would also test withinRecencyWindow if this was production        
}

test_altered_bodies_not_allowed {
    not allow.allowed with input as alteredBody
    verified_digest.isValid with input as alteredBody
    not decision with input as alteredBody
    not bodiesMatch with input as alteredBody
    headersMatch with input as alteredBody
    hostsMatch with input as alteredBody
    methodsMatch with input as alteredBody
    pathsMatch with input as alteredBody
    # We would also write tests for "messages": [], if this was for production use
    # we would also test withinRecencyWindow if this was production        
}
