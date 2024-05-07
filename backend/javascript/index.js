const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const patientRoutes = require('./routes/patientRoutes');
const medicalRecordRoutes = require('./routes/medicalRecordRoutes');
const cors = require('cors');


const app = express();
app.use(cors());
// Middleware
app.use(bodyParser.json());

// Import the connectDatabase function from the database file
const connectDatabase = require('./config/database');

// Define an async function to use await
const initializeDatabase = async () => {
    try {
        await connectDatabase();
        console.log('Database connection successful');
    } catch (error) {
        console.error('Error connecting to database:', error);
    }
};

// Call the async function
initializeDatabase();


//localhost:3000/api/medical-records
// Routes
app.use('/api/patients', patientRoutes);
app.use('/api/medical-records',medicalRecordRoutes); // Include medical record routes

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});