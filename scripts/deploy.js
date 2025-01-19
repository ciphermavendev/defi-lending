const hre = require("hardhat");

async function main() {
  // Deploy Test Token
  const TestToken = await hre.ethers.getContractFactory("TestToken");
  const testToken = await TestToken.deploy();
  await testToken.waitForDeployment();
  console.log(`Test Token deployed to: ${await testToken.getAddress()}`);

  // Deploy Lending Protocol
  const LendingProtocol = await hre.ethers.getContractFactory("LendingProtocol");
  const lendingProtocol = await LendingProtocol.deploy();
  await lendingProtocol.waitForDeployment();
  console.log(`Lending Protocol deployed to: ${await lendingProtocol.getAddress()}`);

  // Add test token as supported token with 75% collateral factor
  await lendingProtocol.addSupportedToken(await testToken.getAddress(), 7500);
  console.log("Test token added as supported token");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});