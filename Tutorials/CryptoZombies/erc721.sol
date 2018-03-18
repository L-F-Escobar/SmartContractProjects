/**
    Including it here for education purposes.

    ERC721 Standard

    To use, will need to implement in our contract.
*/
contract ERC721 {
    
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);

  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public view returns (uint256 _balance);

  function ownerOf(uint256 _tokenId) public view returns (address _owner);

  // owner calls transfer with the address he wants to transfer to, and the _tokenId of the token he wants to transfer.
  function transfer(address _to, uint256 _tokenId) public;

  // token's owner first calls approve, and sends it the same info as above. The contract then stores who is approved to take a token, usually in a mapping (uint256 => address).
  function approve(address _to, uint256 _tokenId) public;

  // receiver calls. The contract checks if that msg.sender is approved by the owner to take the token, and if so it transfers the token to them.
  function takeOwnership(uint256 _tokenId) public;
}