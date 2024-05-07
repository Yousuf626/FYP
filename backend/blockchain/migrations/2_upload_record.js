var RegisterUser = artifacts.require('MedicalRecord');
module.exports = function(deployer) {
  deployer.deploy(RegisterUser);
};