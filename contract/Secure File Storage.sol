// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Secure File Storage
 * @dev A simple decentralized file storage registry allowing users 
 *      to upload, update, and retrieve encrypted file hashes or URIs.
 */
contract Project {
    
    struct FileMeta {
        string fileHash;     // Hash or encrypted CID
        uint256 timestamp;   // Last update timestamp
        address owner;       // Owner of file record
    }

    // Mapping: fileId => FileMeta
    mapping(bytes32 => FileMeta) private files;

    /// Event logs for dApp tracking
    event FileUploaded(bytes32 indexed fileId, address indexed owner, string fileHash);
    event FileUpdated(bytes32 indexed fileId, string newFileHash);
    
    /**
     * @dev Upload a new file hash to the storage.
     * @param fileId A unique identifier for the file (e.g., keccak256 hash).
     * @param fileHash Encrypted file hash or IPFS CID.
     */
    function uploadFile(bytes32 fileId, string calldata fileHash) external {
        require(files[fileId].owner == address(0), "File already exists");
        
        files[fileId] = FileMeta({
            fileHash: fileHash,
            timestamp: block.timestamp,
            owner: msg.sender
        });

        emit FileUploaded(fileId, msg.sender, fileHash);
    }

    /**
     * @dev Update the hash of an existing file.
     * @param fileId File identifier.
     * @param newHash New encrypted file hash or CID.
     */
    function updateFile(bytes32 fileId, string calldata newHash) external {
        require(files[fileId].owner == msg.sender, "Not file owner");

        files[fileId].fileHash = newHash;
        files[fileId].timestamp = block.timestamp;

        emit FileUpdated(fileId, newHash);
    }

    /**
     * @dev Retrieve file metadata.
     * @param fileId Unique file identifier.
     * @return fileHash, timestamp, owner
     */
    function getFile(bytes32 fileId)
        external
        view
        returns (string memory, uint256, address)
    {
        FileMeta memory f = files[fileId];
        require(f.owner != address(0), "File not found");
        return (f.fileHash, f.timestamp, f.owner);
    }
}

