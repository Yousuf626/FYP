const mongoose = require('mongoose');

const connectDatabase = async () => {
  try {
    // Use your actual MongoDB connection URL here
    const dbURL = 'mongodb://127.0.0.1:27017/MedQR';

    await mongoose.connect(dbURL, {
    //   useNewUrlParser: true,
    //   useUnifiedTopology: true
    });

    console.log('Connected to the database');
  } catch (error) {
    console.error('Database connection error:', error);
  }
};

module.exports = connectDatabase;
