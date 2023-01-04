# Solution to Challenger #3 Alchemy University

Objetives:
By the end of this tutorial, you will learn how to do the following:

    * How to store NFTs metadata on chain
    * What is Polygon and why it's important to lower Gas fees.
    * How to deploy on Polygon Mumbai
    * How to process and store on-chain SVG images and JSON objects
    * How to modify your metadata based on your interactions with the NFT

## Beginning 🚀

_These instructions will allow you to get a copy of the project running on your local machine for
development and testing purposes._

See **Deployment** for how to deploy the project.

### Prerequisites 📋

To prepare for the rest of this tutorial, you need to have:

    npm (npx) version >= 8.5.5
    node version >= 16.13.1
    An Alchemy account (sign up here for free!)
    Add Polygon Mumbai to your MetaMask Wallet
    Get Free MATIC to deploy your NFT Smart Contract

The following is not required, but extremely useful:

    some familiarity with a command line
    some familiarity with JavaScript

Now let's begin building our smart contract

### Instalation 🔧

_Installation of all the necessary framework/libraries_

Open your terminal and create a new directory:

```
mkdir NFTOnChainMetadata
cd NFTOnCHainMetada
```

install Hardhat running the following command:

```
yarn install hardhat
```

Then initialize hardhat to create the project boilerplates:

```
npx hardhat init
```

You should then see a welcome message and options on what you can do. Select Create a JavaScript
project (All default setting are cool):

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx
hardhat init
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

Welcome to Hardhat v2.12.4

✔ What do you want to do? · Create a JavaScript project
✔ Hardhat project root: · /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata
✔ Do you want to add a .gitignore? (Y/n) · y
✔ Do you want to install this sample project's dependencies with yarn (@nomicfoundation/
hardhat-toolbox @nomicfoundation/hardhat-network-helpers @nomicfoundation/hardhat-chai-matchers
@nomiclabs/hardhat-ethers @nomiclabs/hardhat-etherscan chai ethers hardhat-gas-reporter
solidity-coverage @typechain/hardhat typechain @typechain/ethers-v5 @ethersproject/abi @ethersproject/
providers)? (Y/n) · y
```

To check if everything works properly, run:

```
npx hardhat test
```

If all is good, you must see:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx
hardhat test
Compiled 1 Solidity file successfully


  Lock
    Deployment
      ✔ Should set the right unlockTime (2757ms)
      ✔ Should set the right owner (41ms)
      ✔ Should receive and store the funds to lock
      ✔ Should fail if the unlockTime is not in the future (79ms)
    Withdrawals
      Validations
        ✔ Should revert with the right error if called too soon (66ms)
        ✔ Should revert with the right error if called from another account (58ms)
        ✔ Shouldn't fail if the unlockTime has arrived and the owner calls it (82ms)
      Events
        ✔ Should emit an event on withdrawals (76ms)
      Transfers
        ✔ Should transfer the funds to the owner (79ms)


  9 passing (3s)
```

Now we'll need to install the OpenZeppelin package to get access to the ERC721 smart contract standard
that we'll use as a template to build our NFTs smart contract.

```
yarn add @openzeppelin/contracts
```

We should observe something similar to:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ yarn add
@openzeppelin/contracts
yarn add v1.22.17
warning package.json: No license field
warning No license field
[1/4] Resolving packages...
[2/4] Fetching packages...
[3/4] Linking dependencies...
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "@types/chai@^4.2.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "@types/mocha@^9.1.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "@types/node@>=12.0.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "ts-node@>=8.0.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "typescript@>=4.5.0".
warning " > @typechain/ethers-v5@10.2.0" has unmet peer dependency "@ethersproject/bytes@^5.0.0".
warning " > @typechain/ethers-v5@10.2.0" has unmet peer dependency "typescript@>=4.3.0".
warning "@typechain/ethers-v5 > ts-essentials@7.0.3" has unmet peer dependency "typescript@>=3.7.0".
warning " > typechain@8.1.1" has unmet peer dependency "typescript@>=4.3.0".
[4/4] Building fresh packages...
success Saved lockfile.
warning No license field
success Saved 1 new dependency.
info Direct dependencies
└─ @openzeppelin/contracts@4.8.0
info All dependencies
└─ @openzeppelin/contracts@4.8.0
Done in 25.94s.
```

## Development of changes in configuration files/Smart Contract ⚙️

Modify the hardhat.config.js file. Open the hardhat.config.js file contained in the root of your
project and inside the module.exports object, copy the following code:

```
module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
};
```

When we'll deploy our smart contract, we'll also want to verify it using mumbai.polygonscan, to do so
we'll need to provide Hardhat with an etherscan or, in this case, Polygon scan API key.

We'll grab the Polygonscan API key later on, for the moment, just add the following code in the
hardhat.config.js file:

```
etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  }
```

At this point the file hardhar.config.js should be similar to:

```
require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  }
};
```

_Develop the Smart Contract_

In the contracts folder, create a new file and call it "ChainBattles.sol".

As always, we'll need to specify the SPDX-Licence-Identifier, the pragma, and import a couple of
libraries from OpenZeppelin that we'll use as a foundation of our smart contract:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
```

In this case, we're importing:

    The ERC721URIStorage contract that will be used as a foundation of our ERC721 Smart contract
    The counters.sol library, will take care of handling and storing our tokenIDs
    The string.sol library to implement the "toString()" function, that converts data into strings -
    sequences of characters
    The Base64 library that, as we've seen previous, will help us handle base64 data like our
    on-chain SVGs

Next, let's initialize the contract.

_Initialize the Smart Contract_

First of all, we'll need to create a new contract that inherits from the ERC721URIStorage extension
we imported from OpenZeppelin. Inside the contract, initialize the Strings and Counters library:

```
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
}
```

Now that we have initialized our libraries, declare a new tokenIds function that we'll need to store
our NFT IDs:

```
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
}
```

The last global variable we need to declare is the tokenIdToLevels mapping, which we'll use to store
the level of an NFT associated with its tokenId:

```
mapping(uint256 => uint256) public tokenIdToLevels;
```

The mapping will link an uint256, the NFTId, to another uint256, the level of the NFT.

Next, we'll need to declare the constructor function of our smart contract:

```
constructor() ERC721 ("Chain Battles", "CBTLS"){
}
```

At this point your code should look as follow:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

}

mapping(uint256 => uint256) public tokenIdToLevels;

constructor() ERC721 ("Chain Battles", "CBTLS"){
}
```

Now that we have the foundation of our NFT smart contract, we'll need to implement 4 different
functions:

    generateCharacter: to generate and update the SVG image of our NFT
    getLevels: to get the current level of an NFT
    getTokenURI: to get the TokenURI of an NFT
    mint: to mint - of course
    train: to train an NFT and raise its level

The cool thing about SVGs is that they can be:

    Easily modified and generate using code
    Easily converted to Base64 data

Now, you might wonder why we want to convert SVGs files into Base64 data, the answer is very simple:

You can display base64 images in the browser without the need for a hosting provider.

This is useful because, even if Solidity is not able to handle images, it is able to handle strings
and SVGs aren't anything else than sequences of tags and strings we can easily retrieve runtime,
plus, converting everything to base64, will allow us to store our images on-chain without the need of
object storage.

Now that we explained why SVGs are important, let's learn how to generate our own on-chain SVGs and
convert them into Base64 data.

_Create the generateCharacter Function to Create the SVG Image_

We'll need a function that will generate the NFT image on-chain, using some SVG code, taking into 
consideration the level of the NFT.

Doing this in Solidity is a little tricky, so let's copy the following code first, and then will go 
through the different parts of it:

```
function generateCharacter(uint256 tokenId) public returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
        "Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
        "Levels: ",getLevels(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )
    );
}
```

The first thing you should notice is the "bytes" type, a dynamically sized array of up to 32 bytes
where you can store strings, and integers.

In this case, we're using it to store the SVG code representing the image of our NFT, transformed
into an array of bytes thanks to the abi.encodePacked() function that takes one or more variables and
encodes them into abi.

As you can notice the SVG code takes the return value of a getLevels() function and use it to
populate the "Levels:" property - we'll implement this function later on, but take note that you can
use functions and variables to dynamically change your SVGs.

As we've seen before, to visualize an image on the browser we'll need to have the base64 version of
it, not the bytes version - plus, we'll need to prepend the "data:image/svg+xml;base64," string, to
specify to the browser that Base64 string is an SVG image and how to open it.

To do so, in the code above, we're returning the encoded version of our SVG turned into Base64 using
Base64.encode() with the browser specification string prepended, using the abi.encodePacked()
function.

Now that we have implemented the function to generate our image, we need to implement a function to
get the level of our NFTs.

_Create the getLevels Function to retrieve the NFT Level_

To get the level of our NFT, we'll need to use the tokenIdToLevels mapping we've declared in our
smart contract, passing the tokenId we want to get the level for into the function:

```
function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToLevels[tokenId];
    return levels.toString();
}
```

As you can see this was pretty straightforward, the only thing to notice is the toString() function,
that's coming from the OpenZeppelin Strings library, and transforms our level, that is an uint256,
into a string - that will be then be used by generateCharacter function as we've seen before.

_Create the getTokenURI Function to generate the tokenURI_

The getTokenURI function will need one parameter, the tokenId, and will use that to generate the
image, and build the name of the NFT.

```
function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}
```

_Create the Mint Function to create the NFT with on-chain metadata_

The mint function in this case will have 3 goals:

    Create a new NFT,
    Initialize the level value,
    Set the token URI.

```
function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToLevels[newItemId] = 0;
    _setTokenURI(newItemId, getTokenURI(newItemId));
}
```

As always, we first increment the value of our \_tokenIds variable, and store its current value on a new
uint256 variable, in this case, "newItemId".

Next, we call the \_safeMint() function from the OpenZeppelin ERC721 library, passing the msg.sender
variable, and the current id.

Then we create a new item in the tokenIdToLevels mapping and assign its value to 0, this means our NFTs/
character will start from level.

As the last thing, we set the token URI passing the newItemId and the return value of getTokenURI().

This will mint an NFT of which metadata, including the image, is completely stored on-chain 🔥

That also means we'll be able to update the metadata directly from the Smart Contract, let's see how to
create a function to train our NFTs and let them level up!

_Create the Train Function to raise your NFT Level_

As we said, now that the metadata of our NFTs is completely on-chain, we'll be able to interact with it
directly from the smart contract.

Let's say we want to raise the level of our NFTs after intensive training, to do so, we'll need to create a
train function that will:

    Make sure the trained NFT exists and that you're the owner of it.
    Increment the level of your NFT by 1.
    Update the token URI to reflect the training.

```
function train(uint256 tokenId) public {
require(_exists(tokenId), "Please use an existing token");
require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
uint256 currentLevel = tokenIdToLevels[tokenId];
tokenIdToLevels[tokenId] = currentLevel + 1;
_setTokenURI(tokenId, getTokenURI(tokenId));
}
```

As you can notice, using the require() function, we're checking two things:

    If the token exists, using the _exists() function from the ERC721 standard,
    If the owner of the NFT is the msg.sender (the wallet calling the function).

Once both checks are passed, we get the current level of the NFT from the mapping, and increment it by one.

Lastly, we're calling the \_setTokenURI function passing the tokenId, and the return value of getTokenURI
().

Calling the train function will now raise the level of the NFT and this will be automatically reflected in 
the image.

The next step is to deploy the smart contract on Polygon Mumbai and interact with it via Polygonscan. To 
do it, we'll need to grab our Alchemy and Polygonscan key.

_Deploy the NFTs with On-Chain Metadata Smart Contract_

First of all, let's create a new .env file in the root folder of our project, and add the following
variables:

```
TESTNET_RPC=""
PRIVATE_KEY=""
POLYGONSCAN_API_KEY=""
```

Then, navigate to alchemy.com and create a new Polygon Mumbai application:

Click on the newly created app, copy the API HTTP URL, and paste the API as "TESTNET_RPC" value in the .
env file we created above.

Open your Metamask wallet, click on the three dots menu > account details > and copy-paste your private
key as "PRIVATE_KEY" value in the .env.

Lastly, go on polygonscan.com, and create a new account. Once you'll have logged in, go on your profile
menu and click on API Keys. Now copy-paste the Api-Key Token as "POLYGONSCANAPI_KEY" value in the .env.

One last step before deploying our Smart contract, we'll need to create the deployment script.

_Create the Deployment Script_

The deployment script, as the name suggests, tell Hardhat how to deploy the smart contract to the
specified blockchain. Our deployment script, in this case, is pretty straightforward:

```
const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
```

We're calling the get.contractFactory, passing the name of our smart contract, from Hardhat ethers. We
then call the deploy() function and wait for it to be deployed, logging the address. Everything is
wrapped into a try{} catch{} block to catch any error that might occur and print it out for
debugging purposes. Now that our deployment script is ready, it's time to compile and deploy our dynamic
NFT smart contract on Polygon Mumbai.

_Compile and Deploy the smart contract_

To compile the smart contract simply run the following command, in the terminal inside the project:

```
npx hardhat compile
```

If you see the follow error:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
compile
An unexpected error occurred:

Error: Cannot find module 'dotenv'
Require stack:
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
config/config-loading.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/cli.
js
    at Function.Module._resolveFilename (node:internal/modules/cjs/loader:985:15)
    at Function.Module._load (node:internal/modules/cjs/loader:833:27)
    at Module.require (node:internal/modules/cjs/loader:1057:19)
    at require (node:internal/modules/cjs/helpers:103:18)
    at Object.<anonymous> (/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.
    config.
    js:1:1)
    at Module._compile (node:internal/modules/cjs/loader:1155:14)
    at Object.Module._extensions..js (node:internal/modules/cjs/loader:1209:10)
    at Module.load (node:internal/modules/cjs/loader:1033:32)
    at Function.Module._load (node:internal/modules/cjs/loader:868:12)
    at Module.require (node:internal/modules/cjs/loader:1057:19) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
    config/config-loading.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/
    cli.
    js'
  ]
}
```

Then open your terminal in your project's root directory (where your package.json file is located) and
run the following command:

```
npm install dotenv
```

If you see the follow error:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
compile
An unexpected error occurred:

Error: Cannot find module '@nomiclabs/hardhat-waffle'
Require stack:
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
config/config-loading.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/cli.
js
    at Function.Module._resolveFilename (node:internal/modules/cjs/loader:985:15)
    at Function.Module._load (node:internal/modules/cjs/loader:833:27)
    at Module.require (node:internal/modules/cjs/loader:1057:19)
    at require (node:internal/modules/cjs/helpers:103:18)
    at Object.<anonymous> (/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.
    config.js:2:1)
    at Module._compile (node:internal/modules/cjs/loader:1155:14)
    at Object.Module._extensions..js (node:internal/modules/cjs/loader:1209:10)
    at Module.load (node:internal/modules/cjs/loader:1033:32)
    at Function.Module._load (node:internal/modules/cjs/loader:868:12)
    at Module.require (node:internal/modules/cjs/loader:1057:19) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
    config/config-loading.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/
    cli.js'
  ]
}
```

Then open your terminal in your project's root directory (where your package.json file is located) and
run the following command:

```
npm install --save-dev @nomiclabs/hardhat-waffle 'ethereum-waffle@^3.0.0' @nomiclabs/hardhat-ethers
'ethers@^5.0.0'
```

To recompile the smart contract simply run the following command, in the terminal inside the project:

```
npx hardhat compile
```

You should to see:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
compile
Compiled 14 Solidity files successfully
```

If everything goes as expected, you'll see your smart contract compiled inside the artifacts folder.

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "a title")

Now, let's deploy the smart contract on the Polygon Mumbai chain running:

```
npx hardhat run scripts/deploy.js --network mumbai
```

Wait 10-15 seconds and you should see the address of your Smart contract printed out in your terminal:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
run scripts/deploy.js --network mumbai
Contract deployed to: 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0 NOTE = You contract address is diferent
to this
```

_Check your smart contract on Polygon Scan_

Copy the address of the just deployed smart contract, go to mumbai.polygonscan.com, and paste the 
address of the smart contract in the search bar.

Once on your smart contract page, click on the "Contract" tab.

You'll notice that the contract code is not readable:

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "a title")

This is because we haven't yet verified our code.

To verify our smart contract we'll need to go back to our project, and, in the terminal, run the 
following code:

```
npx hardhat verify --network mumbai YOUR_SMARTCONTRACT_ADDRESS
For me:
npx hardhat verify --network mumbai 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0
```

You'll to see:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
verify --network mumbai 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0
Nothing to compile
Successfully submitted source code for contract
contracts/ChainBattles.sol:ChainBattles at 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0
for verification on the block explorer. Waiting for verification result...

Successfully verified contract ChainBattles on Etherscan.
https://mumbai.polygonscan.com/address/0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0#code
```

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "a title")

To interact with it, and mint the first NFT, click on the "Write Contract" button under the "contract" 
tab, and click on "connect to Web3"

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "a title")

This will open a Metamask popup that will ask you to pay for the gas fees, click on the sign button.

Congratulations! You've just minted your first dynamic NFT - let's move to OpenSea Testnet to see it 
live.

_View your Dynamic NFT On OpenSea_

Copy the smart contract address, go to testnet.opensea.com, and paste it into the search bar:

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "un título")

If everything worked as expected you should now see your NFT displaying on OpenSea, with its dynamic image,
the title, and the description. Nothing new until now though, we already built an NFT collection in the
first lesson, what's cool here is that we can now update the image in real-time.

Let's go back to Polygon scan.

_Update the Dynamic NFT Image Training The NFT_

Navigate back to mumbai.polygonscan.com, click on the contract tab > Write Contract and look for the
"train" function.

Insert the ID of your NFT - "1" in this case, as we minted only one, and click on Write:

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "un título")

Then go back to testnets.opensea.com and refresh the page:

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "un título")


## Challenger 🛠️

At the moment we're only storing the level of our NFTs, why not store more?

Substitute the current tokenIdToLevels[] mapping with a struct that stores:

    Level
    Speed
    Strength
    Life

You can read more about structs in this guide.

Once you'll have created the struct, initialize the stats in the mint() function, to do so you might want 
to look into pseudo number generation on Solidity.

The result after executing the changes in the Smart Contract should be similar to:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat compile
Compiled 1 Solidity file successfully
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat run scripts/deployUpd.js --network mumbai
Contract deployed to: 0x6A4481b500E143aF4032d2ace316AFb557628873 NOTE = You contract address is diferent
to this
```

And make sure to share your reflections on this project to earn your Proof of Knowledge (PoK) token:
https://university.alchemy.com/discord

## Built with 🛠️

_Herramientas que utilizaste para crear tu proyectoTools you used to develop the challenge_

- [Visual Studio Code](https://code.visualstudio.com/) - The IDE
- [Alchemy](https://dashboard.alchemy.com) - Interface/API to the Goerli Tesnet Network
- [Xubuntu](https://xubuntu.org/) - Operating system based on Ubuntu distribution.
- [Polygon/Mumbai](https://mumbai.polygonscan.com/) - Web system used to verify transactions, verify
contracts, deploy contracts, verify and publish contract source code, etc; for network Polygon.
- [Polygon Scan](https://polygonscan.com) - To generate the API's Keys for interact with Polygon Mumbai 
Tesnet
- [Opensea](https://testnets.opensea.io) - Web system used to verify/visualizate our NFT
- [Solidity](https://soliditylang.org ) Object-oriented programming language for implementing smart
contracts on various blockchain platforms
- [Hardhat](https://hardhat.org) - Environment developers use to test, compile, deploy and debug dApps
based on the Ethereum blockchain
- [GitHub](https://github.com/) - Internet hosting service for software development and version
control using Git
- [Mumbai Faucet](https://mumbaifaucet.com/) - Faucet used to obtain Test MATIC used in the tests to deploy
the SmartContrat as well as to interact with them.
- [MetaMask](https://metamask.io) - MetaMask is a software cryptocurrency wallet used to interact with
the Ethereum blockchain.

## Contributing 🖇️

Please read the [CONTRIBUTING.md](https://gist.github.com/llabori-venehsoftw/xxxxxx) for details of our 
code of conduct, and the process for submitting pull requests to us.

## Wiki 📖

N/A

## Versioning 📌

We use [GitHub] for versioning all the files used (https://github.com/tu/proyecto/tags).

## Autores ✒️

_People who collaborated with the development of the challenge_

- **VeneHsoftw** - _Initial Work_ - [venehsoftw](https://github.com/venehsoftw)
- **Luis Labori** - _Initial Work_, _Documentationn_ - [llabori-venehsoftw](https://github.com/
llabori-venehsoftw)

## License 📄

This project is licensed under the License (Your License) - see the file [LICENSE.md](LICENSE.md) for
details.

## Gratitude 🎁

- If you found the information reflected in this Repo to be of great importance, please extend your
  collaboration by clicking on the star button on the upper right margin. 📢
- If it is within your means, you may extend your donation using the following address:
  `0xAeC4F555DbdE299ee034Ca6F42B83Baf8eFA6f0D`

---

⌨️ con ❤️ por [Venehsoftw](https://github.com/llabori-venehsoftw) 😊
