pragma solidity ^0.4.18;

// not needed yet.
//import "./zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";


/// @title SkeletorFactor
/// @author LD2045
/// @dev This contract will be an attempt to make a game like World of Warcraft on Etheruem using the ERC721 standard. 
contract CharacterFactory is Ownable {
    /// @notice Declarations using SafeMath. These datatypes will be able to inherit contract.
    using SafeMath for uint256;
    using SafeMath for uint32;
    using SafeMath for uint16;

    /// @notice Events.
    event NewCharacter(string name,
                    string charType,
                    uint dna);

    /// @notice State variables, stored permanently in the blockchain.
    /// @dev enums are explicitly convertible to and from all integer types but implicit conversion is not allowed.
    enum ArmourTypes {Chest, Helm, Boots, Leggings, Gloves, Shield}
    enum WeaponTypes {Sword, Axe, Wand, Gun, Hammer, Fist}
    ArmourTypes armour;
    WeaponTypes weapon;
    uint coowlDown = (1 days) / 4;
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // equal to 10^dnaDigits
    uint cooldownTime = 7 days;

    struct Character {
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
        mapping (uint16 => mapping (string => uint16)) weapons;
        mapping (uint16 => mapping (string => uint16)) armours;
    }

    /// @notice An array(vector) of Characters. 
    Character[] public characters;

    mapping (uint => address) public characterToOwner;
    mapping (address => uint) ownerCharacterCount;
}