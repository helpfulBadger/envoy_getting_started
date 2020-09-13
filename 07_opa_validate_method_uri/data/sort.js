var points = [

    { "id": "001", "method": "GET",    "pattern": "/api/customer" },
    { "id": "002", "method": "POST",   "pattern": "/api/customer" },

    { "id": "003", "method": "GET",    "pattern": "/api/customer/*" },
    { "id": "004", "method": "POST",   "pattern": "/api/customer/*" },
    { "id": "004", "method": "PUT",    "pattern": "/api/customer/*" },
    { "id": "005", "method": "DELETE", "pattern": "/api/customer/*" },

    { "id": "006", "method": "GET",    "pattern": "/api/customer/*/account" },
    { "id": "007", "method": "POST",   "pattern": "/api/customer/*/account" },
    { "id": "008", "method": "GET",    "pattern": "/api/customer/*/account/*" },
    { "id": "009", "method": "PUT",    "pattern": "/api/customer/*/account/*" },
    { "id": "010", "method": "DELETE", "pattern": "/api/customer/*/account/*" },
    
    { "id": "011", "method": "GET",    "pattern": "/api/customer/*/order"   },
    { "id": "012", "method": "POST",   "pattern": "/api/customer/*/order"   },
    { "id": "013", "method": "GET",    "pattern": "/api/customer/*/order/*"   },
    { "id": "014", "method": "POST",    "pattern": "/api/customer/*/order/*"   },

    { "id": "014", "method": "PUT",    "pattern": "/api/customer/*/order/*"   },
    { "id": "015", "method": "DELETE", "pattern": "/api/customer/*/order/*"   },
    { "id": "016", "method": "GET",    "pattern": "/api/customer/*/paymentcard" },
    { "id": "017", "method": "POST",   "pattern": "/api/customer/*/paymentcard" },
    { "id": "018", "method": "GET",    "pattern": "/api/customer/*/paymentcard/*" },
    { "id": "019", "method": "POST",    "pattern": "/api/customer/*/paymentcard/*" },

    { "id": "019", "method": "PUT",    "pattern": "/api/customer/*/paymentcard/*" },
    { "id": "020", "method": "DELETE", "pattern": "/api/customer/*/paymentcard/*" },
    { "id": "021", "method": "GET",    "pattern": "/api/customer/*/messages" },
    { "id": "022", "method": "POST",   "pattern": "/api/customer/*/messages" },
    { "id": "023", "method": "GET",    "pattern": "/api/customer/*/messages/*" },
    { "id": "024", "method": "POST",    "pattern": "/api/customer/*/messages/*" },
    { "id": "024", "method": "PUT",    "pattern": "/api/customer/*/messages/*" },
    { "id": "025", "method": "DELETE", "pattern": "/api/customer/*/messages/*" },
    { "id": "026", "method": "GET",    "pattern": "/api/product" },
    { "id": "027", "method": "POST",   "pattern": "/api/product" },
    { "id": "028", "method": "GET",    "pattern": "/api/product/*" },
    { "id": "029", "method": "POST",    "pattern": "/api/product/*" },

    { "id": "029", "method": "PUT",    "pattern": "/api/product/*" },
    { "id": "030", "method": "DELETE", "pattern": "/api/product/*" },
    { "id": "031", "method": "GET",    "pattern": "/api/order"   },
    { "id": "032", "method": "POST",   "pattern": "/api/order"   },
    { "id": "033", "method": "GET",    "pattern": "/api/order/*"   },
    { "id": "034", "method": "POST",    "pattern": "/api/order/*"   },

    { "id": "034", "method": "PUT",    "pattern": "/api/order/*"   },
    { "id": "035", "method": "DELETE", "pattern": "/api/order/*"   },
    { "id": "036", "method": "GET",    "pattern": "/api/order/*/payment" },
    { "id": "037", "method": "POST",   "pattern": "/api/order/*/payment" },
    { "id": "038", "method": "GET",    "pattern": "/api/order/*/payment/*" },
    { "id": "039", "method": "PUT",    "pattern": "/api/order/*/payment/*" },
    { "id": "039", "method": "POSTT",    "pattern": "/api/order/*/payment/*" },

    { "id": "040", "method": "DELETE", "pattern": "/api/order/*/payment/*" },
    { "id": "041", "method": "GET",    "pattern": "/api/shipment" },
    { "id": "042", "method": "POST",   "pattern": "/api/shipment" },
    { "id": "043", "method": "GET",    "pattern": "/api/shipment/*" },
    { "id": "044", "method": "PUT",    "pattern": "/api/shipment/*" },
    { "id": "044", "method": "POST",    "pattern": "/api/shipment/*" },

    { "id": "045", "method": "DELETE", "pattern": "/api/shipment/*" },
    { "id": "046", "method": "GET",    "pattern": "/api/featureFlags" },
    { "id": "047", "method": "POST",   "pattern": "/api/featureFlags" },
    { "id": "048", "method": "PUT",    "pattern": "/api/featureFlags" },
    { "id": "049", "method": "DELETE", "pattern": "/api/featureFlags" }
  
];

function myFunction() {
    let points2 = points.sort( function(a, b){
  	    if (a.pattern === b.pattern) {
    	    if ( a.method === b.method ){
                if (a.id === b.id) return 0
                if (a.id > b.id) return 1
        	    return -1
            }
            if (a.method > b.method) return 1
            return -1
        } 
        if (a.pattern > b.pattern) return 1 
  	    return -1
    });
    return points2
}

console.log( JSON.stringify( myFunction(), null, 2) );
