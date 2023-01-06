pragma solidity 0.8.13;

import {PageInfo, getBoilerPlate} from "./Utils.sol";
import {IContentStore} from "./IContentStore.sol";


contract ChildPage {

    IContentStore public immutable contentStore;
    string baseUrl = "www.homePage.xyz/"; // example

    mapping(address => mapping(string => PageInfo)) internal addressToChildtoPage;

    constructor(address _contentStore) {
        contentStore = IContentStore(_contentStore);
    }

    function _createChild(string memory name, bytes memory html) internal {
        // require(addressToPage[msg.sender].checksum != bytes32(0), 'home page doesnt exist');
        (bytes32 checksum, address pointer) = contentStore.addContent(html);
        PageInfo storage page = addressToChildtoPage[msg.sender][name];
        page.owner = msg.sender;
        page.checksum = checksum;
        page.version = 1; 
        page.children = 0;
    }


    // creates a new child page for 'name' with custom html
    // function createChild(string memory name, bytes memory html) public {
    //     _createChild(name,html);
    // }
 

    // // creates a new child page for 'name' with boilerplate html
    // function createChild(string memory name) public returns(bytes memory) {
    //     bytes memory boilerplate = getBoilerPlate(baseUrl);
    //     _createChild(name, boilerplate);
    //     return boilerplate;
    // }


    function updateChild(string memory name, string memory newPage) public {
        PageInfo storage pageInfo = addressToChildtoPage[msg.sender][name];
        require(msg.sender == pageInfo.owner, "not owner");

        // try this too:
        // require(pageInfo, "page doesn't exit");

        (bytes32 checksum, address pointer) = contentStore.addContent(bytes(newPage));
        uint currentVersion = pageInfo.version;
        
        pageInfo.versionArchive[currentVersion] = pageInfo.checksum;
        pageInfo.owner = msg.sender;
        pageInfo.checksum = checksum;
        pageInfo.version = currentVersion + 1;

    }





}
