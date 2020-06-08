const express = require('express')
const cors = require('cors');
const timeout = require('connect-timeout');
const routes = require('../routes');
const morgan = require('morgan');
const fileUpload = require('express-fileupload')
const app = express()

module.exports = () => {
    //midlewares
    app.use(cors());
    app.use(morgan('dev'))
    ;app.use(express.json({limit: '50mb'}));
    app.use(express.urlencoded({limit: '50mb'}));
    app.use(fileUpload({
        useTempFiles : true,
        tempFileDir : '/tmp/'
    }))


    app.use(timeout(50000)); // timeout of response request

    app.use(haltOnTimedout);

    function haltOnTimedout(req, res, next) {
        if (!req.timedout) next();
    }

    //settings
    app.set('port', process.env.SERVER_PORT);

    //routes
    try{
        routes(app)
    }catch(e){

    }

    //start server
    app.listen(app.get('port'), (err) => {
        if(err) {
            console.error(err.name)
            process.exit(1);
        }
        console.info('Server running...');
    });


}