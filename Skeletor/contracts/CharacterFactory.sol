pragma solidity ^0.4.18;

// not needed yet.
//import "./zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";


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

    /// @notice Events.
    event NewCharacter(uint id,
                    string name,
                    CharType charType,
                    uint dna);

    /// @notice State variables, stored permanently in the blockchain.
    /// @dev enums are explicitly convertible to and from all integer types but implicit conversion is not allowed.
    enum ArmourTypes {Chest, Helm, Boots, Leggings, Gloves, Shield}
    enum WeaponTypes {Sword, Axe, Wand, Gun, Hammer, Fist}
    enum CharType {Orc, Elf, Human, Dwarve}
    /// @notice <Left to right> <Common to rare>
    enum RareColor {Grey, Blue, DarkBlue, Purple} 
    ArmourTypes armour;
    WeaponTypes weapon;
    CharType charPick;
    RareColor colorTracker;
    uint randNonce = 0;
    uint coowlDown = (1 days) / 4;
    uint digits = 16;
    uint modShortener = 10 ** digits; // can later use the modulus operator % to shorten an integer to 16 digits.
    uint cooldownTime = 7 days;

    struct Character {
        bool engaged;
        string name;
        CharType charType;
        uint dna;
        uint rdyTime;
        uint16 level;
        uint16 wins;
        uint16 losses;
        uint16 totalHealth;
        uint16 totalMana;
        mapping (int16 => string) weapons;
        mapping (int16 => string) armours;
    }

    /// @notice An array(vector) of Characters. 
    Character[] public characters;

    mapping (uint => address) public characterToOwner;
    mapping (address => uint) ownerCharacterCount;

    /// @dev Assures that only the owner of that character can proceed. 
    modifier onlyOwnerOf(uint _zombieId) {
        require(msg.sender == characterToOwner[_zombieId]);
        _;
    }

    function _createCharacter(string _name, CharType _charType, uint _dna) internal {
        uint rdy = (1 days) / 4;
        uint id = characters.push(Character(false, _name, _charType, _dna, rdy, 1, 0, 0, 100, 50)) - 1;

        // Assign the character to the address.
        characterToOwner[id] = msg.sender;
        // Inc that addresses total character count.
        ownerCharacterCount[msg.sender] = ownerCharacterCount[msg.sender].add(1);
        // Trigger event.
        NewCharacter(id, _name, _charType, _dna);
    }

    /// @notice internal - like private but can also be called by contracts that inherit from this one.
    /// @dev In light that oracles do not exist, this psuedo-rand function will have to do.
    function _generateRandomness(string _name, CharType _charType) internal returns (uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(now, _name, _charType, randNonce, msg.sender)) % modShortener;
    }


    function createCharacter(string _name, CharType _charType) public {
        /// @notice Make sure the owner has at most 3 characters.
        require(ownerCharacterCount[msg.sender] <= 3);
        uint randDna = _generateRandomness(_name, _charType);
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