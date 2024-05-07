// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract UserRegistry {
    // Mapping to store user addresses and registration status
    mapping(address => bool) public registeredUsers;
    // Array to store user addresses
    address[] public userAddresses;

    // Event to emit when a user registers
    event UserRegistered(address indexed userAddress);

    // Function to register a user
    function register(address user) public {
        require(!registeredUsers[user], "User already registered");

        registeredUsers[user] = true;
        userAddresses.push(user);

        emit UserRegistered(user);
    }

    // Function to get the count of registered users
    function getUserCount() public view returns (uint256) {
        return userAddresses.length;
    }
}
