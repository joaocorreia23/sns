const Pool = require('pg').Pool;

const poll = new Pool({
    user: "postgres",
    host: "db.vqoiqiptdusxfowcwpgx.supabase.co",
    database: "postgres",
    password: "!N*AWebLhvm6pwf",
    port: 5432,
})

module.exports = poll;