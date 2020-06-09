const Query = require("./pg.services");
const util = require('util');

const registerCurrency = async(name, description, symbol) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.currency_add('%s','%s', '%s') as result",name, description, symbol));
        if(data[0].result === '0')
            throw 'currency exists';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const getCurrencyList = async() => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_currencies() as result"));
        if(!data[0].result)
            throw 'currency not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const getCurrency = async(id) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_currency(%d) as result",id));
        if(!data[0].result)
            throw 'currency not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const updateCurrency = async(id, name, description, symbol) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.update_currency(%d,'%s','%s', '%s') as result",id,name, description, symbol));
        if(data[0].result === '0')
            throw 'currency not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const isActiveCurrency = async(id, isACtive) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.is_active_currency(%d, '%d') as result",id,isACtive));
        if(data[0].result === '0')
            throw 'currency not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const isDeletedCurrency = async(id, isDeleted) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.is_deleted_currency(%d, '%d') as result",id,isDeleted));
        if(data[0].result === '0')
            throw 'currency not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}


module.exports = {registerCurrency, getCurrency, getCurrencyList, updateCurrency, isActiveCurrency, isDeletedCurrency}