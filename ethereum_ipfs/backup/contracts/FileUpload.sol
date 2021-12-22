// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract FileUpload {
    struct File {
        string name;
        string fileHash;
    }
    File[] files;

    function storeFile(string memory name, string memory fileHash) public {
        files.push(File(name, fileHash));
    }

    function getFiles() public view returns (File[] memory) {
        return files;
    }
}
