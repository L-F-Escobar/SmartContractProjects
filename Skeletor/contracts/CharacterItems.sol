pragma solidity ^0.4.18;

import "./CharacterFactory.sol";

contract CharacterItems is CharacterFactory {
    /// @dev enums are explicitly convertible to and from all integer types but implicit conversion is not allowed.
    enum Armour {Chest, Helm, Boots, Leggings, Gloves, Shield}
    enum Weapons {Sword, Axe, Wand, Gun, Hammer, Fist}
    enum CharType {Orc, Elf, Human, Dwarve}
    /// @notice <Left to right> <Common to rare>
    enum RareColor {Grey, Blue, DarkBlue, Purple} 
    Armour armourItem;
    Weapons weaponItem;
    CharType characterType;
    RareColor itemRarity;
}