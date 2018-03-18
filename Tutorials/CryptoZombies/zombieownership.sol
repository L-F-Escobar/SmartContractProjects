//1. Enter solidity version here
pragma solidity ^0.4.18;

/**
Will implement all ERC721 logic here.
ERC721 tokens are not interchangeable since each one is assumed to be unique, and are not divisible. You can only trade them in whole units, and each one has a unique ID.
*/

// Multiple imports.
import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

//2. Create contract here
// contract can inherit from multiple contracts.

/// @title CryptoZombies
/// @author LD2045
/// @dev https://cryptozombies.io/en
contract ZombieOwnership is ZombieAttack, ERC721 {

    mapping (uint => address) zombieApprovals;

    function balanceOf(address _owner) public view returns (uint _balance) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        // adjust owners total counts.
        // safemath.
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        // transfer ownership by updating value.
        zombieToOwner[_tokenId] = _to;
        // trigger event from erc721.sol.
        Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        // msg.sender because the owner is calling here.
        _transfer(msg.sender, _to, _tokenId);
    }
    
    // 2. Add function modifier here
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        // 3. Define function here
        zombieApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
    // Start here
        require(zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

}