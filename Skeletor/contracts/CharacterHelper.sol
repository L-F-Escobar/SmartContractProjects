pragma solidity ^0.4.18;

import "./CharacterItems.sol";

contract CharacterHelper is CharacterItems {

    uint levelUpFee = 0.001 ether;
    uint buyWeaponFee = 0.0025 ether;
    uint buyArmourFee = 0.002 ether;

    /// @dev Allows us to set a level threshold and test the characters level against it.
    modifier _aboveLevel(uint16 _requiredLvl, uint _characterId) {
        require(uint16(characters[_characterId].level) >= _requiredLvl);
        _;
    } 

    function _levelUp(uint _characterId) internal {
        characters[_characterId].level = uint16(characters[_characterId].level.add(1));
    }
}