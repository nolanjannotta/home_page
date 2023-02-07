// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../src/HomePageV1.sol";
import "../src/ContentStore.sol";
import "../src/IContentStore.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";



// i went to lib\forge-std\src\Test.sol and removed stdCheats from the inheritance


contract HomePageTest is Test {
    HomePageV1 public homePage;
    IContentStore public contentStore;

    struct Page {
        address owner;
        address pointer;
        bytes32 checksum;
    }

    string expectedHomePageBoilerplate = "data:text/html;base64,PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PC9oZWFkPjxib2R5PjxoMT5XZWxjb21lIHRvIHlvdXIgbmV3IEhvbWVQYWdlLCAweGI0Yzc5ZGFiOGYyNTljN2FlZTZlNWIyYWE3Mjk4MjE4NjQyMjdlODQhPC9oMT48cD50aGlzIHBhZ2UgaXMgYWNjZXNzaWJsZSBhdCB3d3cuaG9tZVBhZ2UueHl6LzB4YjRjNzlkYWI4ZjI1OWM3YWVlNmU1YjJhYTcyOTgyMTg2NDIyN2U4NDwvcD48L2JvZHk+PC9odG1sPg==";
    string expectedChildPageBoilerPlate = "data:text/html;base64,PCFET0NUWVBFIGh0bWw+PGh0bWw+PGhlYWQ+PC9oZWFkPjxib2R5PjxoMT5XZWxjb21lIHRvIHlvdXIgbmV3IENoaWxkUGFnZSwgMHhiNGM3OWRhYjhmMjU5YzdhZWU2ZTViMmFhNzI5ODIxODY0MjI3ZTg0ITwvaDE+PHA+dGhpcyBwYWdlIGlzIGFjY2Vzc2libGUgYXQgd3d3LmhvbWVQYWdlLnh5ei8weGI0Yzc5ZGFiOGYyNTljN2FlZTZlNWIyYWE3Mjk4MjE4NjQyMjdlODQvdGhpc0lTQUNoaWxkUGFnZTwvcD48L2JvZHk+PC9odG1sPg==";
    string expectedUpdatedChildPageURI = "data:text/html;base64,PCFET0NUWVBFIGh0bWw+IDxodG1sPiA8aGVhZD4gPHRpdGxlPm5vbGFuIGphbm5vdHRhPC90aXRsZT48L2hlYWQ+IDxib2R5PiBoZWxsbywgdGhpcyBpcyB0aGUgdXBkYXRlZCBjaGlsZCBwYWdlLi4uIDwvYm9keT4gPC9odG1sPg==";
    string expectedUpdatedHomePageURI = "data:text/html;base64,PCFET0NUWVBFIGh0bWw+IDxodG1sPiA8aGVhZD4gPHRpdGxlPm5vbGFuIGphbm5vdHRhPC90aXRsZT48L2hlYWQ+IDxib2R5PiBoZWxsbywgdGhpcyBpcyB0aGUgdXBkYXRlZCBob21lIHBhZ2UuLi4gPC9ib2R5PiA8L2h0bWw+";
    
    function setUp() public {
        contentStore = new ContentStore();
        homePage = new HomePageV1(address(contentStore));
       
    }

    function testCreateHomePage() public {
        // string memory name = "bobs website";
        homePage.createHomePage();

        (address pointer, bytes32 checksum, uint version) = homePage.getHomePageInfo(address(this));
        assertEq(version, 1);
        
    }
    function testGetHomepageHeadElement() public {
        
        string memory head = homePage.getHomepageHeadElement(address(this));
        console.log(head);
    }

    function testAddToHead() public {
        string memory newTag = '<script src="https://cdn.ethers.io/lib/ethers-5.2.umd.min.js" type="application/javascript"></script>';
        string memory otherNewTag = '<script src="https://cdnjs.cloudflare.com/ajax/libs/tensorflow/4.2.0/tf.min.js" integrity="sha512-luqeEXU5+ipFs8VSUJZTbt6Iil1m7OT0bODSccqew2CN85iad5Mn//M9+CPVI4UGlo8kN51OWFSox+fYe4qgYQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>';
        string memory expectedHead = string(abi.encodePacked("<head>", newTag,otherNewTag, "</head>"));
        homePage.createHeadElement(address(this));
        string memory head = homePage.getHomepageHeadElement(address(this));
       
        homePage.addToHeadElement(newTag);
        homePage.addToHeadElement(otherNewTag);
        head = homePage.getHomepageHeadElement(address(this));
        assertEq(expectedHead, head);

        
    }

    function testUpdateHomePage() public {
        string memory newPage = "<!DOCTYPE html> <html> <head> <title>nolan jannotta</title></head> <body> hello, this is the updated home page... </body> </html>";
        // string memory name = "bobs website";
        homePage.createHomePage();
        homePage.updateHomePage(newPage);
        string memory page = homePage.pageURI(address(this));
        assertEq(expectedUpdatedHomePageURI, page);

        (,, uint version) = homePage.getHomePageInfo(address(this));
        assertEq(version, 2);


    }

    function testRevertHomePage() public {
        string memory newPage = "<!DOCTYPE html> <html> <head> <title>nolan jannotta</title></head> <body> hello, this is the updated home page... </body> </html>";
        // string memory name = "bobs website";
        homePage.createHomePage();
        homePage.updateHomePage(newPage);

        homePage.revertHomePageToVersion(1);

        string memory revertedVersion = homePage.pageURI(address(this));
        assertEq(expectedHomePageBoilerplate, revertedVersion);

        (,, uint version) = homePage.getHomePageInfo(address(this));
        assertEq(version, 1);
        



    }

    function testRevertChildPage() public {
        string memory newPage = "<!DOCTYPE html> <html> <head> <title>nolan jannotta</title></head> <body> hello, this is the updated home page... </body> </html>";
        string memory name = "thisISAChildPage";
        homePage.createHomePage();
        homePage.createChild(name);
        homePage.updateChild(name, newPage);

        homePage.revertChildPageToVersion(name, 1);

        string memory revertedVersion = homePage.childURI(address(this), name);
        assertEq(expectedChildPageBoilerPlate, revertedVersion);

        (,, uint version) = homePage.getChildPageInfo(address(this), name);
        assertEq(version, 1);
        



    }
    function testPageURI() public {
        homePage.createHomePage();
        string memory page = homePage.pageURI(address(this));
    }

    function testBoilerPlate() public {
        homePage.createHomePage();
        string memory boilerplate = homePage.pageURI(address(this));
        assertEq(expectedHomePageBoilerplate, boilerplate);
        
    }


    function testCreateChildPage() public {
        string memory name = "thisISAChildPage";
        homePage.createHomePage();
        homePage.createChild(name);

        (address pointer, bytes32 checksum, uint version) = homePage.getChildPageInfo(address(this), name);
        assertEq(version, 1);

    }
    function testUpdateChildPage() public {
        string memory newPage = "<!DOCTYPE html> <html> <head> <title>nolan jannotta</title></head> <body> hello, this is the updated child page... </body> </html>";
        string memory name = "thisISAChildPage";
        homePage.createHomePage();
        homePage.createChild(name);
        homePage.updateChild(name, newPage);
        string memory page = homePage.childURI(address(this), name);
        assertEq(expectedUpdatedChildPageURI, page);

        (,, uint version) = homePage.getChildPageInfo(address(this), name);
        assertEq(version, 2);

    }

    function testChildBoilerPlate() public {
        string memory name = "thisISAChildPage";
        homePage.createHomePage();
        homePage.createChild(name);
        string memory uri = homePage.childURI(address(this), name);
        assertEq(expectedChildPageBoilerPlate, uri);

    }

    

    

    


    

    

    

}
