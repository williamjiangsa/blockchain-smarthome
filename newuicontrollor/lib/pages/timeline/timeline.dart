import 'package:flutter/material.dart';
import 'package:newuicontrollor/class/connectdatabase.dart';
import 'package:newuicontrollor/lib/timeline/timeline.dart';
import 'package:newuicontrollor/lib/timeline/timeline_model.dart';
import 'package:newuicontrollor/web3/web3p.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'data.dart';

class TimelinePage extends StatefulWidget {
  List<Doodle> doodles;
  double totallytime;
  TimelinePage(
      {Key key, @required this.doodles, this.totallytime})
      : super(key: key);
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<Doodle> displaydoodles = [];
  double totallytime = 0;
  int transactiontimeinblock;
  int correctness = 0;
  int blocktime1 = 0;
  int blocktime2 = 0;
  bool correctrecord = true;

  // _initData() async {
  //   if (widget.transactionstimestamp[0] == null) {
  //     transactiontimeinblock = widget.transactionstimestamp[0];
  //   } else {
  //     transactiontimeinblock = widget.transactionstimestamp[0];
  //   }

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> readtimesnow = await Web3P.fetchReadtime();
  //   int readtimems = int.parse(readtimesnow[readtimesnow.length - 1]);
  //   int choosecolortime = prefs.getInt("ChooseColorTime");
  //   int submittime = prefs.getInt("SubmitTime");
  //   int receipttime = prefs.getInt("ReceiptTime");

  //   int eventtime = prefs.getInt("EventTime");
  //   int blocktime = eventtime - readtimems;
  //   int statuschangetime = prefs.getInt("StatusChangeTime");
  //   correctness = transactiontimeinblock - (receipttime + submittime) ~/ 2 - 60;
  //   for (int i = 0; i < widget.blockstimestamp.length; i++) {
  //     widget.blockstimestamp[i] = widget.blockstimestamp[i] - correctness;
  //   }
  //   print("------------------------");
  //   print(transactiontimeinblock);
  //   print(receipttime);
  //   print(submittime);
  //   print(correctness);
  //   print("------------------------");
  //   if (widget.blockstimestamp[1] > eventtime) {
  //     print("case0");
  //     blocktime1 = widget.blockstimestamp[3];
  //     blocktime2 = widget.blockstimestamp[2];
  //   } else if (widget.blockstimestamp[0] > eventtime) {
  //     print("case1");
  //     blocktime1 = widget.blockstimestamp[2];
  //     blocktime2 = widget.blockstimestamp[1];
  //   } else if (widget.blockstimestamp[0] < eventtime &&
  //       widget.blockstimestamp[1] < eventtime &&
  //       widget.blockstimestamp[1] > receipttime) {
  //     print("case2");
  //     blocktime1 = widget.blockstimestamp[1];
  //     blocktime2 = widget.blockstimestamp[0];
  //   } else if (widget.blockstimestamp[0] < eventtime &&
  //       widget.blockstimestamp[0] > receipttime) {
  //     print("case3");
  //     blocktime1 = widget.blockstimestamp[1];
  //     blocktime2 = widget.blockstimestamp[0];
  //   } else {
  //     print("case4");
  //     blocktime1 = widget.blockstimestamp[1];
  //     blocktime2 = widget.blockstimestamp[0];
  //   }
  //   // List<Block> blocks = await ConnectData.getblock();

  //   if (mounted) {
  //     Future.delayed(new Duration(seconds: 1), () {
  //       setState(() {
  //         totallytime = (statuschangetime - choosecolortime) / 1000.toDouble();
  //         doodles = [
  //           Doodle(
  //               timestamp: choosecolortime,
  //               name: "Choose Color Time",
  //               time: DateTime.fromMillisecondsSinceEpoch(choosecolortime)
  //                   .toString(),
  //               content: "",
  //               doodle: "",
  //               diff: choosecolortime - choosecolortime,
  //               icon: Icon(Icons.color_lens, color: Colors.white),
  //               iconBackground: Colors.cyan,
  //               left: true),
  //           Doodle(
  //               timestamp: submittime,
  //               name: "Transaction Submit Time",
  //               time:
  //                   DateTime.fromMillisecondsSinceEpoch(submittime).toString(),
  //               content: "",
  //               doodle: "",
  //               diff: submittime - choosecolortime,
  //               icon: Icon(
  //                 Icons.cloud_upload,
  //                 color: Colors.white,
  //               ),
  //               iconBackground: Colors.redAccent,
  //               left: true),
  //           Doodle(
  //               timestamp: receipttime,
  //               name: "Receive Transaction Receipt Time",
  //               time:
  //                   DateTime.fromMillisecondsSinceEpoch(receipttime).toString(),
  //               content: "",
  //               doodle: "",
  //               diff: receipttime - (transactiontimeinblock - correctness),
  //               icon: Icon(
  //                 Icons.check_circle,
  //                 color: Colors.black87,
  //                 size: 32.0,
  //               ),
  //               iconBackground: Colors.yellow,
  //               left: true),
  //           Doodle(
  //               timestamp: blocktime1,
  //               name: "Block Time",
  //               time:
  //                   DateTime.fromMillisecondsSinceEpoch(blocktime1).toString(),
  //               content: "",
  //               doodle: "",
  //               diff: 0,
  //               icon: Icon(
  //                 Icons.plus_one,
  //                 color: Colors.black87,
  //               ),
  //               iconBackground: Colors.orange,
  //               left: false),
  //           Doodle(
  //               timestamp: blocktime2,
  //               name: "Block Time",
  //               time:
  //                   DateTime.fromMillisecondsSinceEpoch(blocktime2).toString(),
  //               content: "",
  //               doodle: "",
  //               diff: blocktime2 - receipttime,
  //               icon: Icon(
  //                 Icons.plus_one,
  //                 color: Colors.black87,
  //               ),
  //               iconBackground: Colors.orange,
  //               left: false),
  //           // Doodle(
  //           //     timestamp: widget.blockstimestamp[2],
  //           //     name: "Block Time",
  //           //     time: DateTime.fromMillisecondsSinceEpoch(
  //           //             widget.blockstimestamp[2])
  //           //         .toString(),
  //           //     content: "",
  //           //     doodle: "",
  //           //     diff: 0,
  //           //     icon: Icon(
  //           //       Icons.plus_one,
  //           //       color: Colors.black87,
  //           //     ),
  //           //     iconBackground: Colors.orange,
  //           //     left: false),
  //           Doodle(
  //               timestamp: transactiontimeinblock - correctness,
  //               name: "Transaction Come In Time",
  //               time: DateTime.fromMillisecondsSinceEpoch(
  //                       transactiontimeinblock - correctness)
  //                   .toString(),
  //               content: "",
  //               doodle: "",
  //               diff: transactiontimeinblock - correctness - submittime,
  //               icon: Icon(
  //                 Icons.fiber_new,
  //                 color: Colors.black87,
  //               ),
  //               iconBackground: Colors.blueAccent,
  //               left: false),
  //           // Doodle(
  //           //     timestamp: eventtime,
  //           //     name: "Appliction Receive Comfirmation Time",
  //           //     time: DateTime.fromMillisecondsSinceEpoch(blocktime).toString(),
  //           //     content: "",
  //           //     doodle: "",
  //           //     diff: blocktime - receipttime,
  //           //     icon: Icon(
  //           //       Icons.attach_money,
  //           //       color: Colors.black87,
  //           //     ),
  //           //     iconBackground: Colors.orange,
  //           //     left: true),
  //           Doodle(
  //               timestamp: eventtime,
  //               name: "APP Receive Confirmation Time",
  //               time: DateTime.fromMillisecondsSinceEpoch(eventtime).toString(),
  //               content: "",
  //               doodle: "",
  //               diff: eventtime - blocktime2,
  //               icon: Icon(
  //                 Icons.cloud_download,
  //                 color: Colors.black87,
  //               ),
  //               iconBackground: Colors.amber,
  //               left: true),
  //           Doodle(
  //               timestamp: statuschangetime,
  //               name: "Color Change Time",
  //               time: DateTime.fromMillisecondsSinceEpoch(statuschangetime)
  //                   .toString(),
  //               content: "",
  //               doodle: "",
  //               diff: statuschangetime - eventtime,
  //               icon: Icon(
  //                 Icons.lightbulb_outline,
  //                 color: Colors.white,
  //               ),
  //               iconBackground: Colors.green,
  //               left: true),
  //         ];
  //         doodles.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  //       });
  //       if (blocktime2 > receipttime && blocktime2 < eventtime) {
  //         ConnectData.uploadsum(
  //             blocktime1,
  //             choosecolortime,
  //             submittime,
  //             transactiontimeinblock - correctness,
  //             receipttime,
  //             blocktime2,
  //             eventtime,
  //             statuschangetime,
  //             blocktime2 - blocktime1,
  //             statuschangetime - choosecolortime,
  //             submittime - choosecolortime,
  //             transactiontimeinblock - correctness - submittime,
  //             receipttime - transactiontimeinblock + correctness,
  //             blocktime2 - receipttime,
  //             eventtime - blocktime2,
  //             statuschangetime - eventtime,
  //             transactiontimeinblock - correctness - blocktime1,
  //             blocktime2 - transactiontimeinblock + correctness);
  //       }
  //     });
  //   }
  // }

  @override
  void initState() {
    // _initData();
    setState(() {
      displaydoodles = widget.doodles;
      totallytime = widget.totallytime;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline"),
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            child: timelineModel(TimelinePosition.Center),
          ),
          // Flexible(
          //   child: timelineModel(TimelinePosition.Right),
          // ),
          // timelineModel(TimelinePosition.Right)
        ],
      ),
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: displaydoodles.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = displaydoodles[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Image.network(doodle.doodle),
                const SizedBox(
                  height: 8.0,
                ),
                Text(doodle.time, style: textTheme.caption),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  doodle.name,
                  style: textTheme.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text("${doodle.diff.toString()} ms/$totallytime s",
                    style: textTheme.caption),
              ],
            ),
          ),
        ),
        position: doodle.left
            ? TimelineItemPosition.left
            : TimelineItemPosition.right,
        isFirst: i == 0,
        isLast: i == displaydoodles.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }
}

class Doodle {
  final int timestamp;
  final String name;
  final String time;
  final String content;
  final String doodle;
  final Color iconBackground;
  final int diff;
  final Icon icon;
  final bool left;
  const Doodle(
      {this.timestamp,
      this.name,
      this.time,
      this.content,
      this.doodle,
      this.diff,
      this.icon,
      this.iconBackground,
      this.left});
}
