const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController');

router.post('/signup', patientController.signup);
router.post('/login', patientController.login);
router.post('/forgot-password', patientController.forgotPassword);
router.post('/verify-otp', patientController.verifyOTPAndChangePassword);
router.get('/get-user-info', patientController.UserInfo);
router.post('/storeAESkey',patientController.storeAESkey);

module.exports = router;