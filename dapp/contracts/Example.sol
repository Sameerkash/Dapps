// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Example {
    string name = "Hello Flutter!";

    function setName(string memory cname) public {
        name = cname;
    }

    function getName() public view returns (string memory) {
        return name;
    }
}
