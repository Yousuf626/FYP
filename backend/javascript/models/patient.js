const mongoose = require('mongoose');

const patientSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    mobile: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    age: {
        type: Number,
      },
    adress: {
        type: String
      },
    cnic: {
        type: String
      },
    resetPasswordOTP: {
        type: String
    },
    resetPasswordExpires: {
        type: Date
    },
    wallet_address: {
        type: String,
        required: true,
        unique: true, // Ensure each address is unique
      },
    wallet_privateKey: {
        type: String,
        required: true,
      },
    // credentials: {
    //     certificate: { type: String },
    //     privateKey: { type: String }
    //   },
    //   mspId: { type: String },
    //   type: { type: String },
    //   version: { type: Number },
});

const Patient = mongoose.model('Patient', patientSchema);

module.exports = Patient;