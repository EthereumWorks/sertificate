pragma solidity ^0.4.11;

contract owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract StandardSertificate is owned{
    
    string public name;
    string public description;
    string public language;
    string public place;
    uint public hoursCount;
    
    mapping (address => uint) sertificates;
    
    function StandardSertificate (string _name, string _description, string _language, string _place, uint _hoursCount) {
        name = _name;
        description = _description;
        language = _language;
        place = _place;
        hoursCount = _hoursCount;
    }
    
    // выдача сертификата
    function issue (address student) onlyOwner {
        sertificates[student] = now;
    }
    
    function issued (address student)  constant returns (uint) {
        return sertificates[student];
    }
    
}

contract EWSertificationCenter is owned {
    
    string public name;
    string public description;
    string public place;
    
    mapping (address => bool) courses;
    
    function EWSertificationCenter (string _name, string _description, string _place) {
    
        name = _name;
        description = _description;
        place = _place;
        
    }
    
    function addCourse(address courseAddess) onlyOwner {
        courses[courseAddess] = true;
    }

    function deleteCourse(address courseAddess) onlyOwner {
        courses[courseAddess] = false;
    }
    
    function issueSertificate(address courseAddess, address student) onlyOwner {
        require (student != 0x0);
        require (courses[courseAddess]);
        
        StandardSertificate s = StandardSertificate(courseAddess);
        s.issue(student);
    }
    
    function checkSertificate(address courseAddess, address student) constant returns (uint) {
        require (student != 0x0);
        require (courses[courseAddess]);
        
        StandardSertificate s = StandardSertificate(courseAddess);
        return s.issued(student);        
    }
}
