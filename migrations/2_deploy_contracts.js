var CharacterFactory = artifacts.require("CharacterFactory");
var CharacterHelper = artifacts.require("CharacterHelper");
var CharacterItems = artifacts.require("CharacterItems");

module.exports = function(deployer) {
  deployer.deploy(CharacterFactory);
  deployer.deploy(CharacterHelper);
  deployer.deploy(CharacterItems);
};