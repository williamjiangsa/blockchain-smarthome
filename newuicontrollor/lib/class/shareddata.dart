import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static Future setPrivateKey(String privatekey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("PrivateKey", privatekey);
  }

  static Future<String> getPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting PrivateKey");
    return prefs.getString("PrivateKey");
  }

  static Future setChainID(int path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("ChainID", path);
  }

  static Future<int> getChainID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting ChainID");
    return prefs.getInt("ChainID");
  }

  static Future setContractAddress(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ContractAddress", path);
  }

  static Future<String> getContractAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting ContractAddress");
    return prefs.getString("ContractAddress");
  }

  static Future setKeystoreFilePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("KeystoreFilePath", path);
  }

  static Future<String> getKeystoreFilePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting KeystoreFilePath");
    return prefs.getString("KeystoreFilePath");
  }

  static Future setABIFilePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ABIFilePath", path);
  }

  static Future<String> getABIFilePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting ABIFilePath");
    return prefs.getString("ABIFilePath");
  }

  static Future<String> saveServerAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ServerAddress", address);
    print(address);
    return "success";
  }

  static Future<String> getServerAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting address");
    return prefs.getString("ServerAddress");
  }

  static Future<String> saveServerAddressWS(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ServerAddressWS", address);
    print(address);
    return "success";
  }

  static Future<String> getServerAddressWS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting address WS");
    return prefs.getString("ServerAddressWS");
  }

  static Future<String> saveServerIP(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ServerIP", address);
    return "success";
  }

  static Future<String> getServerIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("ServerIP");
  }

  static Future setNetwork(String net) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Network", net);
  }

  static Future<String> getNetwork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting network");
    return prefs.getString("Network");
  }

  static Future setNotFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("isFirstTime", false);
  }

  static Future<bool> isFirstTimeUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("checking if first time");
    return prefs.getBool("isFirstTime");
  }

  static Future saveAccountJson(String account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("AccountJson", account);
  }

  static Future<String> getAccountJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting AccountJson");
    return prefs.getString("AccountJson");
  }

  static Future saveAccountPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("setting password");
    return prefs.setString("AccountPassword", password);
  }

  static Future<String> getAccountPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting AccountPassword");
    return prefs.getString("AccountPassword");
  }

  static Future updatePeople(String _name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _currentPeople = prefs.getStringList("People");
    if (_currentPeople != null) {
      for (var i = 0; i < _currentPeople.length; i++) {
        if (_currentPeople[i] == _name) {
          _currentPeople.remove(_name);
          return prefs.setStringList('People', _currentPeople);
        }
      }
    } else {
      _currentPeople = new List();
    }
    _currentPeople.add(_name);
    return prefs.setStringList("People", _currentPeople);
  }

  static Future<List<String>> getPeople() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('People');
  }
}
