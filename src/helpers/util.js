const bcrypt = require('bcryptjs');
const saltRounds = 10;

const bCryptPass = (password) => bcrypt.hashSync(password, saltRounds);

const passCompare = async(password, passHash) => await bcrypt.compareSync(password, passHash);

module.exports = {
    bCryptPass,
    passCompare
}