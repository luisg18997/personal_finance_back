const Query = require("./pg.services");
const util = require('util');
const moment = require("moment");

const registerFinance = async(title, description, mount, financeDate, financeHour,categoryId, currencyId, isIncome, userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.finance_add('%s','%s', %f, '%s', '%s', %d, %d, '%d', %d) as result",title, description, mount, financeDate, financeHour, categoryId, currencyId, isIncome, userId));
        if(data[0].result === '0')
            throw 'finance exists';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const BalanceFinance = async(userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_finance_balance(%d) as result", userId));
        if(!data[0].result)
            throw 'finance not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const getFinance = async(id) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_finance(%d) as result",id));
        if(!data[0].result)
            throw 'finance not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const getFinanceList = async(userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_finance_list(%d) as result", userId));
        if(!data[0].result)
            throw 'finance not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const updateFinance = async(id, title, description, mount, financeDate, financeHour,categoryId, currencyId, isIncome, userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.update_finance(%d,'%s','%s', %f, '%s', '%s', %d, %d, '%d', %d) as result",id,title, description, mount, financeDate, financeHour,categoryId, currencyId, isIncome, userId));
        if(data[0].result === '0')
            throw 'finance not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const expenseProgression = async(userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_expense_progression(%d) as result", userId));
        if(!data[0].result)
            throw 'finance not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const yearOfExpense = async(userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_year_expense(%d) as result", userId));
        if(!data[0].result)
            throw 'finance not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const monthOfExpense = async(userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_month_expense(%d) as result", userId));
        if(!data[0].result)
            throw 'finance not found';
        const result = data[0].result.map((item) => ({
            ...item,
            month_name: moment(item.month_finance, 'MM').format('MMMM')
        }))
        return result; 
    } catch (error) {
        throw error;
    }
}

const expenseCategoryByMonth = async(id, month) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_expense_category_month(%d, %d) as result",id,month));
        if(data[0].result === '0')
            throw 'finance not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const expenseMonthByYear = async(id, year) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_expense_month_year(%d, %d) as result",id,year));
        if(data[0].result === '0')
            throw 'finance not found';
        const result = data[0].result.map((item) => ({
            ...item,
            month_name: moment(item.month_finance, 'MM').format('MMMM')
        }))
        return result; 
    } catch (error) {
        throw error;
    }
}

const expenseDayByMonth = async(id, month) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_expense_day_month(%d, %d) as result",id,month));
        if(data[0].result === '0')
            throw 'finance not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const deleteFinance = async(id, userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.delete_finance(%d, %d) as result",id,userId));
        if(data[0].result === '0')
            throw 'finance not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

module.exports= { 
    registerFinance,
    updateFinance,
    deleteFinance,
    getFinanceList,
    getFinance,
    BalanceFinance,
    expenseMonthByYear,
    expenseDayByMonth,
    expenseCategoryByMonth,
    monthOfExpense,
    yearOfExpense,
    expenseProgression }