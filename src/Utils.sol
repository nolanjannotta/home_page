pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";



    struct PageInfo {
        address owner;
        bytes32 checksum;
        uint version;
        uint children;
        mapping(uint => bytes32) versionArchive;
    
    }



    function getBoilerPlate(string memory baseUrl, bool child, string memory name) view returns (bytes memory boilerPlate) {
        string memory boilerPlate1 = string(abi.encodePacked("<!DOCTYPE html><html><head></head><body><h1>Welcome to your new ", child ? "ChildPage, " : "HomePage, ", Strings.toHexString(uint160(msg.sender), 20), "!"));
        string memory boilerPlate2 = string(abi.encodePacked("</h1><p>this page is accessible at ", baseUrl, Strings.toHexString(uint160(msg.sender), 20), child ? "/" : "", name));
        string memory boilerPlate3 = "</p></body></html>";
        boilerPlate = abi.encodePacked(boilerPlate1, boilerPlate2, boilerPlate3);

    } 
    
