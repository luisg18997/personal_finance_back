const express = require('express');
const { getClients, getClient, isActiveClient, isDeletedClient, updateClient } = require('../services/client.services');

const router = express.Router();

router.get('/:id', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'client found success'
    }
    let data = null
    try {
        const {id} = req.params
        data = await getClient(id);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.get('/', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'clients found success'
    }
    let data = null
    try {
        data = await getClients();
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
      message: 'clients updated success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.name === undefined || req.body.name === null)
            throw "required name item";
        if(req.body.last_name === undefined || req.body.last_name === null)
            throw "required last_name item";
        if(req.body.birth_date === undefined || req.body.birth_date === null)
            throw "required birth_date item";
        if(req.body.email === undefined || req.body.email === null)
            throw "required email item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        let client = {...req.body};
        if(req.files !== null){
            client.avatar = req.files.avatar;
           } else {
            client.avatar = null
           }
      
        data = await updateClient(client);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/isActive', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'clients isActive success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        if(req.body.isActive === undefined || req.body.isActive === null)
            throw "required isActive item";
        const {id, userId, isActive} = req.body
        data = await isActiveClient(id, userId, isActive);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

router.post('/isDeleted', async(req,res) => {
    let status = 200
    let result = {
      success: true,
      message: 'clients found success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        if(req.body.isDeleted === undefined || req.body.isDeleted === null)
            throw "required isDeleted item";
        const {id,userId, isDeleted} = req.body
        data = await isDeletedClient(id, userId, isDeleted);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }
    res.status(status).send({...result, data})
})

module.exports = router;