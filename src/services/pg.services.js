const pool = require("../config/pg_connect");

const Query = async(querytext) => {
    try {
        const {rows} = await pool.query(querytext);
        return rows;
    } catch (error) {
        throw error;
    }
};

module.exports = Query