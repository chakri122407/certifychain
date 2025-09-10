// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CertifyChain
 * @dev A blockchain-based certification system that issues, verifies,
 *      and stores certificates securely on-chain.
 */
contract CertifyChain {
    address public owner;

    struct Certificate {
        string studentName;
        string courseName;
        uint256 issuedOn;
        bool isValid;
    }

    mapping(uint256 => Certificate) public certificates;
    uint256 public certCount;

    event CertificateIssued(uint256 certId, string studentName, string courseName);
    event CertificateRevoked(uint256 certId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Issue a new certificate
    function issueCertificate(string memory _studentName, string memory _courseName) external onlyOwner {
        certCount++;
        certificates[certCount] = Certificate(_studentName, _courseName, block.timestamp, true);
        emit CertificateIssued(certCount, _studentName, _courseName);
    }

    /// @notice Verify if a certificate is valid
    function verifyCertificate(uint256 _certId) external view returns (bool) {
        return certificates[_certId].isValid;
    }

    /// @notice Revoke an issued certificate
    function revokeCertificate(uint256 _certId) external onlyOwner {
        require(certificates[_certId].isValid, "Certificate already revoked or does not exist");
        certificates[_certId].isValid = false;
        emit CertificateRevoked(_certId);
    }
}

