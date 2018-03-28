pragma solidity ^0.4.18;

import "./CharacterFactory.sol";

/// @title CharacterItems
/// @author LD2045
/// @dev This contract introduces drop mechanics. Drops & their rarity are calculated and returned with the internal functions below.
/// @notice Every internal function returns its drop/rarity.
contract CharacterItems is CharacterFactory {

    /// @dev Returns the rarity of the weapon dropped. 
    function _calcWeaponRarity() internal returns(Rarity) {
        uint8 rarityNumber = uint8(_generateRandomness(100));
        if (rarityNumber == 0) { // 1% chance.
            return Rarity.Orange;
        } else if (rarityNumber > 0 && rarityNumber <= 5) { // 5% chance.
            return Rarity.Purple; 
        } else if (rarityNumber > 5 && rarityNumber <= 15) { // 10% chance.
            return Rarity.DarkBlue; 
        } else if (rarityNumber > 15 && rarityNumber <= 49) { // 34% chance.
            return Rarity.LightBlue; 
        } else {    // 50% chance.
            return Rarity.White;
        }
    }

    /// @dev Returns the weapon type that is dropped.
    function _calcWeaponDrop() internal returns(Weapon) {
        uint8 weaponNumber = uint8(_generateRandomness(100));
        if (weaponNumber <= 15) { // 16% chance.
            return Weapon.Sword;
        } else if (weaponNumber > 15 && weaponNumber <= 30) { // 15% chance.
            return Weapon.Axe;
        } else if (weaponNumber > 30 && weaponNumber <= 45) { // 15% chance.
            return Weapon.Wand;
        } else if (weaponNumber > 45 && weaponNumber <= 60) { // 15% chance.
            return Weapon.Gun;
        } else if (weaponNumber > 60 && weaponNumber <= 75) { // 15% chance.
            return Weapon.Hammer;
        } else { // 24% chance.
            return Weapon.Fist;
        }
    }

    /// @dev Returns the armour type that is dropped.
    function _calcArmourDrop() internal returns(Armour) {
        uint8 armourNumber = uint8(_generateRandomness(100));
        if (armourNumber < 15) { // 16% chance.
            return Armour.Chest;
        } else if (armourNumber > 15 && armourNumber <= 30) { // 15% chance.
            return Armour.Helm;
        } else if (armourNumber > 30 && armourNumber <= 45) { // 15% chance.
            return Armour.Boots;
        } else if (armourNumber > 45 && armourNumber <= 60) { // 15% chance.
            return Armour.Leggings;
        } else if (armourNumber > 60 && armourNumber <= 75) { // 15% chance.
            return Armour.Gloves;
        } else { // 24% chance.
            return Armour.Shield;
        }
    }

    /// @dev Basic function to get a weapon. Must can be done to introduce stat probabilities.
    function getWeaponDrop() internal returns(WeaponStats) {
        Weapon weaponDrop = _calcWeaponDrop();
        Rarity weaponRarity = _calcWeaponRarity();
        return (WeaponStats(weaponRarity, weaponDrop, 10));
    }

    /// @dev Basic function to get a piece of armour. Must can be done to introduce stat probabilities.
    function getArmourDrop() internal returns(ArmourStats) {
        Armour armourDrop = _calcArmourDrop();
        Rarity armourRarity = _calcWeaponRarity();
        return (ArmourStats(armourRarity, armourDrop, 10));
    }
}