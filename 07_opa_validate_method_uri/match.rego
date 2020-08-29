package uri.matching

endpoints = [{"id":"001","method":"GET","pattern":"/api/customer"},{"id":"002","method":"POST","pattern":"/api/customer"},{"id":"003","method":"DELETE","pattern":"/api/customer/*"},{"id":"004","method":"GET","pattern":"/api/customer/*"},{"id":"005","method":"POST","pattern":"/api/customer/*"},{"id":"006","method":"PUT","pattern":"/api/customer/*"},{"id":"007","method":"GET","pattern":"/api/customer/*/account"},{"id":"008","method":"POST","pattern":"/api/customer/*/account"},{"id":"009","method":"DELETE","pattern":"/api/customer/*/account/*"},{"id":"010","method":"GET","pattern":"/api/customer/*/account/*"},{"id":"011","method":"PUT","pattern":"/api/customer/*/account/*"},{"id":"012","method":"GET","pattern":"/api/customer/*/messages"},{"id":"013","method":"POST","pattern":"/api/customer/*/messages"},{"id":"014","method":"DELETE","pattern":"/api/customer/*/messages/*"},{"id":"015","method":"GET","pattern":"/api/customer/*/messages/*"},{"id":"016","method":"POST","pattern":"/api/customer/*/messages/*"},{"id":"017","method":"PUT","pattern":"/api/customer/*/messages/*"},{"id":"018","method":"GET","pattern":"/api/customer/*/order"},{"id":"019","method":"POST","pattern":"/api/customer/*/order"},{"id":"020","method":"DELETE","pattern":"/api/customer/*/order/*"},{"id":"021","method":"GET","pattern":"/api/customer/*/order/*"},{"id":"022","method":"POST","pattern":"/api/customer/*/order/*"},{"id":"023","method":"PUT","pattern":"/api/customer/*/order/*"},{"id":"024","method":"GET","pattern":"/api/customer/*/paymentcard"},{"id":"025","method":"POST","pattern":"/api/customer/*/paymentcard"},{"id":"026","method":"DELETE","pattern":"/api/customer/*/paymentcard/*"},{"id":"027","method":"GET","pattern":"/api/customer/*/paymentcard/*"},{"id":"028","method":"POST","pattern":"/api/customer/*/paymentcard/*"},{"id":"029","method":"PUT","pattern":"/api/customer/*/paymentcard/*"},{"id":"030","method":"DELETE","pattern":"/api/featureFlags"},{"id":"031","method":"GET","pattern":"/api/featureFlags"},{"id":"032","method":"POST","pattern":"/api/featureFlags"},{"id":"033","method":"PUT","pattern":"/api/featureFlags"},{"id":"034","method":"GET","pattern":"/api/order"},{"id":"035","method":"POST","pattern":"/api/order"},{"id":"036","method":"DELETE","pattern":"/api/order/*"},{"id":"037","method":"GET","pattern":"/api/order/*"},{"id":"038","method":"POST","pattern":"/api/order/*"},{"id":"039","method":"PUT","pattern":"/api/order/*"},{"id":"040","method":"GET","pattern":"/api/order/*/payment"},{"id":"041","method":"POST","pattern":"/api/order/*/payment"},{"id":"042","method":"DELETE","pattern":"/api/order/*/payment/*"},{"id":"043","method":"GET","pattern":"/api/order/*/payment/*"},{"id":"044","method":"POST","pattern":"/api/order/*/payment/*"},{"id":"045","method":"PUT","pattern":"/api/order/*/payment/*"},{"id":"046","method":"GET","pattern":"/api/product"},{"id":"047","method":"POST","pattern":"/api/product"},{"id":"048","method":"DELETE","pattern":"/api/product/*"},{"id":"049","method":"GET","pattern":"/api/product/*"},{"id":"050","method":"POST","pattern":"/api/product/*"},{"id":"051","method":"PUT","pattern":"/api/product/*"},{"id":"052","method":"GET","pattern":"/api/shipment"},{"id":"053","method":"POST","pattern":"/api/shipment"},{"id":"054","method":"DELETE","pattern":"/api/shipment/*"},{"id":"055","method":"GET","pattern":"/api/shipment/*"},{"id":"056","method":"POST","pattern":"/api/shipment/*"},{"id":"057","method":"PUT","pattern":"/api/shipment/*"}]

testCases = [{"method":"GET","path":"/api/customer"},{"method":"POST","path":"/api/customer"},{"method":"GET","path":"/api/customer/12345"},{"method":"POST","path":"/api/customer/12345"},{"method":"PUT","path":"/api/customer/12345"},{"method":"DELETE","path":"/api/customer/12345"},{"method":"GET","path":"/api/customer/12345/account"},{"method":"POST","path":"/api/customer/12345/account"},{"method":"PUT","path":"/api/customer/12345/account/12345"},{"method":"DELETE","path":"/api/customer/12345/account/12345"},{"method":"GET","path":"/api/customer/12345/messages"},{"method":"POST","path":"/api/customer/12345/messages"},{"method":"GET","path":"/api/customer/12345/messages/12345"},{"method":"POST","path":"/api/customer/12345/messages/12345"},{"method":"PUT","path":"/api/customer/12345/messages/12345"},{"method":"DELETE","path":"/api/customer/12345/messages/12345"},{"method":"GET","path":"/api/customer/12345/order"},{"method":"POST","path":"/api/customer/12345/order"},{"method":"GET","path":"/api/customer/12345/order/12345"},{"method":"POST","path":"/api/customer/12345/order/12345"},{"method":"PUT","path":"/api/customer/12345/order/12345"},{"method":"DELETE","path":"/api/customer/12345/order/12345"},{"method":"GET","path":"/api/customer/12345/paymentcard"},{"method":"POST","path":"/api/customer/12345/paymentcard"},{"method":"GET","path":"/api/customer/12345/paymentcard/12345"},{"method":"POST","path":"/api/customer/12345/paymentcard/12345"},{"method":"PUT","path":"/api/customer/12345/paymentcard/12345"},{"method":"DELETE","path":"/api/customer/12345/paymentcard/12345"},{"method":"GET","path":"/api/featureFlags"},{"method":"POST","path":"/api/featureFlags"},{"method":"PUT","path":"/api/featureFlags"},{"method":"DELETE","path":"/api/featureFlags"},{"method":"GET","path":"/api/order"},{"method":"POST","path":"/api/order"},{"method":"GET","path":"/api/order/12345"},{"method":"POST","path":"/api/order/12345"},{"method":"PUT","path":"/api/order/12345"},{"method":"DELETE","path":"/api/order/12345"},{"method":"GET","path":"/api/order/12345/payment"},{"method":"POST","path":"/api/order/12345/payment"},{"method":"GET","path":"/api/order/12345/payment/12345"},{"method":"POST","path":"/api/order/12345/payment/12345"},{"method":"PUT","path":"/api/order/12345/payment/12345"},{"method":"DELETE","path":"/api/order/12345/payment/12345"},{"method":"GET","path":"/api/product"},{"method":"POST","path":"/api/product"},{"method":"GET","path":"/api/product/12345"},{"method":"POST","path":"/api/product/12345"},{"method":"PUT","path":"/api/product/12345"},{"method":"DELETE","path":"/api/product/12345"},{"method":"GET","path":"/api/shipment"},{"method":"POST","path":"/api/shipment"},{"method":"GET","path":"/api/shipment/12345"},{"method":"POST","path":"/api/shipment/12345"},{"method":"PUT","path":"/api/shipment/12345"},{"method":"DELETE","path":"/api/shipment/12345"}]
# comment


#function to check if a single test case matches a URI pattern
getEndpointID( method, rawPath ) = epID {
  some i
  endpoints[i].method == method
  p := lower( trim_right( rawPath, "/") )  #strip trailing slash if present
  glob.match( lower(endpoints[i].pattern), ["/"], p)
  epID := endpoints[i].id
}

getPattern( epID ) = epPath {
  some i
  endpoints[i].id == epID
  epPath := endpoints[i].pattern
}

uriMatches[ test ] {
    some j; 
    idMatched := getEndpointID( testCases[j].method, testCases[j].path)
    patternMatched := getPattern( idMatched )
    test := { 
        "path___": testCases[j].path,
        "pattern": patternMatched,
        "endPointID" : idMatched,
        "method": testCases[j].method,
        "testID": j
    }
}

uriErrors[ test ] {
    some j; 
    not getEndpointID( testCases[j].method, testCases[j].path)
    test := { 
        "path": testCases[j].path,
        "method": testCases[j].method,
        "testID": j
    }
}
