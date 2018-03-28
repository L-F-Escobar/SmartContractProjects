// pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;

import "./CharacterHelper.sol";

/// @title BattleTimeLock
/// @author LD2045
/// @dev 
contract BattleTimeLock is CharacterHelper {
    /// @dev Cannot proceed if both characters are not locked in a battle with each other.
    modifier isLocked(uint _battleId) {
        /// @dev Checks to make sure that 2 characters are locked in. ModIndx will only ever be 0 or 1.
        /// @dev If ModIndex is 1, then there is 1 spot open within Locked.characterIds array that is open.
        /// @dev If ModIndex os 0, then it is the first execution or the second spot has been filled.
        /// @dev activeBattleCount > 0 ensures that it is not the first run.
        require(characterIdsModIndex == 0 && activeBattleCount > 0);
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

}

/// @title CharacterAttack
/// @author LD2045
/// @dev 
contract CharacterAttack is BattleTimeLock {

    /// @notice Events.
    event NewBattle(uint _charactersIdOne,
                    uint _charactersIdTwo,
                    uint time);

    modifier notEngaged(uint _charactersId) {
        require(characters[_charactersId].engaged == false);
        _;
    }

    modifier isEngaged(uint _charactersId) {
        require(characters[_charactersId].engaged == true);
        _;
    }

    /// @dev This function prevents the same character fighting itself. Also locks in the character into battle - either to awaite another opponent or to begin the battle.
    function _enterBattleLock(uint _characterid) public onlyOwnerOf(_characterid) notEngaged(_characterid) {
        /// @dev Character becomes engaged. Character can no longer join another battle until resolution. 
        characters[_characterid].engaged = true;

        /// @dev Lock that character into lockedBattles. characterIdsModIndex % 2 can only settle on 0 or 1.  
        lockedBattles[activeBattleCount].characterIds[characterIdsModIndex%2] = _characterid;

        /// @dev characterIdsModIndex only ever had a range in the program of 0-1. 
        if (characterIdsModIndex == 1) {
            /// @dev Resetting the mod index to 0 meaning that 2 players have been locked in battle.
            characterIdsModIndex = characterIdsModIndex.sub(1);
            /// @dev A battle is loaded with 2 players.
            activeBattleCount = activeBattleCount.add(1);
        } else {
            /// @dev First player has been locked - waiting for a second.
            characterIdsModIndex = characterIdsModIndex.add(1);
        }
    }

    /// @dev Code to test on remix
    function ReturnLockedBattles(uint index, uint charIndex) public returns(uint) {
        return lockedBattles[index].characterIds[charIndex];
    }

    function GetCharacterModIndex() public returns(uint) {
        return characterIdsModIndex;
    }

    function GetActiveBattleCount() public returns(uint) {
        return activeBattleCount;
    }

    function GetIsEngaged(uint characterId) public returns(bool) {
        return characters[characterId].engaged;
    }


    function getWeaponAt(uint characterId, uint arr) public returns(Weapon) {
        require(characters[characterId].weaponCounter > arr);
        return characters[characterId].weapons[arr].weapon;
    }

    function getTotalWeapons(uint characterId) public returns(uint) {
        return characters[characterId].weaponCounter;
    }

    function getArmourAt(uint characterId, uint arr) public returns(Armour) {
        require(characters[characterId].armourCounter > arr);
        return characters[characterId].armour[arr].armour;
    }

    function getTotalArmour(uint characterId) public returns(uint) {
        return characters[characterId].armourCounter;
    }

    // /// @notice Will always be two in current form.
    // function getLockedArrCount() public returns(uint) {
    //     return lockedBattles[activeBattleCount-1].characterIds.length;
    // }

}