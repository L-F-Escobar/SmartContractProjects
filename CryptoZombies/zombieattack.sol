pragma solidity ^0.4.18;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    // insecure randNumGen. Need oracles instead.
    function randMod(uint _modulus) internal returns (uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        // check to see if the person calling this function is the owner of the _zombieId
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);

        // Victory
        if (rand <= attackVictoryProbability) {
            // safemath.
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {// Defeat
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
        
    }

}



// // Generate a random number between 1 and 100:
// uint randNonce = 0;
// uint random = uint(keccak256(now, msg.sender, randNonce)) % 100;
// randNonce++;
// uint random2 = uint(keccak256(now, msg.sender, randNonce)) % 100;

// It would then use keccak to convert these inputs to a random hash, convert that hash to a uint, and then use % 100 to take only the last 2 digits, giving us a totally random number between 0 and 99.