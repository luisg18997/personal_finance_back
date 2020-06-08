const express = require('express');
const router = express.Router();

const {registerCurrency, getCurrency, getCurrencyList, updateCurrency, isActiveCurrency, isDeletedCurrency} = require('../services/currency.services');


router.post('/register', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'currency success'
    }
    let data = null
    try {
        if(req.body.name === undefined || req.body.name === null)
            throw "required name item";
        if(req.body.code === undefined || req.body.code === null)
            throw "required name item";
        if(req.body.symbol === undefined || req.body.symbol === null)
            throw "required name item";
        const {name, code, symbol} = req.body
        data = await registerCurrency(name, code, symbol);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})


router.get('/:id', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'currency get found'
    }
    let data = null
    try {
        const {id} = req.params
        data = await getCurrency(id);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
});

router.get('/', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'currencies get found'
    }
    let data = null
    try {
        data = await getCurrencyList();
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.post('/update', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'currency updated success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.name === undefined || req.body.name === null)
            throw "required name item";
        if(req.body.code === undefined || req.body.code === null)
            throw "required name item";
        if(req.body.symbol === undefined || req.body.symbol === null)
            throw "required name item";
        const {id, name, code, symbol} = req.body
        data = await updateCurrency(id, name, code, symbol);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/isActive', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'currency updated success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.isActive === undefined || req.body.isActive === null)
            throw "required isActive item";
        const {id, isActive} = req.body;
        data = await isActiveCurrency(id, isActive);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/isDeleted', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'currency updated success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.isDeleted === undefined || req.body.isDeleted === null)
            throw "required isDeleted item";
        const {id, isDeleted} = req.body;
        data = await isDeletedCurrency(id, isDeleted);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

module.exports = router