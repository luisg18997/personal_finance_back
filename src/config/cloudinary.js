const cloudinary = require('cloudinary').v2;
const dataUri = require('./dataUri')
const moment = require('moment');

cloudinary.config({
	cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
	api_key: process.env.CLOUDINARY_API_KEY,
	api_secret: process.env.CLOUDINARY_API_SECRET
})

const upload = async(file, folder) => {
    try {
        // const Url = await dataUri(file)
        const result = await cloudinary.uploader.upload(file.tempFilePath, {
            folder: folder,
            resource_type: 'auto',
            public_id: moment().format('YYMMDDHHmmss')
          }, (error, result) => {
              console.log(result, error)
                if(!error)
                    console.log(error)
                
                return result
          }).catch(e => {throw e;})
        console.log(result)
        return result.secure_url
    }
    catch(e) {
        throw e
    }
}

module.exports =  upload
