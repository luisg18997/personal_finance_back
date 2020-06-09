const Query = require("./pg.services");
const util = require('util');

const registerCategoryGlobal = async(name, description) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.category_add('%s','%s') as result",name, description));
        if(data[0].result === '0')
            throw 'category exists';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const registerCategoryPersonal = async(name, description, userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.category_add_personal('%s','%s', %d) as result",name, description, userId));
        if(data[0].result === '0')
            throw 'category exists';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const getCategoriesGlobal = async() => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_Categories_global() as result"));
        if(!data[0].result)
            throw 'category not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const getCategory = async(id) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_category(%d) as result",id));
        if(!data[0].result)
            throw 'category not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const getCategoryIncludePersonal = async(userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_Categories_include_personal(%d) as result", userId));
        if(!data[0].result)
            throw 'category not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const updateCategory = async(id, name, description) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.update_category(%d,'%s','%s') as result",id,name, description));
        if(data[0].result === '0')
            throw 'category not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const isActiveCategory = async(id, isACtive) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.is_active_category(%d, '%d') as result",id,isACtive));
        if(data[0].result === '0')
            throw 'category not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const isDeletedCategory = async(id, isDeleted) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.is_deleted_category(%d, '%d') as result",id,isDeleted));
        if(data[0].result === '0')
            throw 'category not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const deletedCategoryPersonal = async(id, userId) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.delete_category_personal(%d, %d) as result",id,userId));
        if(data[0].result === '0')
            throw 'category not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}


module.exports = {
    registerCategoryGlobal, registerCategoryPersonal, getCategoriesGlobal, getCategory, getCategoryIncludePersonal, updateCategory, isActiveCategory, isDeletedCategory, deletedCategoryPersonal
}