const Web3 = require('web3').default;
const web3 = new Web3('http://localhost:7545');
const fs = require('fs');
require('dotenv').config
const path = require('path');
const contractAddress = process.env.Contract_Address_UserRepository; // replace with your contract address
// const abi = JSON.parse(fs.readFileSync(path.resolve(__dirname,'..','..','blockchain','build','constracts', 'UserRegistry.json'))).abi;

const abi = JSON.parse(fs.readFileSync('C:\\Users\\Yousuf\\Desktop\\etherium_tutorial\\fyp_1\\backend\\blockchain\\build\\contracts\\UserRegistry.json')).abi;

const contract = new web3.eth.Contract(abi, contractAddress);


async function registerUser() {
    try {

        // Create a new wallet instance
        const wallet = web3.eth.accounts.create();
        
        const accounts = await web3.eth.getAccounts();

        // Send the transaction to register the user
        const tx = await contract.methods.register(wallet.address).send({ from: accounts[1] });

        console.log('Transaction hash:', tx.transactionHash);
        // getRegisteredUsers();
        return wallet;
    } catch (error) {
        console.error('Error registering user:', error);
    }
}
async function getRegisteredUsers() {
  const userCount = await contract.methods.getUserCount().call();
  for (let i = 0; i < userCount; i++) {
      const userAddress = await contract.methods.userAddresses(i).call();
      const isRegistered = await contract.methods.registeredUsers(userAddress).call();
      console.log('User address:', userAddress, 'Is registered:', isRegistered);
  }
}

module.exports = registerUser;
