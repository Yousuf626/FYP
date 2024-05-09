// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract MedicalRecord {
    mapping(string => address) private fileHashes;
 
    function storeFileHash(string memory fileHash, address wallet) public {
        // Store the wallet address associated with the file hash
        fileHashes[fileHash] = wallet;
    }

    // function updateFileHashes(string[] memory newHashes, address wallet) public {
    //     fileHashes[wallet] = newHashes;
    // }

     // Optional: Function to retrieve the wallet address associated with a file hash
    function getFileHashOwner(string memory fileHash) public view returns (address) {
        return fileHashes[fileHash];
    }
}
