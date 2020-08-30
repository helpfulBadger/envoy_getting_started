var rawTestData = {
    "givenApp": [
      {
        "id": "app_000123",
        "ActorToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6Indvcmtmb3JjZUlEUC1SUzI1NiJ9.ewogICAgImlzcyI6ICJ3b3JrZm9yY2VJZGVudGl0eS5leGFtcGxlLmNvbSIsCiAgICAic3ViIjogIndvcmtmb3JjZUlkZW50aXR5OjQwNjMxOSIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm1QUGR3SjdKcnIyTVF6UyIKfQ.KH1eJ3QK2uAPuRoWovlEPNJTHlw4FQKn4fAIuBp_AxaQokoqp9XrsaCECFrp_R_MblY6qQnC8WxMdqPpT0u473vKP-3hBXBgC69p3W9CD-U0Nd_X9mFHNtEm9JXGCTvbp6NY8xMRaeyjijw6o43WDlQFvPOv5yW25dxRvbuYHxcmsRssHmGY3-bESQHS18Nbd5eSeviuZ2A84enyJRih1W5ZuyOlpjcxDqZqgKFWbrhcZivRoXQfxxyX2IuAif_AGr2YFXkZQ0-kekJdEmrmQ6rxXdDryMjD4eL61iJj9hqOldAioq2wpvJxLCWDPLLrmpmtYkYr9XzxZiw0Rwwk9A",
        "AppToken": "eyJhbGciOiJFUzI1NiIsImtpZCI6IkFQSUdXLUVTMjU2In0.ewogICAgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiYXBpZ2F0ZXdheTphcHBfMDAwMTIzIiwKICAgICJhdWQiOiBbICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgInByb3RlY3RlZC1zdHVmZi5leGFtcGxlLmNvbSJdLAogICAgImF6cCI6ICJhcHBfMDAwMTIzIiwKICAgICJjbGllbnRfaWQiOiAiYXBwXzAwMDEyMyIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIlhjT3BRZTJ2cVRxNjYxayIsCiAgICAiZ3JhbnQiOiAiY2xpZW50X2NyZWRlbnRpYWxzIiwKICAgICJvd25pbmdMZWdhbEVudGl0eSI6ICJFeGFtcGxlIENvLiIsCiAgICAic2NvcGVzIjogWwogICAgICAicmV3YXJkczpyZWFkIiwKICAgICAgInJld2FyZHM6cmVkZWVtIgogICAgXSwKICAgICJraWQiOiAiQVBJR1ctRVMyNTYiCn0.lAnm0T59ziQOW2VFXzbK5Rn8o-J4vz98OL8YPJBm0DstlQ8BlKmAyZ7RocV7QAYe3CSrEEQkVYxn47hrCTkD7Q"
      },
      {
        "id": "app_123456",
        "ActorToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImN1c3RJRFAtUlMyNTYifQ.ewogICAgImlzcyI6ICJjdXN0b21lcklkZW50aXR5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiY3VzdG9tZXJJZGVudGl0eTpEQm00RkJjbFNEMjYxRzIiLAogICAgInByb2ZpbGVSZWZJRCI6ICIzNDk4MzU5OHNma2g5dzg3OTg3OThkIiwKICAgICJjdXN0b21lclJlZklEIjogIkRCbTRGQmNsU0QyNjFHMiIsCiAgICAiY29uc2VudElEIjogIjQzNzhhZmQ0ZiIsCiAgICAiYXVkIjogWyAiYXBpZ2F0ZXdheS5leGFtcGxlLmNvbSIsICJwcm90ZWN0ZWQtc3R1ZmYuZXhhbXBsZS5jb20iXSwKICAgICJhenAiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIm84VDJoeHJhZUZ6SVE2cCIsCiAgICAibm9uY2UiOiAibi0wUzZfV3pBMk1qIiwKICAgICJhY3IiOiAidXJuOm1hY2U6aW5jb21tb246aWFwOnNpbHZlciIsCiAgICAiYW1yIjogWwogICAgICAiZmFjZSIsCiAgICAgICJmcHQiLAogICAgICAiZ2VvIiwKICAgICAgIm1mYSIKICAgIF0sCiAgICAidm90IjogIlAxLkNjLkFjIiwKICAgICJ2dG0iOiAiaHR0cHM6Ly9leGFtcGxlLm9yZy92b3QtdHJ1c3QtZnJhbWV3b3JrIgp9.iwb5jb5umv4dv8FHH7MGfdLCTKUcZg_J4svPY5ejm8rB-QXKLzP2RWE_VcbSfa3hK8fNPSjj9WyFCv3hozYlppw7PAEZeyeYf6Rh2S6LmWJj2FDMHvI8chjCz2ZdE3JQO_CqPDp_Ok1i6EkBE4-OfZycT7c3-CeQMWXagtmEH5FCJTxM2x_m3xuzbn2NhHdUlhMTAdReh3_Cmr-63ECfDOg_ctRqHZAxzIKPnu0EEJTWBBFZdG7w8q1LaaQcn0FNleaBUL5gXlCBI2yoRtVVZQ3CAmLwKdWQ8iXZOOiYFbuszXXJLgscxM23ufr2AcUKFm4DgxjSUy1YptsQlZy3mQ",
        "AppToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IkFQSUdXLVJTMjU2In0.ewogICAgImlzcyI6ICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwKICAgICJzdWIiOiAiYXBpZ2F0ZXdheTphcHBfMTIzNDU2IiwKICAgICJhdWQiOiBbICJhcGlnYXRld2F5LmV4YW1wbGUuY29tIiwgInByb3RlY3RlZC1zdHVmZi5leGFtcGxlLmNvbSJdLAogICAgImF6cCI6ICJhcHBfMTIzNDU2IiwKICAgICJjbGllbnRfaWQiOiAiYXBwXzEyMzQ1NiIsCiAgICAiZXhwIjogMjczNTY4OTYwMCwKICAgICJpYXQiOiAxNTk3Njc2NzE4LAogICAgImF1dGhfdGltZSI6IDE1OTc2NzY3MTgsCiAgICAianRpIjogIlhjT3BRZTJ2cVRxMWtueSIsCiAgICAiZ3JhbnQiOiAiY2xpZW50X2NyZWRlbnRpYWxzIiwKICAgICJvd25pbmdMZWdhbEVudGl0eSI6ICJFeGFtcGxlIENvLiIsCiAgICAic2NvcGVzIjogWwogICAgICAicmV3YXJkczpyZWFkIiwKICAgICAgInJld2FyZHM6cmVkZWVtIgogICAgXSwKICAgICJraWQiOiAiQVBJR1ctRVMyNTYiCn0.SvHTr8fGCzMSo4Uktw_WqeJGVv9M_--qRPrBiBTz0eJtc21whf32-TcVRBY9i4DS400iGNkMaaeIP15BEmgZ42olS27ngBXB-j_fw7i7hTRBEPS01snwE2uxBiPX-NLmQd8d5LDfTM69lK_cl3vhgMaM6xHDUeTNAftEnCqhSc1lk5leiOYaMiRFA2IsrF1ebyS7MpRtIszauyPE5Yo6j20YCIseoO5ULZj4X715DB2TeCZNTTLTadm-lRFig3EsgJRxNApIMMdN3wyb7qRPi4LXcwj2S91DHuA5AsOy4yd-dnf-OXsTXCB54lKVnPsynL1sxrgWimUSEFmAwS75sA"
      }
    ],
    "givenService": {
      "host": "localhost",
      "port": "8080"
    },
    "givenRequest": [
      {
        "id": "001",
        "method": "GET",
        "pattern": "/api/customer",
        "uri": "/api/customer"
      },
      {
        "id": "002",
        "method": "POST",
        "pattern": "/api/customer",
        "uri": "/api/customer"
      },
      {
        "id": "003",
        "method": "DELETE",
        "pattern": "/api/customer/*",
        "uri": "/api/customer/12345"
      },
      {
        "id": "004",
        "method": "GET",
        "pattern": "/api/customer/*",
        "uri": "/api/customer/12345"
      },
      {
        "id": "005",
        "method": "POST",
        "pattern": "/api/customer/*",
        "uri": "/api/customer/12345"
      },
      {
        "id": "006",
        "method": "PUT",
        "pattern": "/api/customer/*",
        "uri": "/api/customer/12345"
      },
      {
        "id": "007",
        "method": "GET",
        "pattern": "/api/customer/*/account",
        "uri": "/api/customer/12345/account"
      },
      {
        "id": "008",
        "method": "POST",
        "pattern": "/api/customer/*/account",
        "uri": "/api/customer/12345/account"
      },
      {
        "id": "009",
        "method": "DELETE",
        "pattern": "/api/customer/*/account/*",
        "uri": "/api/customer/12345/account/12345"
      },
      {
        "id": "010",
        "method": "GET",
        "pattern": "/api/customer/*/account/*",
        "uri": "/api/customer/12345/account/12345"
      },
      {
        "id": "011",
        "method": "PUT",
        "pattern": "/api/customer/*/account/*",
        "uri": "/api/customer/12345/account/12345"
      },
      {
        "id": "012",
        "method": "GET",
        "pattern": "/api/customer/*/messages",
        "uri": "/api/customer/12345/messages"
      },
      {
        "id": "013",
        "method": "POST",
        "pattern": "/api/customer/*/messages",
        "uri": "/api/customer/12345/messages"
      },
      {
        "id": "014",
        "method": "DELETE",
        "pattern": "/api/customer/*/messages/*",
        "uri": "/api/customer/12345/messages/12345"
      },
      {
        "id": "015",
        "method": "GET",
        "pattern": "/api/customer/*/messages/*",
        "uri": "/api/customer/12345/messages/12345"
      },
      {
        "id": "016",
        "method": "POST",
        "pattern": "/api/customer/*/messages/*",
        "uri": "/api/customer/12345/messages/12345"
      },
      {
        "id": "017",
        "method": "PUT",
        "pattern": "/api/customer/*/messages/*",
        "uri": "/api/customer/12345/messages/12345"
      },
      {
        "id": "018",
        "method": "GET",
        "pattern": "/api/customer/*/order",
        "uri": "/api/customer/12345/order"
      },
      {
        "id": "019",
        "method": "POST",
        "pattern": "/api/customer/*/order",
        "uri": "/api/customer/12345/order"
      },
      {
        "id": "020",
        "method": "DELETE",
        "pattern": "/api/customer/*/order/*",
        "uri": "/api/customer/12345/order/12345"
      },
      {
        "id": "021",
        "method": "GET",
        "pattern": "/api/customer/*/order/*",
        "uri": "/api/customer/12345/order/12345"
      },
      {
        "id": "022",
        "method": "POST",
        "pattern": "/api/customer/*/order/*",
        "uri": "/api/customer/12345/order/12345"
      },
      {
        "id": "023",
        "method": "PUT",
        "pattern": "/api/customer/*/order/*",
        "uri": "/api/customer/12345/order/12345"
      },
      {
        "id": "024",
        "method": "GET",
        "pattern": "/api/customer/*/paymentcard",
        "uri": "/api/customer/12345/paymentcard"
      },
      {
        "id": "025",
        "method": "POST",
        "pattern": "/api/customer/*/paymentcard",
        "uri": "/api/customer/12345/paymentcard"
      },
      {
        "id": "026",
        "method": "DELETE",
        "pattern": "/api/customer/*/paymentcard/*",
        "uri": "/api/customer/12345/paymentcard/12345"
      },
      {
        "id": "027",
        "method": "GET",
        "pattern": "/api/customer/*/paymentcard/*",
        "uri": "/api/customer/12345/paymentcard/12345"
      },
      {
        "id": "028",
        "method": "POST",
        "pattern": "/api/customer/*/paymentcard/*",
        "uri": "/api/customer/12345/paymentcard/12345"
      },
      {
        "id": "029",
        "method": "PUT",
        "pattern": "/api/customer/*/paymentcard/*",
        "uri": "/api/customer/12345/paymentcard/12345"
      },
      {
        "id": "030",
        "method": "DELETE",
        "pattern": "/api/featureFlags",
        "uri": "/api/featureFlags"
      },
      {
        "id": "031",
        "method": "GET",
        "pattern": "/api/featureFlags",
        "uri": "/api/featureFlags"
      },
      {
        "id": "032",
        "method": "POST",
        "pattern": "/api/featureFlags",
        "uri": "/api/featureFlags"
      },
      {
        "id": "033",
        "method": "PUT",
        "pattern": "/api/featureFlags",
        "uri": "/api/featureFlags"
      },
      {
        "id": "034",
        "method": "GET",
        "pattern": "/api/order",
        "uri": "/api/order"
      },
      {
        "id": "035",
        "method": "POST",
        "pattern": "/api/order",
        "uri": "/api/order"
      },
      {
        "id": "036",
        "method": "DELETE",
        "pattern": "/api/order/*",
        "uri": "/api/order/12345"
      },
      {
        "id": "037",
        "method": "GET",
        "pattern": "/api/order/*",
        "uri": "/api/order/12345"
      },
      {
        "id": "038",
        "method": "POST",
        "pattern": "/api/order/*",
        "uri": "/api/order/12345"
      },
      {
        "id": "039",
        "method": "PUT",
        "pattern": "/api/order/*",
        "uri": "/api/order/12345"
      },
      {
        "id": "040",
        "method": "GET",
        "pattern": "/api/order/*/payment",
        "uri": "/api/order/12345/payment"
      },
      {
        "id": "041",
        "method": "POST",
        "pattern": "/api/order/*/payment",
        "uri": "/api/order/12345/payment"
      },
      {
        "id": "042",
        "method": "DELETE",
        "pattern": "/api/order/*/payment/*",
        "uri": "/api/order/12345/payment/12345"
      },
      {
        "id": "043",
        "method": "GET",
        "pattern": "/api/order/*/payment/*",
        "uri": "/api/order/12345/payment/12345"
      },
      {
        "id": "044",
        "method": "POST",
        "pattern": "/api/order/*/payment/*",
        "uri": "/api/order/12345/payment/12345"
      },
      {
        "id": "045",
        "method": "PUT",
        "pattern": "/api/order/*/payment/*",
        "uri": "/api/order/12345/payment/12345"
      },
      {
        "id": "046",
        "method": "GET",
        "pattern": "/api/product",
        "uri": "/api/product"
      },
      {
        "id": "047",
        "method": "POST",
        "pattern": "/api/product",
        "uri": "/api/product"
      },
      {
        "id": "048",
        "method": "DELETE",
        "pattern": "/api/product/*",
        "uri": "/api/product/12345"
      },
      {
        "id": "049",
        "method": "GET",
        "pattern": "/api/product/*",
        "uri": "/api/product/12345"
      },
      {
        "id": "050",
        "method": "POST",
        "pattern": "/api/product/*",
        "uri": "/api/product/12345"
      },
      {
        "id": "051",
        "method": "PUT",
        "pattern": "/api/product/*",
        "uri": "/api/product/12345"
      },
      {
        "id": "052",
        "method": "GET",
        "pattern": "/api/shipment",
        "uri": "/api/shipment"
      },
      {
        "id": "053",
        "method": "POST",
        "pattern": "/api/shipment",
        "uri": "/api/shipment"
      },
      {
        "id": "054",
        "method": "DELETE",
        "pattern": "/api/shipment/*",
        "uri": "/api/shipment/12345"
      },
      {
        "id": "055",
        "method": "GET",
        "pattern": "/api/shipment/*",
        "uri": "/api/shipment/12345"
      },
      {
        "id": "056",
        "method": "POST",
        "pattern": "/api/shipment/*",
        "uri": "/api/shipment/12345"
      },
      {
        "id": "057",
        "method": "PUT",
        "pattern": "/api/shipment/*",
        "uri": "/api/shipment/12345"
      }
    ],
    "expect": {
      //              1   2   3   4   5   6   7   8   9  10
      "app_000123":[200,200,200,200,200,200,200,200,200,200, // 00's
                    200,200,200,200,200,200,200,200,200,200, // 10's
                    200,200,200,200,200,200,200,200,200,200, // 20's
                    200,200,200,200,200,200,200,200,200,200, // 30's
                    200,200,200,200,200,200,200,200,200,200, // 40's
                    200,200,200,200,200,200,200],            // 50's

      "app_123456":[200,403,403,200,403,403,200,403,403,200, // 00's -- "001"   "004"   "007"   "010"
                    403,200,403,403,200,403,403,200,403,403, // 10's -- "012"   "015"   "018"
                    200,403,403,200,403,403,200,403,403,403, // 20's -- "021"   "024"   "027"
                    200,403,403,200,403,403,200,403,403,200, // 30's -- "031"   "034"   "037"   "040"
                    403,403,200,403,403,200,403,403,200,403, // 40's -- "043"   "046"   "049"
                    403,200,403,403,200,403,403]             // 50's -- "052"   "055"
    }
  }

let totalTests = rawTestData.givenRequest.length

console.log('[');

let spacer = ""
for (const appIndex in rawTestData.givenApp ) {
    console.log( spacer );
    spacer=','
    let app = rawTestData.givenApp[ appIndex ]
    let separator=""
    for (const index in rawTestData.givenRequest) {
        let testCase = {
            "App": app.id,
            "id" : rawTestData.givenRequest[index].id,
            "host": rawTestData.givenService.host,
            "port": rawTestData.givenService.port,
            "method": rawTestData.givenRequest[index].method,
            "uri": rawTestData.givenRequest[index].uri,
            "expect" : rawTestData.expect[app.id][index],
            "pattern": rawTestData.givenRequest[index].pattern,
            "ActorToken": app.ActorToken,
            "AppToken": app.AppToken,
            "nextRequest": null
        }
        let nextTestIndex = Number( index ) + 1
        if ( nextTestIndex < totalTests) {
            testCase.nextRequest =  rawTestData.givenRequest[ nextTestIndex ].method + '_Tests'
        } else if ( Number( appIndex) + 1 < rawTestData.givenApp.length){
            testCase.nextRequest =  rawTestData.givenRequest[ 0 ].method + '_Tests'
        }
        let line = separator + JSON.stringify( testCase )
        separator = ","
        console.log( line )
    }
}
console.log(`]\n`);
