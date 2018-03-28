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

    /// @dev 
    function buyWeaponCrate(uint characterId) external payable {
        require(msg.value == buyWeaponFee);
        require(characters[characterId].weaponCounter <= 7);
        /// @dev Creates a new temporary memory struct (char), initialised with the given values, and copies it over to storage.
        Character storage char = characters[characterId];
        char.weapons[char.weaponCounter] = getWeaponDrop();
        char.weaponCounter = char.weaponCounter.add(1);
    }

    /// @dev Rudementary implementation of a user purchasing armour crate. Rarity is not factored in yet.
    function buyArmourCrate(uint characterId) external payable {
        require(msg.value == buyArmourFee);
        require(characters[characterId].armourCounter <= 12);
        /// @dev Creates a new temporary memory struct (char), initialised with the given values, and copies it over to storage.
        Character storage char = characters[characterId];
        char.armour[char.armourCounter] = getArmourDrop();
        char.armourCounter = char.armourCounter.add(1);
    }

    /// @dev Returns all the characters of a specific address. Characters are returned in the form of their id within the characters arrsy.
    function getCharacterByOwner(address _owner) external view returns (uint[]) {
        /// @notice Memory variables are temporary. 
        /// @dev Cheaper to build history than to make a call to the blockchain.
        uint[] memory result = new uint[](ownerCharacterCount[_owner]);

        /// @dev Functions as the index for result.
        uint counter = 0;

        /// @dev Traverse the length of the characters array, checking every character.
        for(uint i = 0; i < characters.length; i++) {
            if (characterToOwner[i] == _owner) {
                result[counter] = i;
                counter = counter.add(1);
            }
        }

        return result;
    }
}