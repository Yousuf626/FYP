
const MedicalRecord = require('../models/medicalRecord');
const Patient = require('../models/patient');
const crypto = require('crypto');
const nodeSchedule = require('node-schedule');
const verifyToken = require('./middleware/tokenauth'); 
const fs = require('fs');
const { uploadRecordToBlockchain, getRecord } =  require('./../blockchain_connection/medical_record');




// Temporary storage for tokens
const tempTokenStore = new Map();

exports. uploadRecord = async (req, res) => {
    try {
        // const { patientId } = req.params;
        await verifyToken(req, res); 
  
        const userId = req.userId; // Access user ID attached by verifyToken
        const { originalname, mimetype, buffer } = req.file;
 // Calculate the hash of the file
const hash = crypto.createHash('sha256');
hash.update(buffer);
const fileHash = hash.digest('hex');



        // Find existing MedicalRecord for the patient
        let medicalRecord = await MedicalRecord.findOne({ patient: userId });
        let PatientEmail = await Patient.findOne({_id: userId});
        // console.log(PatientEmail);
        // If no existing record found, create a new one
        if (!medicalRecord) {
            medicalRecord = new MedicalRecord({
                patient: userId,
                records: [],
                files_hashes: [],
            });
        }

        // Push the new record details into the records array
        medicalRecord.records.push({
            filename: originalname,
            contentType: mimetype,
            length: buffer.length,
            data: buffer,
        });
        medicalRecord.files_hashes.push({
            hash: fileHash,
        });

        // Save the updated medical record to the database
        const savedRecord = await medicalRecord.save();

 // Upload the record to the blockchain
 const tx = await uploadRecordToBlockchain(fileHash, buffer);


        res.status(201).json({ message: 'Medical record uploaded successfully', record: savedRecord, tx });
    } catch (error) {
        console.error('Error in uploadRecord:', error);
        res.status(500).json({ error: error.message });
    }
};

// Modified getAllRecordsByPatient to be reusable
exports.getAllRecordsByPatient = async (req, res) => {
    try {
        await verifyToken(req, res); 
  
        const userId = req.userId; // Access user ID attached by verifyToken

        // Find existing MedicalRecord for the patient
        let medicalRecord = await MedicalRecord.findOne({ patient: userId });
    
        // If no existing record found, return an error
        if (!medicalRecord) {
            return res.status(404).json({ message: 'Medical records not found for this patient' });
        }

        // Convert the records map to an array of objects for the response
        let recordsArray = Array.from(medicalRecord.records, ([hash, record]) => ({ hash, ...record }));
        res.status(200).json(recordsArray);
    } catch (error) {
        console.error('Error in getAllRecordsByPatient:', error);
        throw new Error(error.message);
    }
    
exports.generateTemporaryLink = async (req, res) => {
    try {
        
        // const { patientId } = req.params;
        await verifyToken(req, res); 
  
        const patientId = req.userId; // Access user ID attached by verifyToken



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

        const medicalRecords = await getAllRecordsByPatient_noToken(tokenData.patientId,email);
        // console.log(medicalRecords[0].data);

        let imagesHtml = '';
        medicalRecords.forEach(record => {

            let base64Image = Buffer.from(record.data, 'binary').toString('base64');
            //  console.log(record.data);
            imagesHtml += `
                <div>
                    <h2>${record.filename}</h2>
                     <img src="data:${record.contentType};base64,${base64Image}"alt="${record.filename}" style="width:100%;" />
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



async function getAllRecordsByPatient_noToken(patientId, email) {
    try {
  
  
      // Find the medical records for the given patient
      const medicalRecord = await MedicalRecord.findOne({ patient: patientId });
  
      if (!medicalRecord) {
        return [];
      }
  
      return medicalRecord.records;
    } catch (error) {
      console.error('Error in getAllRecordsByPatient:', error);
      throw error;
    }
  }
}
  