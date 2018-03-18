pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract SkeletorFactory is ERC721, Ownable {
    // Using SageMath contract for data type - these data types will be able to inherate from contract.
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    uint coowlDown = 1 days;

    event NewSkeleton(bool engaged,
                    string name,
                    string charType,
                    uint dna,
                    uint readyTime,
                    uint16 wins,
                    uint16 losses,
                    uint16 totalHealth,
                    uint16 totalMana,
                    mapping (string => uint16) weapons);

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

    // An array(vector) of Skeletons. 
    Skeleton[] public skeletons;
}