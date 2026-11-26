import { expect } from "chai";
import { network } from "hardhat";

describe("ClassroomPoll", function () {
  it("creates a poll and records one vote per address", async function () {
    const { ethers } = await network.connect();
    const [creator, voter] = await ethers.getSigners();
    const poll = await ethers.deployContract("ClassroomPoll");

    await poll.createPoll("Which topic should we review?", ["Solidity", "Ethers"], 3600);
    expect(await poll.nextPollId()).to.equal(1n);

    await poll.connect(voter).vote(0, 1);
    const result = await poll.getPoll(0);
    expect(result[0]).to.equal("Which topic should we review?");
    expect(result[2][1]).to.equal(1n);
    expect(await poll.hasVoted(0, voter.address)).to.equal(true);

    await expect(poll.connect(voter).vote(0, 0)).to.be.revertedWith("Already voted");
    await expect(poll.connect(creator).closePoll(0)).not.to.be.revert(ethers);
  });

  it("rejects votes after the creator closes a poll", async function () {
    const { ethers } = await network.connect();
    const [creator, voter] = await ethers.getSigners();
    const poll = await ethers.deployContract("ClassroomPoll");

    await poll.createPoll("Choose a day", ["Monday", "Friday"], 3600);
    await poll.connect(creator).closePoll(0);
    await expect(poll.connect(voter).vote(0, 0)).to.be.revertedWith("Poll is closed");
  });
});
