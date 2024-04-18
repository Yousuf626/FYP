const mongoose = require('mongoose')

const medicalRecordSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  recordType: { type: String, required: true }, // e.g., diagnosis, prescription
  date: { type: Date, default: Date.now },
  uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Store the user who uploaded the record
  fileUrl: { type: String }, // Path or URL of the uploaded file
  // Add other relevant fields for the medical record (e.g., doctor's notes, lab results, etc.)
});

module.exports = mongoose.model('MedicalRecord', medicalRecordSchema);
