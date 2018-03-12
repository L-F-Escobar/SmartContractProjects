//1. Enter solidity version here
pragma solidity ^0.4.18;

import "./ownable.sol";
import "./safemath.sol";

//2. Create contract here
contract ZombieFactory is Ownable {
    // declaration.
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    // declare the event
    event NewZombie(uint zombieId, string name, uint dna);

    // State variables are permanently stored in contract storage. 
    // This will be stored permanently in the blockchain
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // equal to 10^dnaDigits
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime; //Cooldown period before feeding/attacking.
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;


    // It's convention (but not required) to start function parameter 
    // variable names with an underscore (_) in order to differentiate 
    // them from global variables.
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        // Get ownership if zombie and inc total zombies owned.
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        NewZombie(id, _name, _dna);
    }


    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);// make sure they are the owner
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}