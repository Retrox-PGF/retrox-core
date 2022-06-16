// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

// Binary voting: 0x550DA3378aFeB3a62d90CAd4c882Da2536964C27
import { ethers } from "hardhat";

async function main() {
//   const BinaryVotingStrategyFactory = await ethers.getContractFactory(
//     "BinaryVotingStrategy"
//   );
//   const binaryVotingStrategy = await BinaryVotingStrategyFactory.deploy();
  const Retrox2Factory = await ethers.getContractFactory("Retrox2");
  const retrox2 = await Retrox2Factory.deploy();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
