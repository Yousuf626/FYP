var RegisterUser = artifacts.require('UserRegistry');
module.exports = function(deployer) {
  deployer.deploy(RegisterUser);
};
