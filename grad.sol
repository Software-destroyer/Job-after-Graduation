// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JobPlatform {
    // Define a struct for student profiles
    struct StudentProfile {
        uint256 id;
        address studentAddress;
        string name;
        string qualification;
        string jobPreferences;
        bool isRegistered;
    }

    // Define a struct for company profiles
    struct CompanyProfile {
        uint256 id;
        address companyAddress;
        string companyName;
        string jobRequirements;
    }

    // Counter for generating unique IDs
    uint256 private studentIdCounter;
    uint256 private companyIdCounter;

    // Mappings to store student and company profiles
    mapping(uint256 => StudentProfile) public studentProfiles;
    mapping(uint256 => CompanyProfile) public companyProfiles;

    // Mappings to check if the student or company exists
    mapping(address => bool) public isStudentRegistered;
    mapping(address => bool) public isCompanyRegistered;

    // Events to emit on profile registration and updates
    event StudentRegistered(uint256 id, address studentAddress, string name);
    event CompanyRegistered(uint256 id, address companyAddress, string companyName);

    // Function to register a student
    function registerStudent(string memory name, string memory qualification, string memory jobPreferences) external {
        require(!isStudentRegistered[msg.sender], "Student is already registered");

        studentIdCounter++;
        uint256 studentId = studentIdCounter;

        studentProfiles[studentId] = StudentProfile({
            id: studentId,
            studentAddress: msg.sender,
            name: name,
            qualification: qualification,
            jobPreferences: jobPreferences,
            isRegistered: true
        });

        isStudentRegistered[msg.sender] = true;

        emit StudentRegistered(studentId, msg.sender, name);
    }

    // Function to register a company
    function registerCompany(string memory companyName, string memory jobRequirements) external {
        require(!isCompanyRegistered[msg.sender], "Company is already registered");

        companyIdCounter++;
        uint256 companyId = companyIdCounter;

        companyProfiles[companyId] = CompanyProfile({
            id: companyId,
            companyAddress: msg.sender,
            companyName: companyName,
            jobRequirements: jobRequirements
        });

        isCompanyRegistered[msg.sender] = true;

        emit CompanyRegistered(companyId, msg.sender, companyName);
    }

    // Function to get student profiles based on job preferences
    function getStudentProfilesByJobPreferences(string memory jobPreferences) external view returns (StudentProfile[] memory) {
        uint256 totalStudents = studentIdCounter;
        uint256 resultCount = 0;

        // Count the number of students matching the job preferences
        for (uint256 i = 1; i <= totalStudents; i++) {
            if (keccak256(bytes(studentProfiles[i].jobPreferences)) == keccak256(bytes(jobPreferences))) {
                resultCount++;
            }
        }

        StudentProfile[] memory result = new StudentProfile[](resultCount);
        uint256 index = 0;

        // Populate the result array with matching student profiles
        for (uint256 i = 1; i <= totalStudents; i++) {
            if (keccak256(bytes(studentProfiles[i].jobPreferences)) == keccak256(bytes(jobPreferences))) {
                result[index] = studentProfiles[i];
                index++;
            }
        }

        return result;
    }

    // Function to get company profiles based on job requirements
    function getCompanyProfilesByJobRequirements(string memory jobRequirements) external view returns (CompanyProfile[] memory) {
        uint256 totalCompanies = companyIdCounter;
        uint256 resultCount = 0;

        // Count the number of companies matching the job requirements
        for (uint256 i = 1; i <= totalCompanies; i++) {
            if (keccak256(bytes(companyProfiles[i].jobRequirements)) == keccak256(bytes(jobRequirements))) {
                resultCount++;
            }
        }

        CompanyProfile[] memory result = new CompanyProfile[](resultCount);
        uint256 index = 0;

        // Populate the result array with matching company profiles
        for (uint256 i = 1; i <= totalCompanies; i++) {
            if (keccak256(bytes(companyProfiles[i].jobRequirements)) == keccak256(bytes(jobRequirements))) {
                result[index] = companyProfiles[i];
                index++;
            }
        }

        return result;
    }
}
