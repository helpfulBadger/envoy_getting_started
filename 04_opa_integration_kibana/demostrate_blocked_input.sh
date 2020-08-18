#!/bin/bash
opa eval -i blocked_input.json -d policy.rego 'data.istio.authz.allow'
