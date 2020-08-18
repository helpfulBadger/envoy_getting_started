#!/bin/bash
opa eval -i allowed_input.json -d policy.rego 'data.istio.authz.allow'
