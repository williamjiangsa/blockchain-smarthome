import 'package:newuicontrollor/class/shareddata.dart';

class Orchestration {
  static Future<bool> updatePeopleStatus(String _name) async {
    await SharedData.updatePeople(_name);
    List<String> _current = await SharedData.getPeople();
    for (var i = 0; i < _current.length; i++) {
      if (_current[i] == _name) {
        return true;
      }
    }
    return false;
  }
}
