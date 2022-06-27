// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AfricanCuisineNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("AfricanCuisineNFT", "ACNFT") {
    }

    struct Image {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => Image) private images;

    event Create(address seller, uint tokenId);

    event Sold(address seller, address buyer, uint tokenId);
    
    event ListTokenForSale(address seller, uint tokenId);

    // mint an NFt
    function safeMint(string memory uri, uint256 price)
        public
        payable
        returns (uint256)
    {
        require(bytes(uri).length > 0, "Enter valid uri");
        require(price > 0, "Price must be at least 1 wei");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(msg.sender, tokenId);

        _setTokenURI(tokenId, uri);
        createImage(tokenId, price);
        emit Create(msg.sender, tokenId);
        return tokenId;
    }
    // NFT Transfer Functionality

    function makeTransfer
    (address from, address to, uint256 tokenId)public{
        require(tokenId >= 0, "Enter valid token id");
        require(msg.sender == ownerOf(tokenId) || msg.sender == getApproved(tokenId), "Only the owner or an approved operator can perform this action");
        require(to != address(0), "Enter a valid address");
        _transfer(from, to, tokenId);
        images[tokenId].owner = payable(to);       
    }  

    //Create NFT Functionality
    function createImage(uint256 tokenId, uint256 price) private {
        images[tokenId] = Image(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender, address(this), tokenId);
    }

    //Buy NFT Functionality
    function buyImage(uint256 tokenId) public payable canBuyNFT(tokenId){
        uint256 price = images[tokenId].price;
        address seller = images[tokenId].seller;
        images[tokenId].owner = payable(msg.sender);
        images[tokenId].sold = true;
        images[tokenId].seller = payable(address(0));
        _transfer(address(this), msg.sender, tokenId);
        uint amount = msg.value;
        (bool success,) = seller.call{value: amount}("");
        require(success, "Payment failed");
        emit Sold(seller, msg.sender, tokenId);
        
    }


    //Sell NFT Functionality
    function sellImage(uint256 tokenId) public payable {
        require(tokenId >= 0, "Enter valid token id");
        require(
            images[tokenId].owner == msg.sender,
            "Only the owner of this NFT can perform this operation"
        );
        images[tokenId].sold = false;
        images[tokenId].seller = payable(msg.sender);
        images[tokenId].owner = payable(address(this));

        _transfer(msg.sender, address(this), tokenId);
        emit ListTokenForSale(msg.sender, tokenId);
    }

    function getImage(uint256 tokenId) public view returns (Image memory) {
        return images[tokenId];
    }

    function getImageLength() public view returns (uint256) {
        return _tokenIdCounter.current();
    }


   function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    modifier canBuyNFT(uint tokenId){
        require(tokenId >= 0, "Enter valid token id");
        require(msg.sender != images[tokenId].seller, "You can't buy your own NFT");
        require(
            msg.value == images[tokenId].price,
            "Please submit the asking price in order to complete the purchase"
        );
        _;
    }
}
