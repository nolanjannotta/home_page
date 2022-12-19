pragma solidity 0.8.13;
import {IContentStore} from "./IContentStore.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import {SSTORE2} from "solady/utils/SSTORE2.sol";







contract HomePageV1 {
    IContentStore public immutable contentStore;
    string baseUrl = "www.homePage.xyz/"; // example

    string boilerPlate1 = "<!DOCTYPE html><html><head></head><body><h1>Welcome to your new HomePage,";
    string boilerPlate2 = string(abi.encodePacked("</h1><p>this page is accessible at ", baseUrl));
    string boilerPlate3 = "</p></body></html>";
    
    struct PageInfo {
        // TODO track versions
        address owner;
        bytes32 checksum;
        uint version;
        uint children;
        mapping(uint => bytes32) versionArchive;
    }
    

    mapping(address => PageInfo) internal addressToPage;

    mapping(address => mapping(string => PageInfo)) internal addressToChildtoPage;

    

    constructor(address _contentStore) {
        contentStore = IContentStore(_contentStore);
    }

    function getHomePageInfo(address owner) public view returns(address, address, bytes32){
        PageInfo storage pageInfo = addressToPage[owner];
        address pointer = contentStore.getPointer(pageInfo.checksum);
        return (pageInfo.owner, pointer, pageInfo.checksum);
         
    }

    


    ///////////////////////////////////////////////////////home page//////////////////////////////////////////////////////////////////////////////

    // creates homepage for msg.sender with custom html
    function createHomePage(string memory html) public {
        // TODO: get ens name and use instead of address
        require(addressToPage[msg.sender].checksum == bytes32(0), "page already set");
        string memory ens;
        _createHomePage(msg.sender, bytes(html));

    }

    // creates default homepage for msg.sender
    function createHomePage() public {
        // TODO: get ens name and use instead of address
        require(addressToPage[msg.sender].checksum == bytes32(0), "page already set");
        string memory ens;
        bytes memory boilerplate = abi.encodePacked(boilerPlate1, Strings.toHexString(uint160(msg.sender), 20), boilerPlate2, Strings.toHexString(uint160(msg.sender), 20), boilerPlate3);
        _createHomePage(msg.sender, boilerplate);


    }

    function _createHomePage(address owner, bytes memory html) private {
        (bytes32 checksum, address pointer) = contentStore.addContent(html);
        PageInfo storage page = addressToPage[owner];
        page.owner = owner;
        page.checksum = checksum;
        page.version = 1; 
        page.children = 0;

    }

    
    function updateHomePage(string memory newPage) public {
        PageInfo storage pageInfo = addressToPage[msg.sender];
        require(msg.sender == pageInfo.owner, "not owner");
        // try this too:
        // require(pageInfo, "page doesn't exit");

        (bytes32 checksum, address pointer) = contentStore.addContent(bytes(newPage));
        uint currentVersion = pageInfo.version;
        pageInfo.versionArchive[currentVersion] = pageInfo.checksum;

        pageInfo.owner = msg.sender;
        pageInfo.checksum = checksum;
        pageInfo.version = currentVersion ++;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    function _createChild(string memory name, bytes memory html) private {
        require(addressToPage[msg.sender].checksum != bytes32(0), 'home page doesnt exist');
        (bytes32 checksum, address pointer) = contentStore.addContent(html);
        PageInfo storage page = addressToChildtoPage[msg.sender][name];
        page.owner = msg.sender;
        page.checksum = checksum;
        page.version = 1; 
        page.children = 0;
    }


    // creates a new child page for 'name' with custom html
    function createChild(string memory name, bytes memory html) public {
        _createChild(name,html);
    }
 

    // creates a new child page for 'name' with boilerplate html
    function createChild(string memory name) public returns(bytes memory) {
        bytes memory boilerplate = abi.encodePacked(boilerPlate1, name, boilerPlate2, Strings.toHexString(uint160(msg.sender), 20), "/", name, boilerPlate3);
        _createChild(name, boilerplate);
        return boilerplate;
    }


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


    function pageURI(address owner) public view returns(string memory) {
        PageInfo storage pageInfo = addressToPage[owner];
        address pointer = contentStore.getPointer(pageInfo.checksum);
        bytes memory html = SSTORE2.read(pointer);

        string memory dataUriStart = "data:text/html;base64,";

        return string(abi.encodePacked(dataUriStart, Base64.encode(html)));



    }
    function childURI(address owner, string memory name)  public view returns(string memory) {
        PageInfo storage pageInfo = addressToChildtoPage[owner][name];

        address pointer = contentStore.getPointer(pageInfo.checksum);
        bytes memory html = SSTORE2.read(pointer);

        string memory dataUriStart = "data:text/html;base64,";
        return string(abi.encodePacked(dataUriStart, Base64.encode(html)));

    }





}