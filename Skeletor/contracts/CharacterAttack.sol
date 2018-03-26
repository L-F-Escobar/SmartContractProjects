pragma solidity ^0.4.18;

import "./CharacterHelper.sol";

/// @title CharacterHelper
/// @author LD2045
/// @dev 
contract BattleTimeLock is CharacterHelper {
    modifier notEngaged(uint _charactersId) {
        // require(_charactersIdOne != _charactersIdTwo);
        _;
    }        
}

/// @title CharacterHelper
/// @author LD2045
/// @dev 
contract CharacterAttack is CharacterHelper {

    struct BattleStatistics { uint16 opponent;
                        uint16 damageDone;
                        uint16 damageTaken;
                        uint16 time;
    }

    /// @notice Events.
    event NewBattle(uint _charactersIdOne,
                    uint _charactersIdTwo,
                    uint time);

    BattleTimeLock battleTimeLock;
    mapping (address => BattleStatistics[]) public battleStats;

    modifier notEngaged(uint _charactersId) {
        require(characters[_charactersId].engaged == false);
        _;
    }

    modifier isEngaged(uint _charactersId) {
        require(characters[_charactersId].engaged == true);
        _;
    }

}