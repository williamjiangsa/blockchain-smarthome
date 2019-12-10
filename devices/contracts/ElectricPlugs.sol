pragma solidity ^0.5.0;

// main Contract
contract ElectricPlugs {

  event NewElectricPlug(string hash_id, string name, string description, bool status);
  event RemoveElectricPlug(string hash_id);
  event NameChange(string hash_id, string name);
  event DescriptionChange(string hash_id, string description);
  event StatusChange(string hash_id, bool status);

  struct ElectricPlug {
    string hash_id; //in format Ele_1
    string name; // front door
    string description; // for plug -> what to, where
    bool status; // true/false = on/off
  }

  ElectricPlug[] public electricPlugs;

  mapping (uint => address) public electricPlugToOwner;

  // return current number of devices
  function getNumberOfdevices() public view returns (uint) {
    return  electricPlugs.length;
  }

  // help function to convert uint 2 string
  function uint2str(uint _index) internal pure returns (string memory _uintAsString) {
    uint _i = _index;
    if (_i == 0) {
        return "0";
    }
    uint j = _i;
    uint len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (_i != 0) {
        bstr[k--] = byte(uint8(48 + _i % 10));
        _i /= 10;
    }
    return string(bstr);
  }

  // fetch a device's information
  function fetchDeviceStatus(uint256 _id) external view returns (
    string memory _hash_id,
    string memory _name,
    string memory _description,
    bool _status // true/false = on/off
    ) {
    return (
    _hash_id = electricPlugs[_id].hash_id,
    _name = electricPlugs[_id].name,
    _description = electricPlugs[_id].description,
    _status = electricPlugs[_id].status
    );
  }

  // Add a new device
  function _addElectricPlug(string memory _name, string memory _description) public {
    uint _electricPlugId = electricPlugs.push(ElectricPlug("Ele_X",_name, _description, false)) - 1;
    string memory _hash_id = string(abi.encodePacked("Ele_", uint2str(_electricPlugId)));
    electricPlugs[_electricPlugId].hash_id = _hash_id;

    // deviceCounter = _electricPlugId+1;

    electricPlugToOwner[_electricPlugId] = msg.sender;
    emit NewElectricPlug(_hash_id, _name, _description, false);
  }

  // Remove a device
  function _removeElectricPlug(uint _electricPlugId) public {
    require(_electricPlugId < electricPlugs.length, "Error: Incorrect ElectricPlugId (_removeElectricPlug)");
    string memory _hash_id = electricPlugs[_electricPlugId].hash_id;

    for (uint i = _electricPlugId; i<electricPlugs.length-1; i++){
      electricPlugs[_electricPlugId] = electricPlugs[_electricPlugId + 1];
    }
    electricPlugs.length--;
    emit RemoveElectricPlug(_hash_id);
  }

  // All changes
  function _changeName(uint _electricPlugId, string memory _name) public {
    require(msg.sender == electricPlugToOwner[_electricPlugId], "Error: Incorrect ElectricPlug owner (_changeName)");
    electricPlugs[_electricPlugId].name = _name;
    emit NameChange(electricPlugs[_electricPlugId].hash_id, _name);
  }

  function _changeDescription(uint _electricPlugId, string memory _description) public {
    require(msg.sender == electricPlugToOwner[_electricPlugId], "Error: Incorrect ElectricPlug owner (_changeDescription)");
    electricPlugs[_electricPlugId].description = _description;
    emit DescriptionChange(electricPlugs[_electricPlugId].hash_id, _description);
  }

  function _changeStatus(uint _electricPlugId, bool _status) public {
    require(msg.sender == electricPlugToOwner[_electricPlugId], "Error: Incorrect ElectricPlug owner (_changeStatus)");
    electricPlugs[_electricPlugId].status = _status;
    emit StatusChange(electricPlugs[_electricPlugId].hash_id, _status);
  }

} // end of contract