// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract HealthRecords is Initializable, AccessControlUpgradeable, PausableUpgradeable, ReentrancyGuardUpgradeable {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant HOSPITAL_ROLE = keccak256("HOSPITAL_ROLE");
    bytes32 public constant PATIENT_ROLE = keccak256("PATIENT_ROLE");

    struct Hospital {
        string name;
        bool isActive;
        uint256 registrationDate;
    }

    struct Patient {
        string name;
        uint256 dateOfBirth;
        bool exists;
        string[] allergies;
        address emergencyContact;
    }

    struct MedicalRecord {
        string data;
        string dataType;
        uint256 timestamp;
        address uploadedBy;
    }

    mapping(address => Hospital) public hospitals;
    mapping(address => Patient) public patients;
    mapping(address => mapping(uint256 => MedicalRecord)) private patientRecords;
    mapping(address => uint256) private patientRecordCount;
    mapping(address => mapping(address => bool)) private patientConsent;
    mapping(address => uint256) private emergencyAccessExpiration;

    uint256 public constant EMERGENCY_ACCESS_DURATION = 24 hours;

    event HospitalRegistered(address indexed hospitalAddress, string name);
    event PatientRegistered(address indexed patientAddress, string name);
    event RecordUploaded(address indexed patient, uint256 indexed recordId, string dataType);
    event ConsentGranted(address indexed patient, address indexed hospital);
    event ConsentRevoked(address indexed patient, address indexed hospital);
    event EmergencyAccessGranted(address indexed patient, address indexed hospital, uint256 expirationTime);
    event InteroperableDataImported(address indexed patient, string dataStandard);
    event ContractUpgraded(address newImplementation);

    function initialize(address initialAdmin) public initializer {
        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();

        _grantRole(DEFAULT_ADMIN_ROLE, initialAdmin);
        _grantRole(ADMIN_ROLE, initialAdmin);
    }

    function registerHospital(address _hospitalAddress, string memory _name) public onlyRole(ADMIN_ROLE) {
        require(!hospitals[_hospitalAddress].isActive, "Hospital already registered");
        hospitals[_hospitalAddress] = Hospital(_name, true, block.timestamp);
        _grantRole(HOSPITAL_ROLE, _hospitalAddress);
        emit HospitalRegistered(_hospitalAddress, _name);
    }

    function registerPatient(string memory _name, uint256 _dateOfBirth, string[] memory _allergies, address _emergencyContact) public {
        require(!patients[msg.sender].exists, "Patient already registered");
        patients[msg.sender] = Patient(_name, _dateOfBirth, true, _allergies, _emergencyContact);
        _grantRole(PATIENT_ROLE, msg.sender);
        emit PatientRegistered(msg.sender, _name);
    }

    function uploadRecord(address _patientAddress, string memory _data, string memory _dataType) public onlyRole(HOSPITAL_ROLE) whenNotPaused nonReentrant {
        require(patients[_patientAddress].exists, "Patient does not exist");
        require(patientConsent[_patientAddress][msg.sender] || isEmergencyAccess(msg.sender), "No consent given");
        
        uint256 recordId = patientRecordCount[_patientAddress];
        patientRecords[_patientAddress][recordId] = MedicalRecord(_data, _dataType, block.timestamp, msg.sender);
        patientRecordCount[_patientAddress]++;

        emit RecordUploaded(_patientAddress, recordId, _dataType);
    }

    function getRecord(address _patientAddress, uint256 _recordId) public view returns (string memory, string memory, uint256, address) {
        require(hasRole(HOSPITAL_ROLE, msg.sender) || msg.sender == _patientAddress, "Not authorized");
        require(patientConsent[_patientAddress][msg.sender] || msg.sender == _patientAddress || isEmergencyAccess(msg.sender), "No consent given");
        require(_recordId < patientRecordCount[_patientAddress], "Record does not exist");

        MedicalRecord memory record = patientRecords[_patientAddress][_recordId];
        return (record.data, record.dataType, record.timestamp, record.uploadedBy);
    }

    function getPatientRecordCount(address _patientAddress) public view returns (uint256) {
        require(hasRole(HOSPITAL_ROLE, msg.sender) || msg.sender == _patientAddress, "Not authorized");
        return patientRecordCount[_patientAddress];
    }

    function grantConsent(address _hospitalAddress) public onlyRole(PATIENT_ROLE) whenNotPaused {
        require(hospitals[_hospitalAddress].isActive, "Hospital is not active");
        patientConsent[msg.sender][_hospitalAddress] = true;
        emit ConsentGranted(msg.sender, _hospitalAddress);
    }

    function revokeConsent(address _hospitalAddress) public onlyRole(PATIENT_ROLE) whenNotPaused {
        patientConsent[msg.sender][_hospitalAddress] = false;
        emit ConsentRevoked(msg.sender, _hospitalAddress);
    }

    function grantEmergencyAccess(address _hospitalAddress) public onlyRole(PATIENT_ROLE) whenNotPaused {
        require(hospitals[_hospitalAddress].isActive, "Hospital is not active");
        emergencyAccessExpiration[_hospitalAddress] = block.timestamp + EMERGENCY_ACCESS_DURATION;
        emit EmergencyAccessGranted(msg.sender, _hospitalAddress, emergencyAccessExpiration[_hospitalAddress]);
    }

    function isEmergencyAccess(address _hospitalAddress) public view returns (bool) {
        return block.timestamp <= emergencyAccessExpiration[_hospitalAddress];
    }

    function importInteroperableData(string memory _dataStandard) public onlyRole(HOSPITAL_ROLE) whenNotPaused {
        // Implementation for importing data from other health record standards
        // This is a placeholder and would need to be implemented based on specific standards
        emit InteroperableDataImported(msg.sender, _dataStandard);
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function upgradeContract(address newImplementation) public onlyRole(ADMIN_ROLE) {
        // This function would be implemented in the proxy contract
        emit ContractUpgraded(newImplementation);
    }
}

//Initialize: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//Hospital: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//Patient: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
//Extra: 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB