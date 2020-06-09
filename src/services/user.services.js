const Query = require("./pg.services");
const util = require('util');
const { bCryptPass, passCompare } = require("../helpers/util");
const { generateToken } = require("../config/auth");

const RegisterUser = async(email, password, roleId) => {
    try {
        const pass = await bCryptPass(password);
        console.log(util.format("SELECT per_finance_data.user_add('%s','%s', %d) as result",email,pass, roleId))
        const data = await Query(util.format("SELECT per_finance_data.user_add('%s','%s', %d) as result",email,pass, roleId));
        if(data[0].result === '0')
            throw 'users exists';
        return data[0];   
    } catch (error) {
        throw error;
    }
}

const forgotPassword = async(email) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.forgot_password('%s') as result",email));
        if(!data[0].result)
            throw 'users not found';
        return data[0].result;   
    } catch (error) {
        throw error;
    }
}

const ChangePassword = async(id, password) => {
    try {
        const pass = await bCryptPass(password);
        const data = await Query(util.format("SELECT per_finance_data.change_password(%d,'%s') as result",id, pass));
        if(data[0].result === '0')
            throw 'user not found';
        return data[0];   
    } catch (error) {
        throw error;
    }
}

const UpdateUser = async(id, email) => {
    try {
        const data = await Query(util.format("SELECT per_finance_data.update_user(%d,'%s') as result",id,email));
        if(data[0].result === '0')
            throw 'users not found';
        return data[0];   
    } catch (error) {
        throw error;
    }
}

const LogIn = async(email, password) => {
    try {

        const data = await Query(util.format("SELECT per_finance_data.login('%s') as result",email));
        if(!data[0].result)
            throw 'users not found';
        const passVerify = await passCompare(password, data[0].result.password);
        if(!passVerify)
            throw 'user and password incorrect';
        if(!data[0].result.isactive)
            throw 'user block please contact with admin';
        const result =  {
            id : data[0].result.id,
            email : data[0].result.email,
            client_id : data[0].result.client_id,
            is_new : data[0].result.is_new,
            role : data[0].result.role,
        }
        const token = await generateToken(result);
        return {
            ...result,
            token
        };   
    } catch (error) {
        throw error;
    }
}



module.exports = {
    RegisterUser, forgotPassword, ChangePassword, UpdateUser, LogIn
}