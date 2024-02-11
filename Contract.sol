// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthChain {
    // Struct to represent a patient's health record
    struct HealthRecord {
        uint256 id;
        string patientName;
        string condition;
        uint256 timestamp;
    }

    // Events
    event RecordAdded(uint256 indexed id, string patientName, string condition, uint256 timestamp);
    event ConditionUpdated(uint256 indexed id, string newCondition, uint256 timestamp);
    event RecordAccessed(uint256 indexed id, address requester, uint256 timestamp);

    // State variables
    mapping(uint256 => HealthRecord) private healthRecords;
    uint256 private recordCounter;
    mapping(uint256 => mapping(address => bool)) private recordAccess;

    // Functions

    // Function to add a new health record
    function addRecord(string memory _patientName, string memory _condition) external {
        recordCounter++;
        healthRecords[recordCounter] = HealthRecord(recordCounter, _patientName, _condition, block.timestamp);
        emit RecordAdded(recordCounter, _patientName, _condition, block.timestamp);
    }

    // Function to update the condition of an existing health record
    function updateCondition(uint256 _id, string memory _newCondition) external {
        require(healthRecords[_id].id != 0, "Record with specified ID does not exist");
        require(msg.sender == ownerOf(_id), "Only the owner can update the condition");
        healthRecords[_id].condition = _newCondition;
        emit ConditionUpdated(_id, _newCondition, block.timestamp);
    }

    // Function to grant access to a health record
    function grantAccess(uint256 _id, address _requester) external {
        require(healthRecords[_id].id != 0, "Record with specified ID does not exist");
        require(msg.sender == ownerOf(_id), "Only the owner can grant access");
        recordAccess[_id][_requester] = true;
        emit RecordAccessed(_id, _requester, block.timestamp);
    }

    // Function to check if a requester has access to a health record
    function hasAccess(uint256 _id, address _requester) external view returns (bool) {
        return recordAccess[_id][_requester];
    }

    // Function to retrieve a health record
    function getRecord(uint256 _id) external view returns (HealthRecord memory) {
        require(healthRecords[_id].id != 0, "Record with specified ID does not exist");
        require(recordAccess[_id][msg.sender], "You don't have access to this record");
        return healthRecords[_id];
    }

    // Function to calculate the owner of a health record
    function ownerOf(uint256) internal pure returns (address) {
        return owner();
    }

    // Function to get the contract owner
    function owner() internal pure returns (address) {
        return address(0x773F29c11ea75518f4a4C779d8166b0fAA3515FB); 
    }

    receive() external payable {}
}