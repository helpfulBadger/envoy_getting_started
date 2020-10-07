const blowson = require('blowson');
const faker = require('faker');
const data = require('./data.js');

const extendedData = blowson(data);

console.log(
    JSON.stringify( extendedData )
    );

