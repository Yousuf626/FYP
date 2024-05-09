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
        required: false,
      },
      rsa_prikey:{
        type: String,
        required: false,
      },
      rsa_pubkey:{
        type: String,
        required: false,
      },
      AESkey:{
        type: String,
        required: false,
      },
      iv:{
        type: String,
        required: false,
      },

});

const Patient = mongoose.model('Patient', patientSchema);

module.exports = Patient;