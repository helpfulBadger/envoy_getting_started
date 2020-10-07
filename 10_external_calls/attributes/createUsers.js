const faker = require('faker');
const Chance = require('chance');

// Instantiate Chance 
var chance = new Chance();

const employees = [ "1-1,000", "1,000-10,000", "10,000-25,000", "25,000-50,000", ">50,000" ]
const revenue = [ "$0-10 Million", "$10-100 Million", "$100-500 Million", "$0.5 - 1 Billion", ">$1 Billion" ]
const sectors = ["communications", "Consumer Discretionary", "Consumer Staples", "Energy", "Financial", "Healthcare", "Industrial", "Materials", "Real Estate", "Technology", "Utilities"]
const roles = ["accountTeam", "accountExecutive"]
const titles = ["Customer Success Mgr.", "Sales Support Mgr.", "Operations Mgr."]

const customerCount = 20;
const workforceCount = 10;
let users = [ ]

let i;
for (i = 0; i < customerCount; i++) {
  let user =  {
       "id": i + 1,  
       "firstName": faker.name.firstName(), 
       "lastName": faker.name.lastName(), 
       "customer_id": i + 1,
       "role": "commercialCustomer",
       "identityProvider": "customerIdentity.example.com",
       "title": chance.profession(),
       "updated": faker.date.recent()
    }
    users.push( user )
}


for (i = 0; i < workforceCount; i++) {
  let user =  {
       "id": i + 1 + customerCount,
       "firstName": faker.name.firstName(),
       "lastName": faker.name.lastName(),
       "role": chance.pickone( roles ),
       "identityProvider": "workforceIdentity.example.com",
       "revenueLimit": chance.pickone( revenue ),
       "sizeLimit": chance.pickone( employees ),
       "sectors": chance.pickset( sectors, 3),
       "updated": faker.date.recent()
    }
    if (user.role == "accountExecutive" ) {
      user.title = "Account Executive"
    } else {
      user.title = chance.pickone( titles )
    }

    users.push( user )
}

console.log( JSON.stringify( users ) );
