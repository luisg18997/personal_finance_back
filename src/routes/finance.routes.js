const express = require('express');
const { registerFinance, updateFinance, deleteFinance, getFinanceList, getFinance, BalanceFinance, expenseMonthByYear, expenseDayByMonth, expenseCategoryByMonth, monthOfExpense, yearOfExpense, expenseProgression } = require('../services/finance.services');
const router = express.Router();

router.post('/register', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance success'
    }
    let data = null
    try {
        if(req.body.title === undefined || req.body.title === null)
            throw "required title item";
        if(req.body.description === undefined || req.body.description === null)
            throw "required description item";
        if(req.body.mount === undefined || req.body.mount === null)
            throw "required mount item";
        if(req.body.financeDate === undefined || req.body.financeDate === null)
            throw "required financeDate item";
        if(req.body.financeHour === undefined || req.body.financeHour === null)
            throw "required financeHour item";
        if(req.body.categoryId === undefined || req.body.categoryId === null)
            throw "required categoryId item";
        if(req.body.currencyId === undefined || req.body.currencyId === null)
            throw "required currencyId item";
        if(req.body.isIncome === undefined || req.body.isIncome === null)
            throw "required isIncome item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {title, description, mount, financeDate, financeHour,categoryId, currencyId, isIncome, userId} = req.body
        data = await registerFinance(title, description, mount, financeDate, financeHour,categoryId, currencyId, isIncome, userId)
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
      message: 'Finance found'
    }
    let data = null
    try {
        const {id} = req.params
        data = await getFinance(id)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.get('/list/:userId', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance list found'
    }
    let data = null
    try {
        const {userId} = req.params
        console.log(userId)
        data = await getFinanceList(userId)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.get('/balance/:userId', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance balance found'
    }
    let data = null
    try {
        const {userId} = req.params
        data = await BalanceFinance(userId)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.get('/expenseProgression/:userId', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance expense progression found'
    }
    let data = null
    try {
        const {userId} = req.params
        data = await expenseProgression(userId)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.get('/monthOfExpense/:userId', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance month of expense found'
    }
    let data = null
    try {
        const {userId} = req.params
        data = await monthOfExpense(userId)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.get('/yearOfExpense/:userId', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance year of expende found'
    }
    let data = null
    try {
        const {userId} = req.params
        data = await yearOfExpense(userId)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.post('/expenseCategoryByMonth', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance expense category by month found'
    }
    let data = null
    try {
        if(req.body.month === undefined || req.body.month === null)
            throw "required month item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {userId, month} = req.body
        data = await expenseCategoryByMonth(userId, month)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.post('/expenseMonthByYear', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance expense month by year found'
    }
    let data = null
    try {
        if(req.body.year === undefined || req.body.year === null)
            throw "required year item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {userId, year} = req.body
        data = await expenseMonthByYear(userId, year)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.post('/expenseDayByMonth', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance expense day by month found'
    }
    let data = null
    try {
        if(req.body.month === undefined || req.body.month === null)
            throw "required month item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {userId, month} = req.body
        data = await expenseDayByMonth(userId, month)
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
      message: 'Finance updated success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.title === undefined || req.body.title === null)
            throw "required title item";
        if(req.body.description === undefined || req.body.description === null)
            throw "required description item";
        if(req.body.mount === undefined || req.body.mount === null)
            throw "required mount item";
        if(req.body.financeDate === undefined || req.body.financeDate === null)
            throw "required financeDate item";
        if(req.body.financeHour === undefined || req.body.financeHour === null)
            throw "required financeHour item";
        if(req.body.categoryId === undefined || req.body.categoryId === null)
            throw "required categoryId item";
        if(req.body.currencyId === undefined || req.body.currencyId === null)
            throw "required currencyId item";
        if(req.body.isIncome === undefined || req.body.isIncome === null)
            throw "required isIncome item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {id,title, description, mount, financeDate, financeHour,categoryId, currencyId, isIncome, userId} = req.body
        data = await updateFinance(id,title, description, mount, financeDate, financeHour,categoryId, currencyId, isIncome, userId)
    } catch (error) {
        status= 400
        result = {
          success: false,
          message: error
        }
    }

    res.status(status).send({...result, data})
})

router.post('/delete', async(req, res) => {
    let status = 200
    let result = {
      success: true,
      message: 'Finance deleted success'
    }
    let data = null
    try {
        if(req.body.id === undefined || req.body.id === null)
            throw "required id item";
        if(req.body.userId === undefined || req.body.userId === null)
            throw "required userId item";
        const {id, userId} = req.body
        data = await deleteFinance(id, userId)
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