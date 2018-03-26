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
        Weapon weaponDrop = _calcWeaponDrop();
        uint newWeaponIndex = char.weapons[0].length;
        char.weapons[0][newWeaponIndex] = weaponDrop;
    }

    function buyArmourCrate(uint characterId) external payable {
        require(msg.value == buyArmourFee);
        /// @dev Creates a new temporary memory struct (char), initialised with the given values, and copies it over to storage.
        Character storage char = characters[characterId];

        char.armour[0] = Armour.Boots;
        char.armour[1] = Armour.Leggings;

    }

    /// @dev Code to test on remix
    function GetWeapons(uint characterId) public returns(Weapon[10]) {
        return characters[characterId].weapons[0];
    }

    function GetArmour(uint characterId) public returns(Armour[10]) {
        return characters[characterId].armour;
    }

    function GetName(uint characterId) public returns(string) {
        return characters[characterId].name;
    }

    function GetCharType(uint characterId) public returns(string) {
        return characters[characterId].charType;
    }

    function GetStrength(uint characterId) public returns(uint16) {
        return characters[characterId].stats[0].wins;
    }

    function GetTotalHealth(uint characterId) public returns(uint16) {
        return characters[characterId].stats[0].totalHealth;
    }
}