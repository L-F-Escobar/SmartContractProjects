pragma solidity ^0.4.18;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;

    // Modifiers execute first as a sort of method require/assert
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function withdraw() external onlyOwner {
        owner.transfer(this.balance);
    }

    // call a function and pay money to the contract at the same time.
    function levelUp(uint _zombieId) external payable {
        // requiring a payment to the contract in order to execute a function.
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
        zombies[_zombieId].dna = _newDna;
    }

    // Example of when it makes sense to build history instead of making a call to 
    // eth which cost a lot more gas.
    function getZombiesByOwner(address _owner) external view returns (uint[]) { 
        uint[] memory result = new uint[](ownerZombieCount[_owner]);

        uint counter = 0;

        for(uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }

        return result;
    }
}
