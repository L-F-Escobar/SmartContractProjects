pragma solidity ^0.4.18;

import "./CharacterHelper.sol";

/// @title BattleTimeLock
/// @author LD2045
/// @dev 
contract BattleTimeLock is CharacterHelper {
    /// @dev Cannot proceed if both characters are not locked in a battle with each other.
    //modifier isLocked(uint _charactersIdOne, uint _charactersIdTwo) {
        //require(characters[_charactersIdOne].engaged == true && characters[_charactersIdTwo].engaged == true);
        //_;
    //}
    modifier isLocked(uint _battleId) {
        /// @dev Commented out characterIdTwo to demonstrate how one can use lockedBattles dynamically with characters to ensure that both players are locked in a battle with each other. 
        uint characterIdOne = lockedBattles[_battleId].characterIds[0];
        // uint characterIdTwo = lockedBattles[_battleId].characterIds[1]; // EXAMPLE 
        require(characters[characterIdOne].engaged == true && characters[lockedBattles[_battleId].characterIds[1]].engaged == true);
        _;
    }

    /// @dev Two characters are engaged in battle.
    struct Locked {
        uint[2] characterIds;
    }

    /// @dev A mapping of all active locked battles.
    mapping (uint => Locked) lockedBattles;    
    /// @dev Total number of active battles. REMEMBER, a battle takes 2 characters - therefore only increment this value when a battle is loaded with 2 characters.
    uint public activeBattleCount;

}

/// @title CharacterAttack
/// @author LD2045
/// @dev 
contract CharacterAttack is BattleTimeLock {

    struct BattleStatistics { uint opponent;
                        uint startTime;
                        uint endTime;
                        uint8 damageDone;
                        uint8 damageTaken;
    }

    /// @notice Events.
    event NewBattle(uint _charactersIdOne,
                    uint _charactersIdTwo,
                    uint time);

    BattleTimeLock battleTimeLock;
    /// @dev Key is the characterId, value are the battle stats.
    mapping (uint => BattleStatistics) public battleStats;

    modifier notEngaged(uint _charactersId) {
        require(characters[_charactersId].engaged == false);
        _;
    }

    modifier isEngaged(uint _charactersId) {
        require(characters[_charactersId].engaged == true);
        _;
    }

    function enterBattle(uint _characterid) public onlyOwnerOf(_characterid) notEngaged(_characterid) {
        /// @dev Character becomes engaged. Character can no longer join another battle until resolution. 
        characters[_characterid].engaged = true;

        /// @dev Size is a binary int; either 0 or 1. Its sole purpose is to allow characters to be locked in battle within Locked structs array of size 2.
        uint size = lockedBattles[activeBattleCount].characterIds.length;

        /// @dev Switch statements are not currently supported by solidity.
        /// @notice http://solidity.readthedocs.io/en/v0.4.21/control-structures.html
        if(size == 0 || size == 1) {
            lockedBattles[activeBattleCount].characterIds[size] = _characterid;
            size = size.add(1);
        } else if(size == 1) { // 
            lockedBattles[activeBattleCount].characterIds[size] = _characterid;
            size = 0;
        } else {

        }

    }

}