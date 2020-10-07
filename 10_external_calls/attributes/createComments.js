const faker = require('faker');

const count = 20;
let records = [ ]

let i;
for (i = 0; i < count; i++) {
  let record =  {
        "id": i + 1,  
        "message_id": i + 1,
        "user_id": count - i,
        "updated": faker.date.recent(),
        "text":  faker.lorem.text()
    }
    records.push( record )
}

console.log( JSON.stringify( records ) );
