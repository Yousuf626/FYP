require('dotenv').config();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const Patient = require('../models/patient');
// const register = require('../registerUser');
const register_user = require('../blockchain_connection/register_user');
const verifyToken = require('./middleware/tokenauth'); // Assuming jwtVerify.js is in the same directory

exports.signup = async (req, res) => {
    try {

        // const { name, email, password } = req.body;
        //     const hashedPassword = await hashPassword(password);
            

        // Generate the RSA key pair
        const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
            modulusLength: 2048,  // the length of your key in bits
            publicKeyEncoding: {
                type: 'spki',      // recommended to be 'spki' by the Node.js docs
                format: 'pem'
            },
            privateKeyEncoding: {
                type: 'pkcs8',     // recommended to be 'pkcs8' by the Node.js docs
                format: 'pem'
            }
        });

        const { name, email, mobileNumber, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);
        
        const wallet = await register_user();
        // const x509Identity =  await register(email);
        const patient = new Patient({
            name,
            email,
            mobile: mobileNumber,
            password: hashedPassword,
           
            wallet_address: wallet.address,
            wallet_privateKey: wallet.privateKey,
        });
        console.log(publicKey);
        console.log(privateKey);

        await patient.save();
      
 
        res.status(201).json({
            message: 'Patient created successfully',
            wallet: wallet,
            rsaKeyPair: {
                publicKey: publicKey,
                privateKey: privateKey
            }
        });

        
    } catch (error) {
        console.log(error.message);
        res.status(500).json({ error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const patient = await Patient.findOne({ email });
        if (!patient) {
            return res.status(401).json({ message: 'No user with this email is registered' });
        }
        const isPasswordMatch = await bcrypt.compare(password, patient.password);
        if (!isPasswordMatch) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }
        const token = jwt.sign({ userId: patient._id }, process.env.SECRET_KEY, { expiresIn: '1h' });
        res.status(200).json({ token, expiresIn: 3600, userId: patient._id});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.forgotPassword = async (req, res) => {
    try {
        const { email } = req.body;
        const patient = await Patient.findOne({ email });
        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        // Generate random 4-digit OTP
        const otp = Math.floor(1000 + Math.random() * 9000);

        // Save the OTP to patient document in the database
        patient.resetPasswordOTP = otp;
        await patient.save();

        // Sending email with OTP
        const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: {
              user: process.env.GMAIL_USER,
              pass: process.env.GMAIL_PASS,
            },
          });

        const mailOptions = {
            from: process.env.GMAIL_USER,
            to: email,
            subject: 'Password Reset OTP',
            text: `Your OTP for password reset is: ${otp}`
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.error('Error sending email:', error);
                return res.status(500).json({ error: 'Failed to send OTP email' });
            }
            console.log('Email sent:', info.response);
            res.status(200).json({ message: 'OTP sent to your email' });
        });
    } catch (error) {
        console.error('Error in forgotPassword:', error);
        res.status(500).json({ error: error.message });
    }
};  

exports.verifyOTPAndChangePassword = async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;
        const patient = await Patient.findOne({ email });

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        // Check if OTP matches and is not expired
        if (patient.resetPasswordOTP !== otp) {
            return res.status(400).json({ message: 'Invalid OTP' });
        }

        const currentTime = new Date();
        if (currentTime > patient.resetPasswordExpires) {
            return res.status(400).json({ message: 'OTP has expired' });
        }

        // Hash the new password
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        patient.password = hashedPassword;
        patient.resetPasswordOTP = null;
        patient.resetPasswordExpires = null;

        await patient.save();

        res.status(200).json({ message: 'Password changed successfully' });
    } catch (error) {
        console.error('Error in verifyOTPAndChangePassword:', error);
        res.status(500).json({ error: error.message });
    }
};
exports.UserInfo = async (req, res) => {
    try {
      // Call verifyToken middleware to authenticate the request
      await verifyToken(req, res); 
  
      const userId = req.userId; // Access user ID attached by verifyToken
      const patient = await Patient.findById(userId);
      if (!patient) {
        return res.status(404).json({ message: 'User not found' });
      }
  
      const userDetails = {
        id: patient._id,
        email: patient.email,
        name: patient.name,
        mobileNumber: patient.mobile,
        // Exclude sensitive data
      };
  
      res.status(200).json(userDetails);
    } catch (error) {
      console.error('Error fetching user details:', error);
      res.status(500).json({ error: 'Failed to fetch user details' });
    }
  };
  