pragma experimental ABIEncoderV2;

import "./CharacterHelper.sol";

/// @title BattleTimeLock
/// @author LD2045
/// @dev 
contract BattleTimeLock is CharacterHelper {
    /// @dev Cannot proceed if both characters are not locked in a battle with each other.
    modifier isLocked(uint _battleId) {
        /// @dev Checks to make sure that 2 characters are locked in. ModIndx will only ever be 0 or 1.
        /// @dev If ModIndex is 1, then there is 1 spot within Locked.characterIds array that is open.
        /// @dev If ModIndex is 0, then it is the first execution or the second spot has been filled.
        /// @dev totalBattles > 0 ensures that it is not the first run.
        require(characterIdsModIndex == 0 && totalBattles > 0);
        /// @dev Commented out characterIdTwo to demonstrate how one can use lockedBattles dynamically with characters to ensure that both players are locked in a battle with each other. 
        uint characterIdOne = lockedBattles[_battleId].characterIds[0];
        // uint characterIdTwo = lockedBattles[_battleId].characterIds[1]; // EXAMPLE 
        require(characters[characterIdOne].engaged == true && characters[lockedBattles[_battleId].characterIds[1]].engaged == true);
        _;
    }

    /// @dev Two characters are engaged in battle.
    struct Locked {
        /// @dev This array.length will always equal two even if they are empty.
        uint[2] characterIds;
    }

    /// @dev A mapping of all active locked battles.
    mapping (uint => Locked) lockedBattles;    
    /// @dev Total number of active battles. REMEMBER, a battle takes 2 characters - therefore only increment this value when a battle is loaded with 2 characters.
    uint public activeBattleCount = 0;
    /// @dev Used to load characterIds into struct Locked. Can only be 0 or 1.
    uint characterIdsModIndex = 0;
    uint public totalBattles = 0;

}