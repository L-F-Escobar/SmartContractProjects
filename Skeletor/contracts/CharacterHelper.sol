pragma solidity ^0.4.18;

import "./CharacterItems.sol";

/// @title CharacterHelper
/// @author LD2045
/// @dev 
contract CharacterHelper is CharacterItems {
    /// @notice Fee structure defaults.
    uint buyWeaponFee = 0.0025 ether;
    uint buyArmourFee = 0.002 ether;

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

    /// @dev The following 2 functions allow the owner to change the default fees.
    function changeWeaponFee(uint _buyWeaponFee) external onlyOwner {
        buyWeaponFee = _buyWeaponFee;
    }

    function changeArmourFee(uint _buyArmourFee) external  onlyOwner {
        buyArmourFee = _buyArmourFee;
    }

    function buyWeaponCrate(uint characterId) external payable {
        require(msg.value == buyWeaponFee);
        /// @dev Creates a new temporary memory struct (char), initialised with the given values, and copies it over to storage.
        Character storage char = characters[characterId];
        Weapon wep = _calcWeaponDrop();
        uint pleaseWork = char.weapons.length();
        char.weapons[pleaseWork] = wep;
    }

    function buyArmourCrate(uint characterId) external payable {
        require(msg.value == buyArmourFee);
        /// @dev Creates a new temporary memory struct (char), initialised with the given values, and copies it over to storage.
        Character storage char = characters[characterId];

        char.armour[0] = Armour.Boots;
        char.armour[1] = Armour.Leggings;

    }
}