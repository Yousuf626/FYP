
const MedicalRecord = require('../models/medicalRecord');
const Patient = require('../models/patient');
const mongoose = require('mongoose');
const Grid = require('gridfs-stream');
const { Readable } = require('stream');
const crypto = require('crypto');
const nodeSchedule = require('node-schedule');
const getPicture = require('../getPic');
const upload = require('../uploadPic');
const verifyToken = require('./middleware/tokenauth'); 


// Create GridFS stream
let gfs;
mongoose.connection.once('open', () => {
    gfs = Grid(mongoose.connection.db, mongoose.mongo);
    gfs.collection('uploads');
});

// Utility function to convert stream to buffer
function streamToBuffer(stream) {
    return new Promise((resolve, reject) => {
        const chunks = [];
        stream.on('data', chunk => chunks.push(chunk));
        stream.on('error', reject);
        stream.on('end', () => resolve(Buffer.concat(chunks)));
    });
}

// Temporary storage for tokens
const tempTokenStore = new Map();

exports.uploadRecord = async (req, res) => {
    try {
        // const { patientId } = req.params;
        await verifyToken(req, res); 
  
        const userId = req.userId; // Access user ID attached by verifyToken
        const { originalname, mimetype, buffer } = req.file;
 
        // Find existing MedicalRecord for the patient
        let medicalRecord = await MedicalRecord.findOne({ patient: userId });
        let PatientEmail = await Patient.findOne({_id: userId});
        // console.log(PatientEmail);
        // If no existing record found, create a new one
        if (!medicalRecord) {
            medicalRecord = new MedicalRecord({
                patient: userId,
                records: []
            });
        }

        // Push the new record details into the records array
        medicalRecord.records.push({
            filename: originalname,
            contentType: mimetype,
            length: buffer.length,
            data: buffer
        });

        // Save the updated medical record to the database
        const savedRecord = await medicalRecord.save();

        // const{email} = req.body;
        // email = 'yousuf@gmail.com'
        // await upload(medicalRecord.patient,email,medicalRecord.filename,medicalRecord.contentType,medicalRecord.length,medicalRecord.data);
        // Return success response
        res.status(201).json({ message: 'Medical record uploaded successfully', record: savedRecord });
    } catch (error) {
        console.error('Error in uploadRecord:', error);
        res.status(500).json({ error: error.message });
    }
};

// Modified getAllRecordsByPatient to be reusable
exports.getAllRecordsByPatient = async (req, res) => {
    try {

        // const { patientId } = req.params;
        await verifyToken(req, res); 
  
        const userId = req.userId; // Access user ID attached by verifyToken

        // Find existing MedicalRecord for the patient
        let medicalRecord = await MedicalRecord.findOne({ patient: userId });
    
      // If no existing record found, create a new one
      if (!medicalRecord) {
        return res.status(404).json({ message: 'Medical records not found for this patient' });
    }
    res.status(200).json(medicalRecord.records);

        
        // const medicalRecords = await MedicalRecord.find({ patient: patientId });
        // if (medicalRecords.length === 0) {
        //     return [];
        // }
        // for (let index = 0; index < medicalRecords.length; index++) {
        //     const element = medicalRecords[index];
        //     const check = await getPicture(patientId, element.filename, element.contentType, element.length, element.data,email);
        //     if(check == false){
        //         console.log('record name '+ element.filename + ' not found in blockchain ledger');
        //     }
        // }


        // return Promise.all(medicalRecords.map(async record => {
        //     const readableStream = new Readable();
        //     readableStream._read = () => {};
        //     readableStream.push(record.data);
        //     readableStream.push(null);

        //     const bufferData = await streamToBuffer(readableStream);
        //     const base64Data = bufferData.toString('base64');

        //     return {
        //         _id: record._id,
        //         filename: record.filename,
        //         contentType: record.contentType,
        //         data: base64Data
        //     };
        // }
    // ));
    } catch (error) {
        console.error('Error in getAllRecordsByPatient:', error);
        throw new Error(error.message);
    }
}

exports.generateTemporaryLink = async (req, res) => {
    try {
        const { patientId } = req.params;
        const token = crypto.randomBytes(20).toString('hex');
        const linkExpirationDate = new Date(Date.now() + 120000); // 2 minutes from now

        tempTokenStore.set(token, { patientId, expires: linkExpirationDate });

        // Schedule token deletion
        nodeSchedule.scheduleJob(linkExpirationDate, () => {
            tempTokenStore.delete(token);
        });

        const link = `${req.protocol}://${req.get('host')}/api/medical-records/temporary/${token}`;
        res.status(200).json({ message: 'Temporary link generated successfully', link });
    } catch (error) {
        console.error('Error in generateTemporaryLink:', error);
        res.status(500).json({ error: error.message });
    }
};


exports.accessTemporaryLink = async (req, res) => {
    try {
        const { token } = req.params;
        const tokenData = tempTokenStore.get(token);

        if (!tokenData || new Date() > tokenData.expires) {
            return res.status(404).json({ message: 'Link is invalid or has expired' });
        }

        tempTokenStore.delete(token); // Invalidate token

        const email = 'yousuf@gmail.com'
        // Fetch the patient's name
        const patient = await Patient.findById(tokenData.patientId);
        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }
        const patientName = patient.name; // Assuming the patient's name field is `name`

        const medicalRecords = await getAllRecordsByPatient(tokenData.patientId,email);


        let imagesHtml = '';
        medicalRecords.forEach(record => {
            imagesHtml += `
                <div>
                    <h2>${record.filename}</h2>
                    <img src="data:${record.contentType};base64,${record.data}" alt="${record.filename}" style="width:100%;">
                </div>
            `;
        });

        const html = `
            <!DOCTYPE html>
            <html>
            <head>
                <title>Medical Records for ${patientName}</title>
            </head>
            <body>
                <h1>${patientName}</h1>
                ${imagesHtml}
            </body>
            </html>
        `;

        res.send(html);
    } catch (error) {
        console.error('Error in accessTemporaryLink:', error);
        res.status(500).json({ error: error.message });
    }
};



