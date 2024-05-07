const Web3 = require('web3').default;
const web3 = new Web3('http://localhost:7545');
const fs = require('fs');
const path = require('path');
const contractAddress = process.env.Contract_Address_MedicalRecord; // replace with your contract address
const abi = JSON.parse(fs.readFileSync('C:\\Users\\Yousuf\\Desktop\\etherium_tutorial\\fyp_1\\backend\\blockchain\\build\\contracts\\MedicalRecord.json')).abi;

const contract = new web3.eth.Contract(abi, contractAddress);
async function uploadRecordToBlockchain(fileHash, fileBuffer) {
  try {
    const accounts = await web3.eth.getAccounts();

    // Estimate the gas required for the transaction
    const gasEstimate = await contract.methods.storeRecord(fileHash, fileBuffer.toString('base64')).estimateGas({ from: accounts[0] });

    // Send the transaction to upload record with a higher gas limit
    const tx = await contract.methods.storeRecord(fileHash, fileBuffer.toString('base64')).send({ from: accounts[0], gas: gasEstimate + 1000 });
    return tx;
  } catch (error) {
    console.error('Error uploading record to blockchain:', error);
    throw error;
  }
}

async function getRecord(hash) {
    // Call the smart contract function
    const record = await contract.methods.records(hash).call();
    
    console.log(`Record for hash ${hash}: ${record}`);
  }
  
  

module.exports = {uploadRecordToBlockchain,getRecord};
