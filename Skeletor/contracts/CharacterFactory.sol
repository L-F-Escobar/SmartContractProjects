pragma solidity ^0.4.18;

// not needed yet.
//import "./zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./iterable_mapping.sol";


/// @title CharacterFactory
/// @author LD2045
/// @dev This contract will be an attempt to make a game like World of Warcraft on Etheruem using the ERC721 standard. 
/// @notice CharacterFactory is inheriting from Ownable.sol
contract CharacterFactory is Ownable {
    /// @notice Declarations using SafeMath. These datatypes will be able to inherit contract.
    using SafeMath for uint256;
    using SafeMath for uint32;
    using SafeMath for uint16;
    using SafeMath for uint8;

    /// @notice Declarations using iterable_mapping. These datatypes will be able to inherit from contract and allow my mappings to be iterable.
    using IterableMapping for mapping(uint => string);
    using IterableMapping for mapping(address => uint);
    using IterableMapping for mapping (uint => Statistics);
    using IterableMapping for mapping (uint => Weapon);
    using IterableMapping for mapping (uint => Armour);

    /// @dev enums are explicitly convertible to and from all integer types but implicit conversion is not allowed.
    enum Armour {Chest, Helm, Boots, Leggings, Gloves, Shield} // 0,1,2,3,4,5
    enum Weapon {Sword, Axe, Wand, Gun, Hammer, Fist} // 0,1,2,3,4,5

    /// @notice Events.
    event NewCharacter(uint id,
                    string name,
                    string charType,
                    uint dna);

    /// @notice State variables, stored permanently in the blockchain.
    uint internal randNonce = 0;
    uint internal modShortener = 10 ** 16; // can later use the modulus operator % to shorten an integer to 16 digits.

    struct Statistics {
        uint16 wins;
        uint16 losses;
        uint16 totalHealth;
        uint16 totalMana;
        uint16 strength;
        uint16 intelligence;
        uint16 agility;
        uint16 defense;
        uint16 attackPower;
    }

    struct Character {
        bool engaged;
        string name;
        string charType;
        uint dna;
        uint16 level;
        mapping (uint => Statistics) stats;
        mapping (uint => Weapon) weapons;
        mapping (uint => Armour) armour;
    }

    /// @notice An array(vector) of Characters. 
    Character[] public characters;

    /// @notice Dictionaries.
    mapping (uint => address) public characterToOwner;
    mapping (address => uint) ownerCharacterCount;

    /// @dev Assures that only the owner of that character can proceed. 
    modifier onlyOwnerOf(uint _characterId) {
        require(msg.sender == characterToOwner[_characterId]);
        _;
    }

    /// @dev Internal function which creates a new character with default settings. Ownership for the new chracter is assigned to the calling address.
    function _createCharacter(string _name, string _charType, uint _dna) internal {
        /// @dev Will return the id of the character
        uint id = characters.push(Character(false, _name, _charType, _dna, 1)) - 1;

        /// @dev Assign default settings to a character.
        Character storage char = characters[id];
        char.stats[0] = Statistics(0,0,100,50,10,10,10,10,25);
        char.weapons[0] = Weapon.Fist;
        char.armour[0] = Armour.Boots;
        char.armour[1] = Armour.Leggings;

        /// @notice Assigning ownership to the new character.
        characterToOwner[id] = msg.sender;
        /// @notice SafeMath increment the total acount of the owner.
        ownerCharacterCount[msg.sender] = ownerCharacterCount[msg.sender].add(1);
        /// @notice Trigger event.
        NewCharacter(id, _name, _charType, _dna);
    }

    /// @notice internal - like private but can also be called by contracts that inherit from this one.
    /// @dev In light that oracles do not exist, this psuedo-rand function will have to do.
    function _generateRandomness(uint _modulus) internal returns (uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(now, randNonce, msg.sender, uint(1 days))) % _modulus;
    }

    /// @dev If the address triggering this accoutn has 2 characters they will not be able to make another. 
    function createCharacter(string _name, string _charType) public {
        require(ownerCharacterCount[msg.sender] <= 2);
        uint randDna = _generateRandomness(modShortener);
        _createCharacter(_name, _charType, randDna);
    }

    








    /// @notice These functions are for testing on https://remix.ethereum.org.
    function GetCallingAddr() public view returns(address) {
        return msg.sender;
    }

    /// @notice When calling thsi function, passing in the address in quotes "_addr".
    function GetPassedAddr(address _addr) public view returns(address) {
        return _addr;
    }
    
    /// @notice Returns 0x0000000000000000000000000000000000000000 always.
    function GetAddrZero() public view returns(address) {
        return address(0);
    }
}