import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConnectData {
  static Future<List<Block>> getblock() async {
    List<Block> list = List(3);
    final response = await http
        .get("http://www.lightningrepair.com.au/smarthomephp/readblock.php");

    list = (json.decode(response.body) as List)
        .map((data) => new Block.fromJson(data))
        .toList();
    return list;
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<List<int>> getblocklog() async {
    List<Blocklog> list = List(20);
    List<int> blockstimestamp = new List(20);
    final response = await http
        .get("http://www.lightningrepair.com.au/smarthomephp/readblocklog.php");

    list = (json.decode(response.body) as List)
        .map((data) => new Blocklog.fromJson(data))
        .toList();

    for (int i = 0; i < list.length; i++) {
      String blocktimestring = list[i].blocktime;
      if (blocktimestring.length >= 2) {
        List<String> blocktimesplit = blocktimestring.split(":");
        DateTime blocktime = DateTime(
            2019,
            int.parse(blocktimesplit[0]),
            int.parse(blocktimesplit[1]),
            int.parse(blocktimesplit[2]),
            int.parse(blocktimesplit[3]),
            int.parse(blocktimesplit[4]),
            int.parse(blocktimesplit[5]));
        blockstimestamp[i] = blocktime.millisecondsSinceEpoch;
      }
    }
    return blockstimestamp;
  }


  ///////////////////////////////////////////////////////////////////////////////
  static Future<TS> getts() async {
    List<TS> list = List(3);
    final response = await http
        .get("http://www.lightningrepair.com.au/smarthomephp/readts.php");

    list = (json.decode(response.body) as List)
        .map((data) => new TS.fromJson(data))
        .toList();

    return list[0];
  }

  ///////////////////////////////////////////////////////////////////////////////

  // static Future<Null> uploadtimestamp(
  //     int ts1, int ts2, int ts3, int ts4, int ts5) async {
  //   final response = await http.get(
  //       "http://www.lightningrepair.com.au/smarthomephp/addtimestamp.php?TS1=$ts1&TS2=$ts2&TS3=$ts3&TS4=$ts4&TS5=$ts5");
  //   print("upload, ${response.body.toString()}");
  // }

  static Future<Null> uploadtimestamp1(int ts1, int ts2, int ts3) async {
    final response = await http.get(
        "http://www.lightningrepair.com.au/smarthomephp/addtimestamp1.php?TS1=$ts1&TS2=$ts2&TS3=$ts3");
    print("timestamp1 upload, ${response.body.toString()}");
  }

  static Future<Null> uploadtimestamp2(int ts4, int ts5) async {
    final response = await http.get(
        "http://www.lightningrepair.com.au/smarthomephp/addtimestamp2.php?TS4=$ts4&TS5=$ts5");
    print("timestamp2 upload, ${response.body.toString()}");
  }

  static Future<Null> uploadsum(
      int ts1,
      int ts2,
      int ts3,
      int ts4,
      int ts5,
      int ts6,
      int ts7,
      int ts8,
      int blockgap,
      int actgap,
      int d1,
      int d2,
      int d3,
      int d4,
      int d5,
      int d6,
      int bd1,
      int bd2) async {
    final response = await http.get(
        "http://www.lightningrepair.com.au/smarthomephp/addsum.php?TS1=$ts1&TS2=$ts2&TS3=$ts3&TS4=$ts4&TS5=$ts5&TS6=$ts6&TS7=$ts7&TS8=$ts8&GAP1=$blockgap&GAP2=$actgap&D1=$d1&D2=$d2&D3=$d3&D4=$d4&D5=$d5&D6=$d6&BD1=$bd1&BD2=$bd2");
    print("upload, ${response.body.toString()}");
  }

  ///////////////////////////////////////////////////////////////////////////////
  static Future<List<int>> gettransactionlog() async {
    List<Transactionlog> list = List(5);
    List<int> transactionstimestamp = new List(5);
    final response = await http.get(
        "http://www.lightningrepair.com.au/smarthomephp/readtransactionlog.php");

    list = (json.decode(response.body) as List)
        .map((data) => new Transactionlog.fromJson(data))
        .toList();

    for (int i = 0; i < list.length; i++) {
      String blocktimestring = list[i].transactiontime;
      if (blocktimestring.length >= 2) {
        List<String> blocktimesplit = blocktimestring.split(":");
        DateTime blocktime = DateTime(
            2019,
            int.parse(blocktimesplit[0]),
            int.parse(blocktimesplit[1]),
            int.parse(blocktimesplit[2]),
            int.parse(blocktimesplit[3]),
            int.parse(blocktimesplit[4]),
            int.parse(blocktimesplit[5]));
        transactionstimestamp[i] = blocktime.millisecondsSinceEpoch;
      }
    }
    return transactionstimestamp;
  }
}

///////////////////////////////////////////////////////////////////////////////
class Block {
  int blockid;
  int blocktime;

  Block({this.blockid, this.blocktime});

  Block.fromJson(Map<String, dynamic> json) {
    blockid = int.parse(json['blockid']);
    blocktime = int.parse(json['blocktime']);
    print("=====blocktime from database is $blocktime");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockid'] = this.blockid;
    data['blocktime'] = this.blocktime;
    return data;
  }
}

class Blocklog {
  int blockid;
  String blocktime;

  Blocklog({this.blockid, this.blocktime});

  Blocklog.fromJson(Map<String, dynamic> json) {
    blockid = int.parse(json['blockid']);
    blocktime = json['blocktime'];
    print("=====blocktimelog from database is $blocktime");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockid'] = this.blockid;
    data['blocktime'] = this.blocktime;
    return data;
  }
}

class Transactionlog {
  int transactionid;
  String transactiontime;

  Transactionlog({this.transactionid, this.transactiontime});

  Transactionlog.fromJson(Map<String, dynamic> json) {
    transactionid = int.parse(json['transactionid']);
    transactiontime = json['transactiontime'];
    print("=====transactiontimelog from database is $transactiontime");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionid'] = this.transactionid;
    data['transactiontime'] = this.transactiontime;
    return data;
  }
}

class TS {
  String ts1;
  String ts2;
  String ts3;
  String ts4;
  String ts5;

  TS({this.ts1, this.ts2, this.ts3, this.ts4, this.ts5});

  TS.fromJson(Map<String, dynamic> json) {
    ts1 = json['ts1'];
    ts2 = json['ts2'];
    ts3 = json['ts3'];
    ts4 = json['ts4'];
    ts5 = json['ts5'];
    print("=====ts1 from database is $ts1");
    print("=====ts2 from database is $ts2");
    print("=====ts3 from database is $ts3");
    print("=====ts4 from database is $ts4");
    print("=====ts5 from database is $ts5");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ts1'] = this.ts1;
    data['ts2'] = this.ts2;
    data['ts3'] = this.ts3;
    data['ts4'] = this.ts4;
    data['ts5'] = this.ts5;
    return data;
  }
}
