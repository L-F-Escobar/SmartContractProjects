pragma solidity ^0.4.18;

import "./CharacterItems.sol";

/// @title CharacterHelper
/// @author LD2045
/// @dev 
contract CharacterHelper is CharacterItems {
    /// @notice Fee structure defaults.
    uint levelUpFee = 0.001 ether;
    uint buyWeaponFee = 0.0025 ether;
    uint buyArmourFee = 0.002 ether;

    /// @dev Allows us to set a level threshold and test the characters level against it.
    modifier _aboveLevel(uint16 _requiredLvl, uint _characterId) {
        require(uint16(characters[_characterId].level) >= _requiredLvl);
        _;
    } 

    /// @dev Ensures that nothing can proceed unless a character is equal or above a determined level.
    modifier aboveLevel(uint8 _level, uint _characterId) {
        require(characters[_characterId].level >= _level);
        _;
    }

    /// @dev Only the owner of the contract can call this function.
    function withdraw() external onlyOwner {
        owner.transfer(this.balance);
    }

    /// @dev Levels up a character using SafeMath
    function _levelUp(uint _characterId) internal {
        characters[_characterId].level = uint16(characters[_characterId].level.add(1));
    }

    /// @dev The following 3 functions allow the owner to chance the default fees.
    function changeLevelFee(uint _levelUpFee) external onlyOwner {
        levelUpFee = _levelUpFee;
    }

    function changeWeaponFee(uint _buyWeaponFee) external  onlyOwner {
        buyWeaponFee = _buyWeaponFee;
    }

    function changeArmourFee(uint _buyArmourFee) external  onlyOwner {
        buyArmourFee = _buyArmourFee;
    }
}