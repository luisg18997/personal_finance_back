const express = require('express');
const { RegisterUser, forgotPassword, ChangePassword, UpdateUser, LogIn } = require('../services/user.services');
const router = express.Router();

router.post('/register', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'user add success'
    }
    let data = null
    try {
        if(req.body.email === undefined || req.body.email === null)
            throw "required email item";
        if(req.body.password === undefined || req.body.password === null)
            throw "required password item";
        if(req.body.roleId === undefined || req.body.roleId === null)
            throw "required roleId item";
        const {email, password, roleId} = req.body
        data = await RegisterUser(email, password, roleId);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/forgotPassword', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'forgot password success'
    }
    let data = null
    try {
        if(req.body.email === undefined || req.body.email === null)
            throw "required email item";
        const {email} = req.body
        data = await forgotPassword(email);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/update', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'update user success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.email === undefined || req.body.email === null)
            throw "required email item";
        const {id, email} = req.body
        data = await UpdateUser(id, email);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/changePassword', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'change password success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.password === undefined || req.body.password === null)
            throw "required password item";
        const {id, password} = req.body
        data = await ChangePassword(id, password);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/login', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'login success'
    }
    let data = null
    try {
        if(req.body.email === undefined || req.body.email === null)
            throw "required email item";
        if(req.body.password === undefined || req.body.password === null)
            throw "required password item";
        const {email, password} = req.body
        data = await LogIn(email, password);
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