const Pool = require('pg').Pool;

const poll = new Pool({
    user: "postgres",
    host: "localhost",
    database: "sns",
    password: "admin",
    port: 5432,
})

module.exports = poll;