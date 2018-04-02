pragma solidity ^0.4.18;

import "./CharacterBattle.sol";
import "./ERC721.sol";

/// @dev ERC721 tokens are not interchangeable since each one is assumed to be unique, and are not divisible. You can only trade them in whole units, and each one has a unique ID.
contract SkeletorOwnership is CharacterBattle, ERC721 {

    mapping (uint => address) characterApprovals;

    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    /// @dev The balance of an account is the total number of characters (tokens) that address owns. 
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerCharacterCount[_owner];
    }

    /// @dev Returns the owner of the token.
    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return characterToOwner[_tokenId];
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        /// @dev Ensure that a user is not attempting to transfer to themselves.
        require(_to != msg.sender);
        /// @dev Decrease the old owners total character and inc the new owners. 
        ownerCharacterCount[msg.sender] = ownerCharacterCount[msg.sender].sub(1); 
        ownerCharacterCount[_to] = ownerCharacterCount[_to].add(1); 
        /// @dev Tranfer ownership.
        characterToOwner[_tokenId] = _to;
        /// @dev Declare the event.
        Transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        characterApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(characterApprovals[_tokenId] == msg.sender);
        // address owner = ownerOf(_tokenId);
        transfer(msg.sender, _tokenId);
    }

}