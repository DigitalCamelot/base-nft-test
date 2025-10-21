// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
  Contract ERC-721 simplu pentru Base.
  - mint public (gratuit), cu supply limitat
  - baseURI setabil (metadata off-chain, ex. IPFS)
  - compatibil OpenZeppelin v5
*/

import "@openzeppelin/contracts@5.0.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract SimpleBaseNFT is ERC721, Ownable {
    uint256 public maxSupply;
    uint256 private _nextTokenId;
    string private _baseTokenURI;
    bool public mintOpen = true;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        uint256 maxSupply_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        _baseTokenURI = baseURI_;
        maxSupply = maxSupply_;
    }

    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
    }

    function setMintOpen(bool open) external onlyOwner {
        mintOpen = open;
    }

    function mint() external {
        require(mintOpen, "Mint closed");
        require(_nextTokenId < maxSupply, "Sold out");
        _nextTokenId++;
        _safeMint(msg.sender, _nextTokenId);
    }

    function totalMinted() external view returns (uint256) {
        return _nextTokenId;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }
}
