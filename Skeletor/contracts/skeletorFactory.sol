pragma solidity ^0.4.18;

import "./zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

/// @title SkeletorFactor
/// @author LD2045
/// @dev This contract will form the base layer (r00t) of an attempt to make a game like World of Warcraft on Etheruem using the ERC721 standard. 
contract SkeletorFactory is Ownable {
    /// @notice Declarations using SafeMath. These datatypes will be able to inherit contract.
    using SafeMath for uint256;
    using SafeMath for uint32;
    using SafeMath for uint16;

    uint coowlDown = 1 days;

    event NewSkeleton(string name,
                    string charType,
                    uint dna);

    struct Skeleton {
        bool engaged;
        string name;
        string charType;
        uint dna;
        uint rdyTime;
        uint32 level;
        uint16 wins;
        uint16 losses;
        uint16 totalHealth;
        uint16 totalMana;
        mapping (string => uint16) weapons;
    }

    /// @notice An array(vector) of Skeletons. 
    Skeleton[] public skeletons;
}