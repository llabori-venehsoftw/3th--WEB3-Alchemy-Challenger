// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattlesUpd is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //mapping(uint256 => uint256) public tokenIdToLevels;

    struct tokenIdToData {
        uint256 level;
        uint256 speed;
        string strength;
        uint256 life;
    }
    mapping(uint256 => tokenIdToData) public tokenidtodata;

    /* Initializes contract with initial parameter */
    constructor() ERC721("Chain Battles", "CBTLS") {}

    /**
     * GenerateCharacter
     *
     * To generate and update the SVG image of our NFT
     *
     * @param tokenId The NFT Id
     */
    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    /**
     * getLevels
     *
     * To get the current level of an NFT
     *
     * @param tokenId The NFT Id
     */
    function getLevels(uint256 tokenId) public view returns (string memory) {
        //uint256 levels = tokenIdToLevels[tokenId];
        tokenIdToData storage t = tokenidtodata[tokenId];
        uint256 levels = t.level;
        return levels.toString();
    }

    /**
     * getTokenURI
     *
     * To get the TokenURI of an NFT
     *
     * @param tokenId The NFT Id
     */
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    /**
     * mint
     *
     * To mint - of course
     *
     *
     */
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        //tokenIdToLevels[newItemId] = 0;
        tokenIdToData storage t = tokenidtodata[newItemId];
        t.level = 0;
        t.speed = createRandom(50);
        t.strength = "low";
        t.speed = createRandom(100);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    /**
     * train
     *
     * To train an NFT and raise its level
     *
     * @param tokenId The NFT Id
     */
    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        //uint256 currentLevel = tokenIdToLevels[tokenId];
        tokenIdToData storage t = tokenidtodata[tokenId];
        uint256 currentLevel = t.level;
        t.level = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    /**
     * createRandom
     *
     * For create a Random Number
     *
     * @param number The Number Base
     */
    function createRandom(uint256 number) private view returns (uint256) {
        return uint256(blockhash(block.number - 1)) % number;
    }
}
