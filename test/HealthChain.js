// test/HealthChain.test.js
const { expect } = require("chai");

describe("HealthChain", function () {
  let HealthChain;
  let healthChain;
  let owner;
  let requester;

  beforeEach(async function () {
    HealthChain = await ethers.getContractFactory("HealthChain");
    [owner, requester] = await ethers.getSigners(); // Assign the first two signers as owner and requester
    healthChain = await HealthChain.deploy();
  });

  it("Should add a new health record", async function () {
    await healthChain.addRecord("Alice","Brown","Headache");
    const record = await healthChain.getRecord(1); // Retrieve the added record
    expect(record.patientName).to.equal("Alice");
    expect(record.patientSurname).to.equal("Brown");
    expect(record.condition).to.equal("Headache");
  });

  it("Should update the condition of an existing health record", async function () {
    await healthChain.addRecord("Alice","Brown","Headache");
    await healthChain.updateCondition(1, "Fever");
    const record = await healthChain.getRecord(1); // Retrieve the updated record
    expect(record.condition).to.equal("Fever");
  });

  it("Should grant access to a health record", async function () {
    await healthChain.addRecord("Alice","Brown","Headache");
    await healthChain.grantAccess(1, requester.address); // Grant access to the requester
    const record = await healthChain.connect(requester).getRecord(1); // Retrieve the record by the requester
    expect(record.patientName).to.equal("Alice");
    expect(record.patientSurname).to.equal("Brown");
    expect(record.condition).to.equal("Headache");
  });

  it("Should revert if accessing record without permission", async function () {
    await healthChain.addRecord("Alice","Brown","Headache");
    await expect(
      healthChain.connect(requester).getRecord(1) // Try to retrieve without permission
    ).to.be.revertedWith("You don't have access to this record");
  });
});