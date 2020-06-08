const jwt = require('jsonwebtoken');
const  {JWT_KEY}  = process.env

  const isAuthorised = async(req, res, next) => {
    try{
      if(!req.headers.authorization)
        throw 'token no recbidio';
      const token = req.headers.authorization.split(' ')[1];
      await  jwt.verify(token, JWT_KEY, (err, decoded) => {
        if (err) {
          res.status(401).send({success: false, data: null,message:'Usuario no auntenticado'});
        } else {
          req.userData = decoded;
        }
      });
      next();
    } catch (err) {
      throw err;
    }
  }

  const generateToken = async(payload) => {
      try {
        const token =  await jwt.sign(
          { ...payload },
          JWT_KEY,
          { expiresIn: '24h' },
        );
        return token;
      } catch (e) {
        console.log(e);
        return e.message;
      }
  }

  const decodeToken = async(token) => {
    try {
      const decoded = await  jwt.verify(token, JWT_KEY, (err, decoded) => {
          if (err) {
            return err
          } else {
            return decoded;
          }
        });
      return decoded;
    } catch (e) {
      res.status(500).send(err.message);
    }
  }



module.exports = {
  isAuthorised,
  generateToken,
  decodeToken
}
