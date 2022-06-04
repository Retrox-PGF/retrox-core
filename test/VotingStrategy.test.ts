import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import hre, { ethers, waffle } from "hardhat";
import { Contract, ContractFactory } from "ethers";

describe("Voting Strategy", function () {
  let initiator: SignerWithAddress;
  let holder0: SignerWithAddress;
  let holder1: SignerWithAddress;
  let holder2: SignerWithAddress;
  let retrox2: Contract;
  let quadraticVotingStrategy: Contract;

  beforeEach(async () => {
    [initiator, holder0, holder1, holder2] = await hre.ethers.getSigners();
    const provider = waffle.provider;

    console.log(await provider.getBalance(initiator.address));

    // Deploy retrox contract and QV strategy
    const QuadraticVotingStrategyFactory = await ethers.getContractFactory(
      "QuadraticVotingStrategy"
    );
    const Retrox2Factory = await ethers.getContractFactory("Retrox2");
    quadraticVotingStrategy = await QuadraticVotingStrategyFactory.deploy();
    retrox2 = await Retrox2Factory.deploy();
    console.log(quadraticVotingStrategy.address, retrox2.address);
  });

  it("can create a round, nominate, and vote", async function () {

    await retrox2
      .connect(initiator)
      .createRound(
        "test",
        quadraticVotingStrategy.address,
        [holder0.address, holder1.address, holder2.address],
        1,
        1,
        { value: ethers.utils.parseEther("0.0001") }
      );

      console.log(await retrox2.getNextRoundNum());



  });
});
