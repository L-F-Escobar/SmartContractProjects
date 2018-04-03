var CharacterFactory = artifacts.require("CharacterFactory");
var CharacterItems = artifacts.require("CharacterItems");
var CharacterHelper = artifacts.require("CharacterHelper");
var BattleTimeLock = artifacts.require("BattleTimeLock");
var CharacterBattle = artifacts.require("./CharacterBattle");
var SkeletorOwnership = artifacts.require("./SkeletorOwnership");


module.exports = function(deployer) {
  deployer.deploy(CharacterFactory);
  deployer.deploy(CharacterItems);
  deployer.deploy(CharacterHelper);
  deployer.deploy(BattleTimeLock);
  deployer.deploy(CharacterBattle);
  deployer.deploy(SkeletorOwnership);
};