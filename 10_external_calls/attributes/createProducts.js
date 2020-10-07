const faker = require('faker');

const condition = [ "new", "excellent", "good", "fair" ]
const availability = [ "lease", "sale" ]
const milage = [ "10-1,000", "1,000-10,000", "10,000-25,000", "25,000-50,000" ]
let cars = [ ]

let i;
for (i = 0; i < 25; i++) {
  let car =  {
       "id": i + 1,  
       "vehicle":faker.vehicle.vehicle(), 
       "fuel":faker.vehicle.fuel(),
       "color":faker.vehicle.color() 
    }

    let c = Math.floor(Math.random() * 4)
    car.condition = condition[ c ]

    let a = Math.floor(Math.random() * 2)
    car.availability = availability[a]

    if ( car.condition == "new" ) {
        car.milage = "<10"
    } else {
        let m = Math.floor(Math.random() * 4)
        car.milage = milage[ m ]
    }
    cars.push( car )
}

console.log( JSON.stringify( cars ) );
