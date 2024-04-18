const express = require('express');
const router = express.Router();
const medicalRecordController = require('../controllers/medicalRecordController');

// Create a new medical record
router.post('/create', medicalRecordController.createMedicalRecord);

// Retrieve all medical records associated with a specific user
router.get('/:userId', medicalRecordController.getMedicalRecordsByUser);

// Retrieve a single medical record by its unique identifier
router.get('/:recordId', medicalRecordController.getMedicalRecordById);

// Update an existing medical record
router.put('/:recordId', medicalRecordController.updateMedicalRecord);

// Delete a medical record by its unique identifier
router.delete('/:recordId', medicalRecordController.deleteMedicalRecord);

module.exports = router;
