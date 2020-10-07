const faker = require('faker');

const count = 20;
let records = [ ]

let i;
for (i = 0; i < count; i++) {
  let record =  {
       "ts_1" : faker.date.past(),
       "ts_2" : faker.date.recent(),
       "ts_3" : faker.date.soon(),
       "ts_4" : faker.date.future()
    }
    records.push( record )
}

console.log( JSON.stringify( records ) );



