import 'package:flutter/material.dart';
import 'package:newuicontrollor/class/connectdatabase.dart';
import 'package:newuicontrollor/lib/timeline/timeline.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:newuicontrollor/pages/timeline/timeline.dart';

// import 'data.dart';

class GenerateTimelinePage extends StatefulWidget {
  List<int> blockstimestamp;
  List<int> transactionstimestamp;
  GenerateTimelinePage(
      {Key key, @required this.blockstimestamp, this.transactionstimestamp})
      : super(key: key);
  @override
  _GenerateTimelinePageState createState() => _GenerateTimelinePageState();
}

class _GenerateTimelinePageState extends State<GenerateTimelinePage> {
  List<Doodle> doodles = [];
  double totallytime = 0;
  int transactiontimeinblock;
  int correctness = 0;
  int blocktime1 = 0;
  int blocktime2 = 0;
  bool correctrecord = true;
  bool loading = true;

  _findBlocks() {
    int cur=10;
    for (int i = 1; i < widget.blockstimestamp.length; i++) {
      print(widget.blockstimestamp[i - 1]);
      print(widget.transactionstimestamp[0]);
      print(widget.blockstimestamp[i]);
      print("---------------");
      if (widget.transactionstimestamp[0] > widget.blockstimestamp[i]) {
        print("!!!!!-----------------Find blocks");
        print(i);
        cur = i; 
        break;
      }
    }
    transactiontimeinblock = widget.transactionstimestamp[0];
    blocktime2 = widget.blockstimestamp[cur - 1];
    blocktime1 = widget.blockstimestamp[cur];
  }

  _initData() async {
    _findBlocks();
    // if (widget.transactionstimestamp[0] == null) {
    //   transactiontimeinblock = widget.transactionstimestamp[0];
    // } else {
    //   transactiontimeinblock = widget.transactionstimestamp[0];
    // }
    TS apptimes = await ConnectData.getts();
    if (apptimes.ts4 == null) {
      Future.delayed(new Duration(seconds: 1), () {
        _initData();
      });
    } else {
      int choosecolortime = int.parse(apptimes.ts1);
      int submittime = int.parse(apptimes.ts2);
      int receipttime = int.parse(apptimes.ts3);
      int eventtime = int.parse(apptimes.ts4);
      int statuschangetime = int.parse(apptimes.ts5);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // List<String> readtimesnow = await Web3P.fetchReadtime();
      // int readtimems = int.parse(readtimesnow[readtimesnow.length - 1]);
      // int choosecolortime = prefs.getInt("ChooseColorTime");
      // int submittime = prefs.getInt("SubmitTime");
      // int receipttime = prefs.getInt("ReceiptTime");

      // int eventtime = prefs.getInt("EventTime");
      // int blocktime = eventtime - readtimems;
      // int statuschangetime = prefs.getInt("StatusChangeTime");
      correctness =
          transactiontimeinblock - (receipttime + submittime) ~/ 2 - 50;
      // for (int i = 0; i < widget.blockstimestamp.length; i++) {
      //   widget.blockstimestamp[i] = widget.blockstimestamp[i] - correctness;
      // }
      // print("------------------------");
      // print(transactiontimeinblock);
      // print(receipttime);
      // print(submittime);
      // print(correctness);
      // print("------------------------");
      // if (widget.blockstimestamp[1] > eventtime) {
      //   print("case0");
      //   blocktime1 = widget.blockstimestamp[3];
      //   blocktime2 = widget.blockstimestamp[2];
      // } else if (widget.blockstimestamp[0] > eventtime) {
      //   print("case1");
      //   blocktime1 = widget.blockstimestamp[2];
      //   blocktime2 = widget.blockstimestamp[1];
      // } else if (widget.blockstimestamp[0] < eventtime &&
      //     widget.blockstimestamp[1] < eventtime &&
      //     widget.blockstimestamp[1] > receipttime) {
      //   print("case2");
      //   blocktime1 = widget.blockstimestamp[1];
      //   blocktime2 = widget.blockstimestamp[0];
      // } else if (widget.blockstimestamp[0] < eventtime &&
      //     widget.blockstimestamp[0] > receipttime) {
      //   print("case3");
      //   blocktime1 = widget.blockstimestamp[1];
      //   blocktime2 = widget.blockstimestamp[0];
      // } else {
      //   print("case4");
      //   blocktime1 = widget.blockstimestamp[1];
      //   blocktime2 = widget.blockstimestamp[0];
      // }
      // List<Block> blocks = await ConnectData.getblock();

      if (mounted) {
        Future.delayed(new Duration(seconds: 1), () {
          setState(() {
            totallytime =
                (statuschangetime - choosecolortime) / 1000.toDouble();
            doodles = [
              Doodle(
                  timestamp: choosecolortime,
                  name: "Choose Color Time",
                  time: DateTime.fromMillisecondsSinceEpoch(choosecolortime)
                      .toString(),
                  content: "",
                  doodle: "",
                  diff: choosecolortime - choosecolortime,
                  icon: Icon(Icons.color_lens, color: Colors.white),
                  iconBackground: Colors.cyan,
                  left: true),
              Doodle(
                  timestamp: submittime,
                  name: "Transaction Submit Time",
                  time: DateTime.fromMillisecondsSinceEpoch(submittime)
                      .toString(),
                  content: "",
                  doodle: "",
                  diff: submittime - choosecolortime,
                  icon: Icon(
                    Icons.cloud_upload,
                    color: Colors.white,
                  ),
                  iconBackground: Colors.redAccent,
                  left: true),
              Doodle(
                  timestamp: receipttime,
                  name: "Receive Transaction Receipt Time",
                  time: DateTime.fromMillisecondsSinceEpoch(receipttime)
                      .toString(),
                  content: "",
                  doodle: "",
                  diff: receipttime - (transactiontimeinblock - correctness),
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.black87,
                    size: 32.0,
                  ),
                  iconBackground: Colors.yellow,
                  left: true),
              Doodle(
                  timestamp: blocktime1,
                  name: "Block Time",
                  time: DateTime.fromMillisecondsSinceEpoch(blocktime1)
                      .toString(),
                  content: "",
                  doodle: "",
                  diff: 0,
                  icon: Icon(
                    Icons.plus_one,
                    color: Colors.black87,
                  ),
                  iconBackground: Colors.orange,
                  left: false),
              Doodle(
                  timestamp: blocktime2,
                  name: "Block Time",
                  time: DateTime.fromMillisecondsSinceEpoch(blocktime2)
                      .toString(),
                  content: "",
                  doodle: "",
                  diff: blocktime2 - receipttime,
                  icon: Icon(
                    Icons.plus_one,
                    color: Colors.black87,
                  ),
                  iconBackground: Colors.orange,
                  left: false),
              Doodle(
                  timestamp: transactiontimeinblock - correctness,
                  name: "Transaction Come In Time",
                  time: DateTime.fromMillisecondsSinceEpoch(
                          transactiontimeinblock - correctness)
                      .toString(),
                  content: "",
                  doodle: "",
                  diff: transactiontimeinblock - correctness - submittime,
                  icon: Icon(
                    Icons.fiber_new,
                    color: Colors.black87,
                  ),
                  iconBackground: Colors.blueAccent,
                  left: false),
              Doodle(
                  timestamp: eventtime,
                  name: "APP Receive Confirmation Time",
                  time:
                      DateTime.fromMillisecondsSinceEpoch(eventtime).toString(),
                  content: "",
                  doodle: "",
                  diff: eventtime - blocktime2,
                  icon: Icon(
                    Icons.cloud_download,
                    color: Colors.black87,
                  ),
                  iconBackground: Colors.amber,
                  left: true),
              Doodle(
                  timestamp: statuschangetime,
                  name: "Color Change Time",
                  time: DateTime.fromMillisecondsSinceEpoch(statuschangetime)
                      .toString(),
                  content: "",
                  doodle: "",
                  diff: statuschangetime - eventtime,
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                  ),
                  iconBackground: Colors.green,
                  left: true),
            ];
            doodles.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          });
          Future.delayed(new Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
          });
          ConnectData.uploadsum(
              blocktime1,
              choosecolortime,
              submittime,
              transactiontimeinblock - correctness,
              receipttime,
              blocktime2,
              eventtime,
              statuschangetime,
              blocktime2 - blocktime1,
              statuschangetime - choosecolortime,
              submittime - choosecolortime,
              transactiontimeinblock - correctness - submittime,
              receipttime - transactiontimeinblock + correctness,
              blocktime2 - receipttime,
              eventtime - blocktime2,
              statuschangetime - eventtime,
              transactiontimeinblock - correctness - blocktime1,
              blocktime2 - transactiontimeinblock + correctness);
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => new TimelinePage(
                  doodles: doodles, totallytime: totallytime)));
        });
      }
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generating Timeline"),
      ),
      body: Center(
        child: loading
            ? Center(
                child: Container(
                  height: 200,
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballGridPulse,
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            : Text(""),
      ),
    );
  }

  // timelineModel(TimelinePosition position) => Timeline.builder(
  //     itemBuilder: centerTimelineBuilder,
  //     itemCount: doodles.length,
  //     physics: position == TimelinePosition.Left
  //         ? ClampingScrollPhysics()
  //         : BouncingScrollPhysics(),
  //     position: position);

  // TimelineModel centerTimelineBuilder(BuildContext context, int i) {
  //   final doodle = doodles[i];
  //   final textTheme = Theme.of(context).textTheme;
  //   return TimelineModel(
  //       Card(
  //         margin: EdgeInsets.symmetric(vertical: 16.0),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  //         clipBehavior: Clip.antiAlias,
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               // Image.network(doodle.doodle),
  //               const SizedBox(
  //                 height: 8.0,
  //               ),
  //               Text(doodle.time, style: textTheme.caption),
  //               const SizedBox(
  //                 height: 8.0,
  //               ),
  //               Text(
  //                 doodle.name,
  //                 style: textTheme.title,
  //                 textAlign: TextAlign.center,
  //               ),
  //               const SizedBox(
  //                 height: 8.0,
  //               ),
  //               Text("${doodle.diff.toString()} ms/$totallytime s",
  //                   style: textTheme.caption),
  //             ],
  //           ),
  //         ),
  //       ),
  //       position: doodle.left
  //           ? TimelineItemPosition.left
  //           : TimelineItemPosition.right,
  //       isFirst: i == 0,
  //       isLast: i == doodles.length,
  //       iconBackground: doodle.iconBackground,
  //       icon: doodle.icon);
  // }
}
