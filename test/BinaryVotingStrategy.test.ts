import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import hre, { ethers, waffle } from "hardhat";
import { Contract, ContractFactory } from "ethers";

describe("Binary Voting Strategy", function () {
  let initiator: SignerWithAddress;
  let holder0: SignerWithAddress;
  let holder1: SignerWithAddress;
  let holder2: SignerWithAddress;
  let recipient1: SignerWithAddress;
  let recipient2: SignerWithAddress;
  let retrox2: Contract;
  let binaryVotingStrategy: Contract;
  let retroactiveDispersalStrategy: Contract;

  beforeEach(async () => {
    [initiator, holder0, holder1, holder2, recipient1, recipient2] =
      await hre.ethers.getSigners();
    const provider = waffle.provider;

    console.log(await provider.getBalance(initiator.address));

    const BinaryVotingStrategyFactory = await ethers.getContractFactory(
      "BinaryVotingStrategy"
    );
    binaryVotingStrategy = await BinaryVotingStrategyFactory.deploy();
    const RetroactiveDispersalStrategyFactory = await ethers.getContractFactory(
      "RetroactiveDispersalStrategy"
    );
    retroactiveDispersalStrategy =
      await RetroactiveDispersalStrategyFactory.deploy();
    const Retrox2Factory = await ethers.getContractFactory("Retrox2");
    retrox2 = await Retrox2Factory.deploy();
  });

  it("can create a round, nominate, and vote", async function () {
    const badgeHolders = [holder0.address, holder1.address, holder2.address];
    await retrox2
      .connect(initiator)
      .createRound(
        "test round",
        binaryVotingStrategy.address,
        retroactiveDispersalStrategy.address,
        badgeHolders,
        1,
        1,
        { value: ethers.utils.parseEther("0.0001") }
      );
    let roundData = await retrox2.getRoundData(0);
    console.log(roundData);
    expect(roundData.roundURI).to.equal("test round");
    expect(roundData.badgeHolders).to.deep.equal(badgeHolders);
    expect(roundData.fundsCommitted).to.deep.equal(
      ethers.utils.parseEther("0.0001")
    );
    expect(roundData.nominationCounter).to.deep.equal(0);
    expect(roundData.totalVotes).to.deep.equal(0);
    expect(roundData.votingStrategy).to.deep.equal(
      binaryVotingStrategy.address
    );

    await retrox2.connect(initiator).nominate(0, "nom1", recipient1.address, {
      value: ethers.utils.parseEther("0.0001"),
    });
    await retrox2.connect(initiator).nominate(0, "nom2", recipient2.address, {
      value: ethers.utils.parseEther("0.0001"),
    });
    roundData = await retrox2.getRoundData(0);
    expect(roundData.nominationCounter).to.deep.equal(2);
    expect(roundData.fundsCommitted).to.deep.equal(
      ethers.utils.parseEther("0.0003")
    );

    await retrox2.connect(holder0).castVotes(0, [1, 1]);
    await retrox2.connect(holder1).castVotes(0, [1, 0]);
    roundData = await retrox2.getRoundData(0);
    expect(roundData.totalVotes).to.deep.equal(4);
    const nomination0Data = await retrox2.getNominationData(0, 0);
    let nomination1Data = await retrox2.getNominationData(0, 1);
    expect(nomination0Data.numVotes).to.deep.equal(2);
    expect(nomination1Data.numVotes).to.deep.equal(2);

    // Changing vote
    await retrox2.connect(holder0).castVotes(0, [0, 2]);
    nomination1Data = await retrox2.getNominationData(0, 1);
    expect(nomination1Data.numVotes).to.deep.equal(1);

    // await retrox2.connect(initiator).disperseFunds(0);
  });
});
