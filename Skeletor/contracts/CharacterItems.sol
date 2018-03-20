pragma solidity ^0.4.18;

import "./CharacterFactory.sol";

contract CharacterItems is CharacterFactory {
    /// @dev enums are explicitly convertible to and from all integer types but implicit conversion is not allowed.
    enum ArmourTypes {Chest, Helm, Boots, Leggings, Gloves, Shield}
    enum WeaponTypes {Sword, Axe, Wand, Gun, Hammer, Fist}
    enum CharType {Orc, Elf, Human, Dwarve}
    /// @notice <Left to right> <Common to rare>
    enum RareColor {Grey, Blue, DarkBlue, Purple} 
    ArmourTypes armour;
    WeaponTypes weapon;
    CharType charPick;
    RareColor colorTracker;
}