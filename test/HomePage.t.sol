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

    function setUp() public {
        contentStore = new ContentStore();
        homePage = new HomePageV1(address(contentStore));
       
    }

    function testBoilerPlate() public {
        bytes memory boilerplate = homePage.createHomePage();
    }

    function testCreateHomePage() public {
        // string memory name = "bobs website";
        homePage.createHomePage();

        (address owner, address pointer, bytes32 checksum) = homePage.getHomePageInfo(address(this));
        
        console.log(pointer);
        console.log(owner);
        console.log(Strings.toHexString(uint(checksum)));

    }

    function testPageURI() public {
        // string memory name = "bobs website";
        homePage.createHomePage();
        string memory page = homePage.pageURI(address(this));
    }

    function testUpdatePage() public {
        string memory newPage = "<!DOCTYPE html> <html> <head> <title>nolan jannotta</title> <style> body { background-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUnPiA8bGluZSB4MT0iMjAwIiB5MT0iMCIgeDI9IjIxMCIgeTI9IjgwMCIgc3Ryb2tlPSIjZThlNmUyIiA+IDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9IngxIiB2YWx1ZXM9IjE5MDsyMTA7MTkwIiBkdXI9IjIwIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgLz4gPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0ieDIiIHZhbHVlcz0iMjEwOzIwMDsyMTAiIGR1cj0iMzAiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPiA8L2xpbmU+IDxsaW5lIHgxPSI1NTAiIHkxPSIwIiB4Mj0iNTAwIiB5Mj0iODAwIiBzdHJva2U9IiNlOGU2ZTIiPiA8YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJ4MSIgdmFsdWVzPSI1NDA7NTYwOzU0MCIgZHVyPSIzMCIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+IDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9IngyIiB2YWx1ZXM9IjUyMDs1MDA7NTIwIiBkdXI9IjIwIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgLz4gPC9saW5lPiA8bGluZSB4MT0iNjAwIiB5MT0iMCIgeDI9IjU2MCIgeTI9IjgwMCIgc3Ryb2tlPSIjZThlNmUyIj4gPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0ieDEiIHZhbHVlcz0iNTkwOzYxMDs1OTAiIGR1cj0iMjAiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPiA8YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJ4MiIgdmFsdWVzPSI1ODA7NTYwOzU4MCIgZHVyPSIzMCIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+IDwvbGluZT4gPGxpbmUgeDE9IjEyMDAiIHkxPSIwIiB4Mj0iMTIwMCIgeTI9IjgwMCIgc3Ryb2tlPSIjZThlNmUyIj4gPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0ieDEiIHZhbHVlcz0iMTE5MDsxMjEwOzExOTAiIGR1cj0iMjAiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPiA8YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJ4MiIgdmFsdWVzPSIxMTkwOzEyMTA7MTE5MCIgZHVyPSIzMCIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+IDwvbGluZT4gPGxpbmUgeDE9IjkwMCIgeTE9IjAiIHgyPSIxNjAwIiB5Mj0iNDAwIiBzdHJva2U9IiNlOGU2ZTIiPiA8YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJ4MSIgdmFsdWVzPSI4OTA7OTEwOzg5MCIgZHVyPSIyMCIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+IDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9InkyIiB2YWx1ZXM9IjM5MDs0MTA7MzkwIiBkdXI9IjMwIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgLz4gPC9saW5lPiA8bGluZSB4MT0iMCIgeTE9IjMwMCIgeDI9IjE2MDAiIHkyPSI2MDAiIHN0cm9rZT0iI2U4ZTZlMiI+IDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9InkxIiB2YWx1ZXM9IjI5MDszMTA7MjkwIiBkdXI9IjIwIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgLz4gPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0ieTIiIHZhbHVlcz0iNTkwOzYxMDs1OTAiIGR1cj0iMzAiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPiA8L2xpbmU+IDwvc3ZnPg==); margin: 0px; width: 100%; height: 100%; overflow-y: hidden; background-repeat: no-repeat; background-color: #FFFDF9; background-position: center; background-attachment: fixed; } div { transform: rotate(1.5deg); padding: 10%; } h4 { font-size:20px; } h2 { font-weight: normal; letter-spacing: 1px; } li { padding: 5px; } a { text-decoration: none; } .spin { transition-duration: 1s; display:inline-block } .spin1 { display:inline-block; transition-duration: 40s; transition-delay: 2s; } .spin2 { display:inline-block; transition-duration: 30s; } .spin3 { display:inline-block; transition-duration: 10s; } .spin4 { display:inline-block; transition-duration: 5s; transition-delay: 7s; } .spin:hover { transform: rotatez(-360deg); } .mood { transition-duration: 1s; display:inline-block } .mood:hover { transform: rotatex(180deg); } .topLeft:hover .spin1 { transform: rotatez(-360deg); } .topLeft:hover .spin2 { transform: rotatez(360deg); } .topLeft:hover .spin3 { transform: rotatex(-360deg); } .topLeft:hover .spin4 { transform: rotatex(-1080deg); } .topLeft { position: fixed; top: 20px; left: 15px; height: 20%; width: 40%; padding: 40px; border: 1px solid #100702; color: #100702; transform: rotate(3deg); } .topRight { position: fixed; right: 15px; top: 20px; width: 40%; height: 15%; padding: 40px; border: 1px solid #100702; color: #100702; transform: rotate(2deg) skewY(-3deg); } .links { margin-top: 10px; margin-bottom: 20px; transform: skewX(-35deg) skewY(5deg); letter-spacing: 1.5px; } .digital { position: fixed; left: 15px; top: 33%; width: 90%; height: 22%; padding: 40px; border: 2px solid #100702; color: #100702; transform: skewY(2deg); } .physical { position: fixed; left: 15px; bottom: 25px; height: 20%; width: 90%; padding: 40px; border: 1px solid #100702; color: #100702; transform: rotate(.5deg); transform: skewX(5deg); } .physicalThings { transform: rotate(3deg); } </style> </head> <body> <div class='topLeft'> <h1> <span class='spin1'>&#x1D697;</span>&#x1D698;&#x1D695;<span class='spin4'>&#x1D68A;</span>&#x1D697; <span class='spin2'>&#x1D693;</span>&#x1D68A;&#x1D697;&#x1D697;&#x1D698;<span class='spin3'>&#x1D69D;</span>&#x1D69D;<span class='spin'>&#x1D68A;</span> </h1> <p class='links'> &loang; developer & creator &rect; los angeles &xutri; <a href='https://twitter.com/jannotta_nolan' target='blank'>twitter</a> &olcir; <a href='https://github.com/nolanjannotta' target='blank'>github</a> &roang; </p> </div> <div class='topRight'> <h2>&boxv; T B A &boxv;</h2> </div> <div class='digital'> <h2>&boxv; &dopf;&iopf;&gopf;&iopf;&topf;&aopf;&lopf; &nbsp; &topf;&hopf;&iopf;&nopf;&gopf;&sopf; &boxv;</h2> <ul> <li>s n a k e s &nbsp; &roarr; &nbsp; a fully on chain and playable game of snake on Ethereum mainnet. check it out <a href='https://snake-nft.arweave.dev/'>here.</a></li> <li>c a l c u l a t o r s &nbsp; &roarr; &nbsp; a fully on chain and functional calculator on Ethereum mainnet. more details <a href='https://s6v3nvdflvf6lbmvyktbuhwckkx6wxxlk54muqim3i4siwnnaupa.arweave.net/l6u21GVdS-WFlcKmGh7CUq_rXutXeMpBDNo5JFmtBR4/'>here</a>.</li> <li>k e y b o a r d s &nbsp; &roarr; &nbsp; a fully on chain virtual keyboard playable via computer keyboard. the keyboard and additional sounds are available to mint and install on Arbitrum mainnet. to learn more or play and manage your keyboards, click <a href='https://3szarl6dzyiypmhnj2bqplaiqydgn5qmh24iu7zz6nzr5q5fwuxa.arweave.net/3LIIr8POEYew7U6DB6wIhgZm9gw-uIp_OfNzHsOltS4/'>here</a>.</li> </ul> </div> <div class='physical'> <h2 class='physicalThings'>&boxv; &#x1F13F;&#x1F137;&#x1F148;&#x1F142;&#x1F138;&#x1F132;&#x1F130;&#x1F13B; &#x1F143;&#x1F137;&#x1F138;&#x1F13D;&#x1F136;&#x1F142; &boxv;</h2> <ul> <li>m o o d &nbsp; b o a r d &nbsp; &roarr; &nbsp; <a href='https://twitter.com/jannotta_nolan' target='blank'> <span class='mood'>&ofcir;</span> </a></li> </ul> </div> </body> </html>";
        // string memory name = "bobs website";
        homePage.createHomePage();
        homePage.updateHomePage(newPage);
        string memory page = homePage.pageURI(address(this));
        console.log(page);

    }

}
