// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract MedicalRecord {
    mapping(address => string[]) private fileHashes;

    function storeFileHash(string memory fileHash, address wallet) public {
        fileHashes[wallet].push(fileHash);
    }

    function updateFileHashes(string[] memory newHashes, address wallet) public {
        fileHashes[wallet] = newHashes;
    }

    function getFileHashes(address wallet) public view returns (string[] memory) {
        return fileHashes[wallet];
    }
}
