const Datauri = require('datauri/parser')

const dUri = new Datauri();


const dataUri =async (file) => {
    const ext = file.name.split('.')
    console.log(ext)
    return await dUri.format(ext[1], file.data);
}

module.exports =  dataUri
