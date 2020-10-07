const faker = require('faker');

const employees = [ "1-1,000", "1,000-10,000", "10,000-25,000", "25,000-50,000", ">50,000" ]
const revenue = [ "$0-10 Million", "$10-100 Million", "$100-500 Million", "$0.5 - 1 Billion", ">$1 Billion" ]
const sectors = ["communications", "Consumer Discretionary", "Consumer Staples", "Energy", "Financial", "Healthcare", "Industrial", "Materials", "Real Estate", "Technology", "Utilities"]

let customers = [ ]

let i;
for (i = 0; i < 25; i++) {
    let customer = { 
        "id": i + 1,  
        "companyName": faker.company.companyName(), 
        "street": faker.address.streetAddress(), 
        "city": faker.address.city(), 
        "state": faker.address.state(),    
    }
    customer.zipcode = faker.address.zipCodeByState( customer.state )
    
    let e = Math.floor(Math.random() * 5)
    customer.employees = employees[ e ]

    let r = Math.floor(Math.random() * 5)
    customer.revenue = revenue[ r ]

    let s = Math.floor(Math.random() * 11)
    customer.sector = sectors[ s ]

    customers.push( customer )
}

console.log( JSON.stringify( customers ) );


// a customer has an account, messages, orders, payment-type and users, has a sector, employee count, revenue
