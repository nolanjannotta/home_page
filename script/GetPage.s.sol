// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/HomePageV1.sol";
import "../src/ContentStore.sol";
import "forge-std/console.sol";


contract GetPage is Script {
    function run() external returns(string memory page) {
        // uint256 deployerPrivateKey = vm.env(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        
        HomePageV1 homePage = HomePageV1(0x02b0B4EFd909240FCB2Eb5FAe060dC60D112E3a4);

        // HomePageV1 homePage = HomePageV1(0x0165878A594ca255338adfa4d48449f69242Eb8F);
        string memory newPage = "<!DOCTYPE html> <html> <head> <body> <span> hello everyone!!!!! </span> </body> </head> </html>";
        string memory gallery = "<!DOCTYPE html> <html> <head> <style> body { display: flex; flex-wrap: wrap; height: 100vh; width: 100vw; padding: 10px; display: flex; justify-content: center; align-items: start; } .picture { display: flex; justify-content: center; content: ''; align-items: center; width: 27%; min-height: 25%; background-color: orange; /* box-sizing: border-box; */ padding: 10px; margin: 10px; /* display:inline-block; */ } .container { width: 60%; display: flex; flex-wrap: wrap; } </style> </head> <body> <div class='container'></div> <script> const url='https://arweave.net/ZewwyYPRnpEK-p3iGbDFsW6cu_R-e9m6JthAfZIGZ7A';let seed=1;function random(){let e=seed+=1831565813;return e=Math.imul(e^e>>>15,1|e),(((e^=e+Math.imul(e^e>>>7,61|e))^e>>>14)>>>0)/4294967296}const container=document.getElementsByClassName('container')[0];console.log(container);const getRandomSizes=e=>{for(let t=1;t<=e+1;t++){console.log(random());let n=150*random()+140,a=150*random()+140;var r=document.createElement('div');r.className='picture';let i=document.createElement('img');i.src=`https://arweave.net/ZewwyYPRnpEK-p3iGbDFsW6cu_R-e9m6JthAfZIGZ7A/${t}.jpg`,i.width=n,i.height=a,r.appendChild(i),container.appendChild(r)}};getRandomSizes(50); </script> <span> </span> </body> </html>";
        
        // page = homePage.childURI(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, "gallery");
        // homePage.updateChild("child1", newPage);
        // homePage.createChild("gallery", bytes(gallery));
        homePage.updateChild("gallery", gallery);
        vm.stopBroadcast();
    }
}
