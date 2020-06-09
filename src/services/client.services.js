const Query = require("./pg.services");
const util = require('util');
const upload = require("../config/cloudinary");

const getClients = async() => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_clients() as result"));
        if(!data[0].result)
            throw 'client not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const getClient = async(id) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.get_client(%d) as result",id));
        if(!data[0].result)
            throw 'client not found';
        return data[0].result; 
    } catch (error) {
        throw error;
    }
}

const updateClient = async(client) => {
    try {
        const {id, name, last_name, email, userId, avatarPreview} = client
        let avatar
        let birth_date = client.birth_date? client.birth_date:null
        if(client.avatar) {
            avatar = await upload(client.avatar,'client');
        } else {
            avatar=  avatarPreview
        }let data
        if(birth_date){
            data = await Query(util.format("SELECT per_finance_data.update_client(%d,'%s','%s', '%s', '%s', %d, '%s') as result",id,name, last_name, avatar, birth_date, userId, email));
        } else {
            data = await Query(util.format("SELECT per_finance_data.update_client(%d,'%s','%s', '%s', null, %d, '%s') as result",id,name, last_name, avatar, userId, email));
        }
        
        if(data[0].result === '0')
            throw 'client not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const isActiveClient = async(id,userId, isACtive) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.is_active_client(%d,%d,'%d') as result",id,userId, isACtive));
        if(data[0].result === '0')
            throw 'client not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}

const isDeletedClient = async(id,userId, isDeleted) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.is_deleted_client(%d,%d, '%d') as result",id,userId,isDeleted));
        if(data[0].result === '0')
            throw 'client not found';
        return data[0]; 
    } catch (error) {
        throw error;
    }
}


module.exports = { getClients, getClient, isActiveClient, isDeletedClient, updateClient }