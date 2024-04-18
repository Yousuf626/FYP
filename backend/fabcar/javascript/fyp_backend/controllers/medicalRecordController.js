const MedicalRecord = require('../models/medicalRecord');

// Create a new medical record
const createMedicalRecord = async (req, res) => {
  try {
    const { userId, recordType, description, date } = req.body;

    const medicalRecord = new MedicalRecord({
      userId,
      recordType,
      description,
      date,
    });

    await medicalRecord.save();
    res.status(201).json({ message: 'Medical record created successfully' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create medical record' });
  }
};

// Retrieve all medical records associated with a specific user
const getMedicalRecordsByUser = async (req, res) => {
  try {
    const userId = req.params.userId;
    const medicalRecords = await MedicalRecord.find({ userId });

    res.status(200).json({ medicalRecords });
  } catch (error) {
    res.status(500).json({ error: 'Failed to retrieve medical records' });
  }
};

// Retrieve a single medical record by its unique identifier
const getMedicalRecordById = async (req, res) => {
  try {
    const recordId = req.params.recordId;
    const medicalRecord = await MedicalRecord.findById(recordId);

    if (!medicalRecord) {
      return res.status(404).json({ error: 'Medical record not found' });
    }

    res.status(200).json({ medicalRecord });
  } catch (error) {
    res.status(500).json({ error: 'Failed to retrieve medical record' });
  }
};

// Update an existing medical record
const updateMedicalRecord = async (req, res) => {
  try {
    const recordId = req.params.recordId;
    const { recordType, description, date } = req.body;
    const updatedMedicalRecord = await MedicalRecord.findByIdAndUpdate(
      recordId,
      { recordType, description, date },
      { new: true }
    );

    if (!updatedMedicalRecord) {
      return res.status(404).json({ error: 'Medical record not found' });
    }

    res.status(200).json({ message: 'Medical record updated successfully' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to update medical record' });
  }
};

// Delete a medical record by its unique identifier
const deleteMedicalRecord = async (req, res) => {
  try {
    const recordId = req.params.recordId;
    const deletedMedicalRecord = await MedicalRecord.findByIdAndDelete(recordId);

    if (!deletedMedicalRecord) {
      return res.status(404).json({ error: 'Medical record not found' });
    }

    res.status(200).json({ message: 'Medical record deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete medical record' });
  }
};

module.exports = {
  createMedicalRecord,
  getMedicalRecordsByUser,
  getMedicalRecordById,
  updateMedicalRecord,
  deleteMedicalRecord,
};
