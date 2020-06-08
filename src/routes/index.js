const currencyRouter = require('./currency.routes');
const userRouter = require('./user.routes')
const categoryRouter = require('./category.routes')
const clientRouter = require('./client.routes')
const financeRouter = require('./finance.routes')

module.exports = (app) => {
    app.use('/currency', currencyRouter);
    app.use('/users', userRouter);
    app.use('/client', clientRouter);
    app.use('/category', categoryRouter);
    app.use('/finance', financeRouter);

    const routeNotFound = {
        success:false,
        message: 'Route not found',
    };
    // route no found show the next message
    app.get('*', (req, res) => {
        res.status(404).send(routeNotFound);
    })

    app.post('*', (req, res) => {
        res.status(404).send(routeNotFound);
    })
}