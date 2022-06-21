import { ethers } from "hardhat";

async function main() {
  const BinaryVotingStrategyFactory = await ethers.getContractFactory(
    "BinaryVotingStrategy"
  );
  const binaryVotingStrategy = await BinaryVotingStrategyFactory.deploy();
  const Retrox2Factory = await ethers.getContractFactory("Retrox2");

  const retrox = await Retrox2Factory.attach(
    "0x4BeE3fB3E00aE07D0bdeA6826e22F8e1BDb4458D"
  );

  await retrox.createRound(
    "ipfs://QmTUtgkpwakpMJWeb1rBfPEYvFKym1DuWq1xgkYkopMTmj",
    "0xbA5FD3A9C902581E7e093d681Eff645E7305E130",
    "0xffffffffffffffffffffffffffffffffffffffff",
    [
      "0xb7CF83796d911eD42592a625B95753A3Cfdd7feE",
      "0x341021d26272F94CecD25C29539266ecDf4bB1b2",
      "0x249070c20d9d200C0515a5B003C9d1833e9F52E5",
      "0x6Da8f9754DECa3E991d853263d4bE8dDF3590430",
      "0x42EfEb62530A7E2c7A2826Ad486dC9A39EE189f7",
    ],
    1,
    10000,
    { value: ethers.utils.parseEther("0.0001") }
  );

  await retrox.nominate(
    0,
    "ipfs://QmUPVuHRKPGbtGxhpPfuMaFGzMBSWXy6f4PzLPURfZLmnJ",
    "0xf0d9A38494b40b72dcd7A5CA109fd59d80b88337",
    {
      value: ethers.utils.parseEther("0.0001"),
    }
  );
  await retrox.nominate(
    0,
    "ipfs://QmXWtKWSoXrCfgGuQLqYmnmAdQyD2Z7L5gDa7CGWgAQ6DM",
    "0x249070c20d9d200C0515a5B003C9d1833e9F52E5",
    {
      value: ethers.utils.parseEther("0.0001"),
    }
  );
  await retrox.nominate(
    0,
    "ipfs://QmSicyuEgVH1tSEn9FvLrZvruj2Si97Gtx7RwkT14dSKuK",
    "0x6Da8f9754DECa3E991d853263d4bE8dDF3590430",
    {
      value: ethers.utils.parseEther("0.0001"),
    }
  );

  // const retrox2 = await Retrox2Factory.deploy();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
