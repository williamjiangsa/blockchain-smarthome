import 'package:shared_preferences/shared_preferences.dart';

class Dateconvert {
  static int datetotimestamp(DateTime time) {
    int timestamp = time.millisecondsSinceEpoch;
    return timestamp;
  }

  static storetimestamp(int timestamp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> time = prefs.getStringList("timestamp");
    if (time == null) {
      time = new List();
      time.add(timestamp.toString());
    } else {
      time.add(timestamp.toString());
    }
    prefs.setStringList("timestamp", time);
  }

  static void storedate(DateTime date){
    int timestamp = datetotimestamp(date);
    storetimestamp(timestamp);
  }

  static storedifftime(String timename, int timestamp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(timename, timestamp);
    print("=========$timename is $timestamp");
  }
}
