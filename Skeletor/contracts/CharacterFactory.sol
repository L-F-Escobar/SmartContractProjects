pragma solidity ^0.4.18;

// not needed yet.
//import "./zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";
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

    /// @notice Events.
    event NewCharacter(uint id,
                    string name,
                    string charType,
                    uint dna);

    /// @notice State variables, stored permanently in the blockchain.
    uint randNonce = 0;
    uint coowlDown = (1 days) / 4;
    uint digits = 16;
    uint modShortener = 10 ** digits; // can later use the modulus operator % to shorten an integer to 16 digits.
    uint cooldownTime = 7 days;

    struct Character {
        bool engaged;
        string name;
        string charType;
        uint dna;
        uint rdyTime;
        uint16 level;
        uint16 wins;
        uint16 losses;
        uint16 totalHealth;
        uint16 totalMana;
        uint16 strength;
        uint16 intelligence;
        uint16 agility;
        uint16 defense;
        uint16 attackPower;
        mapping (int16 => mapping (int16 => string)) weapons;
        mapping (int16 => string) armours;
    }

    /// @notice An array(vector) of Characters. 
    Character[] public characters;

    mapping (uint => address) public characterToOwner;
    mapping (address => uint) ownerCharacterCount;

    /// @dev Assures that only the owner of that character can proceed. 
    modifier onlyOwnerOf(uint _characterId) {
        require(msg.sender == characterToOwner[_characterId]);
        _;
    }

    function _createCharacter(string _name, string _charType, uint _dna) internal {
        uint rdy = (1 days) / 4;
        uint id = characters.push(Character(false, _name, _charType, _dna, rdy, 1, 0, 0, 100, 50, 10, 10, 10, 10, 25)) - 1;

        // Assign the character to the address.
        characterToOwner[id] = msg.sender;
        // Inc that addresses total character count.
        ownerCharacterCount[msg.sender] = ownerCharacterCount[msg.sender].add(1);

        ///////http://solidity.readthedocs.io/en/v0.4.21/types.html#mappings
        /// @dev Creates a new temporary memory struct, inits with the given character & copies it over to storage.
        Character storage char = characters[id];
        /// @notice Copies it to storage here.
        char.weapons[0][0] = "Fist";
        char.armours[0] = "Fist";

        // Trigger event.
        NewCharacter(id, _name, _charType, _dna);
    }

    /// @notice internal - like private but can also be called by contracts that inherit from this one.
    /// @dev In light that oracles do not exist, this psuedo-rand function will have to do.
    function _generateRandomness(uint _modulus) internal returns (uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(now, randNonce, msg.sender, uint(1 days))) % _modulus;
    }


    function createCharacter(string _name, string _charType) public {
        /// @notice Make sure the owner has at most 3 characters.
        require(ownerCharacterCount[msg.sender] <= 3);
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