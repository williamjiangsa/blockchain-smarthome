pragma solidity ^0.5.0;

import './LightBulbs.sol';

contract Orchestration is LightBulbs {

  event orchestrationCall(string _func);

  string[] private names;

  function compareStrings (string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
  }

  function updateNames(string memory _name) internal {
    for(uint i = 0; i < names.length; i++) {
      if(compareStrings(names[i], _name)) {
        for(uint j = i; j < names.length-1; j++) {
          names[i] = names[i+1];
        }
        names.length--;
        return;
      }
    }
    names.push(_name);
    return;
  }

  function namesOrchestration(string memory _name) public {
    updateNames(_name);

    // check which name is in names
    bool _kai = false;
    bool _kang = false;
    bool _justin = false;
    for(uint i = 0; i < names.length; i++) {
      if(compareStrings(names[i], 'Kai')) {
        _kai = true;
      }
      if(compareStrings(names[i], 'Kang')) {
        _kang = true;
      }
      if(compareStrings(names[i], 'Justin')) {
        _justin = true;
      }
    }

    // call corresponding function
    if (_kai && !_kang && !_justin) {
      _onlyKai();
      emit orchestrationCall('_onlyKai');
    }
    else if (!_kai && _kang && !_justin) {
      _onlyKang();
      emit orchestrationCall('_onlyKang');
    }
    else if (!_kai && !_kang && _justin) {
      _onlyJustin();
      emit orchestrationCall('_onlyJustin');
    }
    else if (_kai && _kang && !_justin) {
      _bothKaiAndKang();
      emit orchestrationCall('_bothKaiAndKang');
    }
    else if (_kai && !_kang && _justin) {
      _bothKaiAndJustin();
      emit orchestrationCall('_bothKaiAndJustin');
    }
    else if (!_kai && _kang && _justin) {
      _bothKaiAndJustin();
      emit orchestrationCall('_bothKaiAndJustin');
    }
    else if (_kai && _kang && _justin) {
      _allThree();
      emit orchestrationCall('_allThree');
    }
    else {
      _nobodyHome();
      emit orchestrationCall('_nobodyHome');
    }
  }

  function _onlyKai() internal {
    LightBulbs._changeStatus(0, true);
    LightBulbs._changeColor(0, 244, 67, 54);
    LightBulbs._changeStatus(1, false);
    LightBulbs._changeStatus(2, false);
  }

  function _onlyKang() internal {
    LightBulbs._changeStatus(0, false);
    LightBulbs._changeStatus(1, true);
    LightBulbs._changeColor(1, 244, 67, 54);
    LightBulbs._changeStatus(2, false);
  }

  function _onlyJustin() internal {
    LightBulbs._changeStatus(0, false);
    LightBulbs._changeStatus(1, false);
    LightBulbs._changeStatus(2, true);
    LightBulbs._changeColor(2, 244, 67, 54);
  }

  function _bothKaiAndKang() internal {
    LightBulbs._changeStatus(0, true);
    LightBulbs._changeColor(0, 244, 67, 54);
    LightBulbs._changeStatus(1, true);
    LightBulbs._changeColor(1, 244, 67, 54);
    LightBulbs._changeStatus(2, false);
  }

  function _bothKaiAndJustin() internal {
    LightBulbs._changeStatus(0, true);
    LightBulbs._changeColor(0, 244, 67, 54);
    LightBulbs._changeStatus(1, false);
    LightBulbs._changeStatus(2, true);
    LightBulbs._changeColor(2, 244, 67, 54);
  }

  function _bothJustinAndKang() internal {
    LightBulbs._changeStatus(0, false);
    LightBulbs._changeStatus(1, true);
    LightBulbs._changeColor(1, 244, 67, 54);
    LightBulbs._changeStatus(2, true);
    LightBulbs._changeColor(2, 244, 67, 54);
  }

  function _allThree() internal {
    LightBulbs._changeStatus(0, true);
    LightBulbs._changeColor(0, 244, 67, 54);
    LightBulbs._changeStatus(1, true);
    LightBulbs._changeColor(1, 244, 67, 54);
    LightBulbs._changeStatus(2, true);
    LightBulbs._changeColor(2, 244, 67, 54);
  }

  function _nobodyHome() internal {
    LightBulbs._changeStatus(0, false);
    LightBulbs._changeStatus(1, false);
    LightBulbs._changeStatus(2, false);
  }
} // end of contract