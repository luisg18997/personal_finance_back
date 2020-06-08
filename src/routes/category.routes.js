const express = require('express');
const { registerCategoryGlobal, registerCategoryPersonal, getCategoriesGlobal, getCategory, getCategoryIncludePersonal, updateCategory, isActiveCategory, isDeletedCategory, deletedCategoryPersonal } = require('../services/category.services');
const router = express.Router();

router.post('/register', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'category global success'
    }
    let data = null
    try {
        if(req.body.name === undefined || req.body.name === null)
            throw "required name item";
        if(req.body.description === undefined || req.body.description === null)
            throw "required description item";
        const {name, description} = req.body
        data = await registerCategoryGlobal(name, description)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.post('/registerPersonal', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'category personal success'
    }
    let data = null
    try {
        if(req.body.name === undefined || req.body.name === null)
            throw "required name item";
        if(req.body.description === undefined || req.body.description === null)
            throw "required description item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {name, description, userId} = req.body
        data = await registerCategoryPersonal(name, description,userId);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.get('/', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'categories global found'
    }
    let data = null
    try {
        data = await getCategoriesGlobal();
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
      message: 'category found success'
    }
    let data = null
    try {
        const {id} = req.params
        data = await getCategory(id);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.get('/personal/:id', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'categories gobal and personal found'
    }
    let data = null
    try {
        const {id} = req.params
        data = await getCategoryIncludePersonal(id);
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
      message: 'category updated success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.name === undefined || req.body.name === null)
        throw "required name item";
        if(req.body.description === undefined || req.body.description === null)
            throw "required description item";
        const {id, name, description} = req.body
        data = await updateCategory(id, name, description);
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
      message: 'category is active success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.isActive === undefined || req.body.isActive === null)
            throw "required isActive item";
        const {isActive, id} = req.body
        data = await isActiveCategory(id, isActive);
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
      message: 'category is deleted success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.isDeleted === undefined || req.body.isDeleted === null)
            throw "required isDeleted item";
        const {isDeleted, id} = req.body
        data = await isDeletedCategory(id, isDeleted);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.post('/deletePersonal', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'category personal deleted success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {userId, id} = req.body
        data = await deletedCategoryPersonal(id, userId);
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
});

module.exports = router;