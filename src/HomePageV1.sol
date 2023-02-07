pragma solidity 0.8.13;
// import {IContentStore} from "./IContentStore.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import {SSTORE2} from "solady/utils/SSTORE2.sol";
// import {ChildPage} from "./ChildPage.sol";
import {IContentStore} from "./IContentStore.sol";
import {PageInfo, getBoilerPlate} from "./Utils.sol";







contract HomePageV1 {

    IContentStore public immutable contentStore;
    string baseUrl = "www.homePage.xyz/"; // example

    mapping(address => mapping(string => PageInfo)) internal addressToChildtoPage;


    mapping(address => PageInfo) internal addressToPage;
    mapping(address => HeadElement) internal addressToHead;
    mapping(address => BodyElement) internal addressToBody;

    struct HeadElement {
        string start;
        string end;
        string[] elements;
    }

    struct BodyElement {
        string start;
        string end;
        string[] elements;
    }


 
    modifier HomePageExists {
        require(addressToPage[msg.sender].checksum != bytes32(0), "home page doesn't exist");
        _;

    }

    
    constructor(address _contentStore) {
        contentStore = IContentStore(_contentStore);
    }

    function getHomepageHeadElement(address owner) public view returns(string memory) {
        HeadElement memory head = addressToHead[owner];
        uint numElements = head.elements.length;
        bytes memory elements;
        for (uint i=0; i<numElements; i++) {
            elements = abi.encodePacked(elements, head.elements[i]);

        }
        return string(abi.encodePacked(head.start, elements, head.end));

    }

    function getHomePageInfo(address owner) public view returns(address pointer, bytes32 checksum, uint version){
        PageInfo storage pageInfo = addressToPage[owner];
        pointer = contentStore.getPointer(pageInfo.checksum);
        checksum = pageInfo.checksum;
        version = pageInfo.version;
         
    }

    function getChildPageInfo(address owner, string memory name) public view returns (address pointer, bytes32 checksum, uint version) {
         PageInfo storage pageInfo = addressToChildtoPage[owner][name];
         pointer = contentStore.getPointer(pageInfo.checksum);
         checksum = pageInfo.checksum;
         version = pageInfo.version;
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

    function revertChildPageToVersion(string memory name, uint version) public {
        PageInfo storage pageInfo = addressToChildtoPage[msg.sender][name];

        require(version < pageInfo.version, "version doesn't exist or is current version");
        bytes32 newChecksum = pageInfo.versionArchive[version];
        pageInfo.checksum = newChecksum;
        pageInfo.version = version;
    }

    


    function createChild(string memory name, bytes memory html) public HomePageExists {
        _createChild(name,html);
    }
 

    // creates a new child page for 'name' with boilerplate html
    function createChild(string memory name) public HomePageExists {
        bytes memory boilerplate = getBoilerPlate(baseUrl, true, name);
        _createChild(name, boilerplate);
    }

    


    ///////////////////////////////////////////////////////home page//////////////////////////////////////////////////////////////////////////////

    // creates homepage for msg.sender with custom html
    function createHomePage(string memory html) public {
        // TODO: get ens name and use instead of address
        require(addressToPage[msg.sender].checksum == bytes32(0), "page already set");
        _createHomePage(msg.sender, bytes(html));

    }

    // creates default homepage for msg.sender
    function createHomePage() public {
        // TODO: get ens name and use instead of address
        require(addressToPage[msg.sender].checksum == bytes32(0), "page already set");
        string memory ens;
        bytes memory boilerplate = getBoilerPlate(baseUrl, false, "");
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

    function createHeadElement(address owner)public {
        HeadElement storage head = addressToHead[owner];
        head.start = "<head>";
        head.end = "</head>";
        // head.elements.push('<script src="https://cdn.ethers.io/lib/ethers-5.2.umd.min.js" type="application/javascript"></script>');

    }

    function addToHeadElement(string memory newElement) public {
        HeadElement storage head = addressToHead[msg.sender];
        head.elements.push(newElement);
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
        pageInfo.version = currentVersion + 1;
    }

    function revertHomePageToVersion(uint version) public {
        PageInfo storage pageInfo = addressToPage[msg.sender];

        require(version < pageInfo.version, "version doesnt exist or is current version");
        bytes32 newChecksum = pageInfo.versionArchive[version];
        pageInfo.checksum = newChecksum;
        pageInfo.version = version;
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


    function createGallery() public {

    }



    // function multiCall(
    //     address[] calldata targets,
    //     bytes[] calldata data
    // ) external view returns (bytes[] memory) {
    //     require(targets.length == data.length, "target length != data length");

    //     bytes[] memory results = new bytes[](data.length);

    //     for (uint i; i < targets.length; i++) {
    //         (bool success, bytes memory result) = targets[i].staticcall(data[i]);
    //         require(success, "call failed");
    //         results[i] = abi.decode(result);
    //     }

    //     return results;
    // }





}