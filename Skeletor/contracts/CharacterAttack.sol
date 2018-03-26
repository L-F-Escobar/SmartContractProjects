pragma solidity ^0.4.18;

import "./CharacterHelper.sol";

/// @title CharacterHelper
/// @author LD2045
/// @dev 
contract BattleTimeLock is CharacterHelper {
    /// @dev Cannot proceed if both characters are not locked in a battle with eac other.
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

    /// @dev A mapping of all locked battles.
    mapping (uint => Locked) lockedBattles;         
}

/// @title CharacterHelper
/// @author LD2045
/// @dev 
contract CharacterAttack is CharacterHelper, BattleTimeLock {

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

}