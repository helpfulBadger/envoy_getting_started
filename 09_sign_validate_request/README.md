
# Getting Started with Envoy & Open Policy Agent --- 09 ---
## Learn how to use Envoy & OPA to sign and validate HTTP Requests

This is the 9th Envoy & Open Policy Agent Getting Started Guide. Each guide is intended to explore a single feature and walk through a simple implementation. Each guide builds on the concepts explored in the previous guide with the end goal of building a very powerful authorization service by the end of the series. 

The source code for this getting started example is located on Github. <span style="color:blue"> ------>  [Envoy & OPA GS # 9](https://github.com/helpfulBadger/envoy_getting_started/tree/master/09_sign_validate_request) </span>


Here is a list of the Getting Started Guides that are currently available.

## Getting Started Guides

## Getting Started Guides

1. [Using Envoy as a Front Proxy](../01_front_proxy/README.md) --- Learn how to set up Envoy as a front proxy with docker
1. [Adding Observability Tools](../02_front_proxy_kibana/README.md) --- Learn how to add ElasticSearch and Kibana to your Envoy front proxy environment
1. [Plugging Open Policy Agent into Envoy](../03_opa_integration/README.md) --- Learn how to use Open Policy Agent with Envoy for more powerful authorization rules
1. [Using the Open Policy Agent CLI](../04_opa_cli/README.md) --- Learn how to use Open Policy Agent Command Line Interface
1. [JWS Token Validation with OPA](../05_opa_validate_jws/README.md) --- Learn how to validate JWS Tokens with Open Policy Agent
1. [JWS Token Validation with Envoy](../06_envoy_validate_jws/README.md) --- Learn how to validate JWS Tokens natively with Envoy
1. [Putting It All Together with Composite Authorization](../07_opa_validate_method_uri/README.md) --- Learn how to Implement Application Specific Authorization Rules
1. [Configuring Envoy Logs Taps and Traces](../08_log_taps_traces/README.md) --- Learn how to configure Envoy's access logs taps for capturing full requests & responses and traces
1. [Sign / Verify HTTP Requests](../09_sign_validate_request/README.md) --- Learn how to use Envoy & OPA to sign and validate HTTP Requests


## Introduction

In this example we are going to show how we can use Envoy and Open Policy Agent to sign HTTP requests as we come through a front proxy and validate these signatures on a 2nd Envoy / Open Policy Agent instance that is dedicated to the endpoint that we are protecting. 

The diagram below shows system and request flow that we will be building. 

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/10/Envoy_GS_09_Overview.svg" /><br>

Signing and validating signatures on a request is very useful in large environments where a request may traverse a number of different application layers, proxies and other components that are owned by a variety of teams. Some of those components may even be controlled by 3rd parties. 


> A digital signature is a mathematical scheme for verifying the authenticity of digital messages or documents. A valid digital signature, where the prerequisites are satisfied, gives a recipient very strong reason to believe that the message was created by a known sender (authentication), and that the message was not altered in transit (integrity).[1]

> Digital signatures are a standard element of most cryptographic protocol suites, and are commonly used for software distribution, financial transactions, contract management software, and in other cases where it is important to detect forgery or tampering.

> Source: [Wikipedia](https://en.wikipedia.org/wiki/Digital_signature)

Digital signatures can be a great tool to prevent internal fraud. In large corporations it is common to utilize centralized log aggregation tools. These tools are often open to all employees / workforce users that have valid credentials. This is a great practice for transparency, understanding dependencies, troubleshooting etc. However, sometimes:
1. Novice engineers or engineers that are not used to working in large corporations may log sensitive data elements such as access tokens or other headers that can be used to forge a malicious request that moves money, purchases a product etc. 
1. 3rd Parties such as a cloud provider that operates an API gateway, a lambda product or any other product that acts as a proxy to your code will have access to the entire request / response stream. They have their own logs. A malicious engineer at the cloud provider can log and alter or forge any request / response flowing through their products whenever a TLS connection is terminated by their product.

## Walking through the docker-compose file

Link to <span style="color:blue">[compose file](https://github.com/helpfulBadger/envoy_getting_started/blob/master/09_sign_validate_request/docker-compose.yaml)</span>

**Envoy Instances**

As shown in the highlighted rows (lines 6 & 13), each Envoy proxy is built from dockerfiles located in their own directories. Additionally, since we have traces turned on, we mapped local volumes (lines 8 & 15) into the Envoy containers to capture and expose the captured requests and responses. For more information on how to set this up, there is a <span style="color:blue">[getting started guide](/blog/envoy_opa_8_logs_taps_and_traces.md)</span> for it. 

</br>

<strong>

``` yaml {linenos=inline,hl_lines=[1,3,5,7,9,11,13,15],linenostart=1}
version: "3.7"
services:

  front-envoy:
    build:
>      context: ./front-proxy
    volumes:
>      - ./tmp/front:/tmp/any
    ...

  service1:
    build:
>      context: ./service1
    volumes:
>      - ./tmp/service1:/tmp/any
    ...
```

</strong>

**Open Policy Agent Instances**

As shown in the highlighted rows (lines 3 & 15), just like the Envoy instances, each Open Policy Agent instance is built from dockerfiles located in their own directories. The policy files (lines 11 & 23) are consistently named but have different content and purposes.

<strong>

``` yaml {linenos=inline,hl_lines=[1,3,5,7,9,11,13,15,17,19,21,23],linenostart=1}
  sign:
    build:
#      context: ./sign
    ...
    command:
      - "run"
      - "--log-level=debug"
      - "--server"
      - "--set=plugins.envoy_ext_authz_grpc.addr=:9191"
      - "--set=decision_logs.console=true"
#      - "/config/policy.rego"

  verify:
    build:
#      context: ./verify
    ...
    command:
      - "run"
      - "--log-level=debug"
      - "--server"
      - "--set=plugins.envoy_ext_authz_grpc.addr=:9191"
      - "--set=decision_logs.console=true"
#      - "/config/policy.rego"

```

</strong>

## Walking through the signing policy

Link to <span style="color:blue">[signing policy](https://github.com/helpfulBadger/envoy_getting_started/blob/master/09_sign_validate_request/sign/policy.rego)</span>


As a request flows through a complex set of systems, a lot of headers are injected and / or removed on various hops. These headers might be used for:
* Routing
* Injecting or updating tracing headers
* Injecting or removing other headers that are meaningful to the proxies

Our signature needs to survive these transformations. We need to make sure we declare what should not change and then only include that in the signature. To help use communicate these pieces of information to the recipient, we will be creating a signed JSON web token to hold our HTTP request signature. 

Let's walk through some highlights of the REGO Policy file. 
* We need a private signing key to ensure that the signature has not been tampered with. This is declared on line 5 but would be retrieved from a key management system in a production deployment. <br><br>
* The headers that we want to remain unchanged throughout the process are declared on line 8. These include some other JWS tokens. These tokens prove the identity of the user, the application originating the request, the subject / entity that is being acting on behalf of (if applicable). Additionally, for troubleshooting purposes, we have bound the session-id and request-id into the signature to ensure traceability outside of any open tracing solutions. <br><br>

### Calculating a hash of the headers

* There are 3 steps required to calculate the hash of the headers. 
    1. The first step on line 11 is to create a new object that only contains the headers of interest from the original request. The `object.filter()` rego built in function does that for us. It takes 2 parameters. The headers we want to include in the new object and the original object that we need to pull them from. 
    1. We convert the object to a JSON string on line 12, `json.marshal`. This REGO built-in function consistently orders the keys in the resulting output string. If this was not the case, then we would not be able to use REGO for this. 
    1. Finally, we calculate the hash of the headers with the `crypto.sha256()` built in function.

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7,9,11,13],linenostart=1}
package envoy.authz

import input.attributes.request.http as http_request

signingKey = { ... } // Private Key for creating the signature

// Headers that we would like included in the signature
criticalHeaders = ["actor-token", "app-token", "subject-token", "session-id", "request-id"]

// We calculate the header hash by ... 
filteredHeaders = object.filter( http_request.headers, criticalHeaders )	
headerString = json.marshal( filteredHeaders )
headerHash = crypto.sha256( headerString )
```

</strong><br>

### Calculating a Hash of the Body

* We need to ensure the body is initialized before calculating a hash for it. Line 16 sets the body to an empty string. 
* If `http_request.body` on line 18 is missing then the default value (empty string) is assigned to the body variable.
* Then we can calculate the hash of the body using the `crypto.sha256( body )` built in function on line 21

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7],linenostart=14}
// Ensure the request body is initialized and fetch the request's body if one is present
default body = ""
body = b {
  b := http_request.body
}

// Then calculate the hash for the request body
bodyHash = crypto.sha256( body )
```

</strong><br>

### Communicating our signature

Now that we have the hash of our headers and body, we need to gather all of the information that we want to put into our signature. We will lock all of this information together by binding it into a JWS token. We will use some standard claims and create some custom claims as well.  

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7,9,11,13],linenostart=22}
requestDigest = {
  "iss": "apigateway.example.com",
  "aud": [ "protected-api.example.com"],
  "host": http_request.host,
  "method": http_request.method,
  "path": http_request.path,
  "created": time.now_ns(),
  "headers": criticalHeaders,
  "headerDigest": headerHash,
  "bodyDigest": bodyHash
}

digestHeader = io.jwt.encode_sign({ "typ": "JWT", "alg": "RS256" }, requestDigest, signingKey )
```

</strong>

* The system sending the request identifies itself as the issuer (line 23).
* We can also specify the recipient of the request (line 24).
* Since the JWS is signed, we can simply copy the host, method, & resource path (lines 25-27).
* A timestamp (line 28) informs the recipient of how long the token has been in transit. The recipient can determine how long to honor a request.
* The recipient needs to know which headers (line 29) were included in the header hash and of course it needs to know the hash (line 30).
* The recipient also needs to know what the hash of the body is (line 31).
* Finally, we create our JWS by passing our JWT object, our signing key and some parameters to specify the signing algorthim into the io.`jwt.encode_sign()` built in function. 

<br>

### Handing off to Envoy to add the signature to the request

With the signature calculated, all that remains to be done is to attach it to the outbound request. 
* As we learned previously, when using the external authorization feature, we can tell Envoy to insert or update headers by setting the header name and its value inside a headers object. In our case, we don't want to interfere with any other authorization mechanisms that are in use in the environment. So, instead of putting our signature in the authorization header, we will create a Digest header (line 38).
* Our OPA policy wasn't evaluating any real authorization rules. So we will always set the `allowed` variable to true (line 36).
* We could implement this as a **service mesh sidecar** to sign all outbound requests on behalf of an application.
* In a **front proxy** use case, we most likely would have run other rules before signing the request and forwarding it to it's ultimate destination.

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5],linenostart=35}
allow = {
  "allowed": true, # Outbound requests are always allowed. This policy simply signs the request
  "headers": {
    "Digest": digestHeader
  }
}
```

</strong><br>

### Tests for the signing policy

Link to <span style="color:blue">[signing policy tests](https://github.com/helpfulBadger/envoy_getting_started/blob/master/09_sign_validate_request/sign/policy_test.rego)</span>

The signatures should work equally well whether each of the fields we are signing is present and populated, present but empty or missing entirely. This will ensure that if a field is optional, the signature will still be created and if a fake value is inserted it can still be detected.

For each of these use cases we the precalculated the hashes for a given input. 
* The `fullyPopulated` variable (line 5) is used to simulate the input received from Envoy. 
* The `fullyPopulatedJws` variable  (line 6) is the precalculated JWS token that represents our signature.
* We can directly refer to variables in our main REGO policy from their associated tests. 
* On lines 11, 15 and 19 we test to see if those variables contain our expected results. 
* This same pattern is repeated for the 'empty' and 'missing' use cases. 

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7,9,11,13,15,17,19],linenostart=1}
package envoy.authz

fullyPopulated = { ... }
fullyPopulatedJws = {
    "bodyDigest": "60009cec5b535270a0b8389cea67c894fae9549c17b2ceef8f824cde3a10b14e",
    "headerDigest": "87329ba8383ff39b40746aa22e8d4ee58facc5ac470cac410efb6e549f7574fb",
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
```

</strong><br>

## Validating the signature upon Receipt 

Link to <span style="color:blue">[signature verification policy](https://github.com/helpfulBadger/envoy_getting_started/blob/master/09_sign_validate_request/verify/policy.rego)</span>


### Extracting the signature from the request

The first part of the policy:
* Extracts the digest from the incoming request header
* Validates the JWS Digest token
* Places the contents of the validated token in a variable for other rules

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7,9,11,13,15,17],linenostart=1}
package envoy.authz

import input.attributes.request.http as http_request
import input.attributes.request.http.headers["digest"] as digest

jwks = `{...}`

verified_digest = v {
  [isValid, _, payload ] := io.jwt.decode_verify( digest, 
  { 
      "cert": jwks,
      "aud": "apigateway.example.com"  // <-- Required since the token contains an `aud` claim in the payload
  })
  v := {
    "isValid": isValid,
    "payload": payload
  }
}
```

</strong>

* Line 4: Extracts the request's signature token from the Digest header
* Line 8: If validated, sets a variable to hold the decoded token payload
* Line 9: Decodes and validates the token using the `io.jwt.decode_verify()` built-in function
* Line 11: Provides the decode function the public keys it needs to validate the signature
* Line 12: We must provide an expected audience claim when the token contains an audience claim.  The audience claim is an array. If any member of that array matches the supplied audience then that validation rule will pass. 
* Line 14: Assigns the decoded token to named properties in an object that in turn is assigned to the `verified_digest`

<br>

### Comparing the request to the validated token

Now we can do the important part and compare the values in the request with what was preserved in the JWS token. 

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7,9,11,13,15,17,19],linenostart=19}
headersMatch {
  headerHash == verified_digest.payload.headerDigest
}
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
```

</strong>

* Line 20: The list of critical headers from the JWS token is used to filter the request's headers and calculate a hash using the same statements that were used in the signing process (not shown). If they match then `headersMatch` is set to true.
* Line 23: The request's body is extracted and used to calculate a hash using the same statements that were used in the signing process (not shown).  If they match then `bodiesMatch` is set to true.
* Lines 26, 29 & 32: Since these values are captured directly in the token, no special processing is required. They are simply compared to see if they have been altered.

<br>

### Checking Request Recency

We don't want to leave an unbounded amount of time for a request to be processed. The next section of the policy checks to see if the request was initiated recently enough.

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5],linenostart=34}
requestDuration = time.now_ns() - verified_digest.payload.created

withinRecencyWindow {
  requestDuration < 34159642955430000
}
```

</strong>

* Line 34: uses the built-in function `time.now_ns()` to calculate the time passed since the request was initiated.
* Line 37: Uses the calculated request duration and compares it to our business rule

<br>

### Generating Rule Failure Messages

An this side of the connection our messages need 2 conditions to properly know which rules failed. 

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7,9],linenostart=39}
messages[ msg ]{
  verified_digest.isValid
	not headersMatch
  msg := {
    "id"  : "7",
    "priority"  : "5",
    "message" : "Critical request headers do not match signature"
  }
}
```

</strong>

* Line 40: If the digest token is simply missing or corrupt, we don't want to return messages for every single rule that failed. If the signature token is missing entirely, the issue isn't really that the headers don't match. The real issue is that the signature token is missing. So, this guard rule makes sure that we at least had a valid signature token before we check to see if the headers didn't match. 
* Line 41: If the headers don't match then we return message indicating that. 
* Numerous other similar rules are in the full policy file (not shown here) testing for similar conditions.

<br>

### Calculating the final decision on the validity of the request

Lines 49 through 55 below calculate the final decision on the validity of the request. When we name our rules intuitively, the decision logic is pretty intuitive as well. In this case the methods, paths, hosts, headers and bodies must all 

<strong>

``` javascript {linenos=inline,hl_lines=[1,3,5,7,9,11,13,15,17,19,21,23],linenostart=48}
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
```

</strong>

Line 69: OPA's built-in function `json.marshal()` converts all of the rule failures into a string for sending back to the caller.
The other statements should be familiar from our previous discussion of Envoy's external authorization contract. So, we won't break that down again.

<br>

The <span style="color:blue">[signature verification policy tests](https://github.com/helpfulBadger/envoy_getting_started/blob/master/09_sign_validate_request/verify/policy_test.rego)</span> are more complicated than the tests for the signing process due to increased complexity of the policy. 

# Running the Example

Simply run the `./demonstrate_sign_verify.sh` script to see request signing and verification in action. The example scripts leverage the same logs, taps and traces configuration as Getting started guide # 8. 

Link to script to run <span style="color:blue">[the request signing & verification example](https://github.com/helpfulBadger/envoy_getting_started/blob/master/09_sign_validate_request/demonstrate_sign_verify.sh)</span>


# Congratulations

We have completed our example to demonstrate how to sign and validate HTTP requests. This capability is very powerful and effective and protecting the integrity of transactions. The best part about this approach is that this powerful capability can be added to any application in your portfolio without requiring code changes to every system. 
