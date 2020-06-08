const { Pool } = require("pg")


const conectionString = {
    connectionString: process.env.PG_URI
}

const pool = new Pool(conectionString)

module.exports = pool