
# Getting Started with Envoy & Open Policy Agent --- 08 ---
## Learn how to configure Envoy's access logs, taps for capturing full requests & responses and traces for capturing end to end flow


``` bash
curl --location --request POST 'localhost:8000/anything' \
>         --header 'Content-Type: application/json' \
>         --header 'Accept: application/json' \
>         --header 'Actor-Token: some_user' \
>         --header 'App-Token: some_app' \
>         --header 'Subject-Token: some_subject' \
>         --header 'Session-Id: 0001' \
>         --header 'Request-Id: 0001' \
>         --data-raw "{\"body-key\":\"body-value\"}"
```

``` json
{
  "args": {}, 
  "data": "{\"body-key\":\"body-value\"}", 
  "files": {}, 
  "form": {}, 
  "headers": {
    "Accept": "application/json", 
    "Actor-Token": "some_user", 
    "App-Token": "some_app", 
    "Content-Length": "25", 
    "Content-Type": "application/json", 
    "Digest": "...", 
    "Host": "localhost:8000", 
    "Request-Id": "0001", 
    "Session-Id": "0001", 
    "Subject-Token": "some_subject", 
    "User-Agent": "curl/7.61.0", 
    "Valid-Request": "true", 
    "X-B3-Parentspanid": "8f0ca43d8048a62d", 
    "X-B3-Sampled": "1", 
    "X-B3-Spanid": "6bfec515a48ab6f7", 
    "X-B3-Traceid": "8f0ca43d8048a62d", 
    "X-Envoy-Expected-Rq-Timeout-Ms": "15000", 
    "X-Envoy-Internal": "true"
  }, 
  "json": {
    "body-key": "body-value"
  }, 
  "method": "POST", 
  "origin": "172.27.0.1", 
  "url": "http://localhost:8000/anything"
}
```