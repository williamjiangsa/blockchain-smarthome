import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:http/http.dart';
import 'package:newuicontrollor/class/color.dart';
import 'package:newuicontrollor/class/connectdatabase.dart';
import 'package:newuicontrollor/class/dateconvert.dart';
import 'package:newuicontrollor/class/event.dart';
import 'package:newuicontrollor/class/shareddata.dart';
import 'package:newuicontrollor/pages/timeline/generatetimeline.dart';
import 'package:newuicontrollor/pages/timeline/timeline.dart';
import 'package:newuicontrollor/web3/web3.dart';
import 'package:newuicontrollor/web3/web3p.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'lights.dart';

class LightDetailPage extends StatefulWidget {
  final DeviceStatus curdevice;
  LightDetailPage({Key key, @required this.curdevice}) : super(key: key);
  @override
  _LightDetailPageState createState() => _LightDetailPageState();
}

class _LightDetailPageState extends State<LightDetailPage> {
  bool isController = true;
  final globalKey = new GlobalKey<ScaffoldState>();
  DeviceStatus curdevices;
  StreamSubscription<FilterEvent> subscription;
  Web3Client client;
  String network;

  List<int> blockstimestamp = new List(5);
  List<int> transactionstimestamp = new List(5);

  Color currentColor = const Color(0xff443a49);
  double _value = 0.0;
  double percentage;
  void _setvalue(double value) => setState(() => _value = value);

  void changeColorAndPopout(Color color) async {
    setState(() {
      currentColor = color;
    });
    _recordchoosetime();
    // print(color.toString());

    Timer(const Duration(milliseconds: 500), () => Navigator.of(context).pop());
    Future.delayed(new Duration(milliseconds: 100), () {
      _webchangecolor();
    });
  }

  _recordchoosetime() {
    int eventtime = DateTime.now().millisecondsSinceEpoch;
    Dateconvert.storedifftime("ChooseColorTime", eventtime);
  }

  _recordeventtime() {
    int eventtime = DateTime.now().millisecondsSinceEpoch;
    Dateconvert.storedifftime("EventTime", eventtime);
  }

  _recordchangetime() {
    int eventtime = DateTime.now().millisecondsSinceEpoch;
    Dateconvert.storedifftime("StatusChangeTime", eventtime);
  }

  _uploadtimestamp1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int choosecolortime = prefs.getInt("ChooseColorTime");
    int submittime = prefs.getInt("SubmitTime");
    int receipttime = prefs.getInt("ReceiptTime");
    ConnectData.uploadtimestamp1(choosecolortime, submittime, receipttime);
  }

  _uploadtimestamp2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int eventtime = prefs.getInt("EventTime");
    int changetime = prefs.getInt("StatusChangeTime");
    ConnectData.uploadtimestamp2(eventtime, changetime);
  }

  _readlogs() async {
    blockstimestamp = await ConnectData.getblocklog();
    transactionstimestamp = await ConnectData.gettransactionlog();
    _uploadtimestamp2();
    print(blockstimestamp.length);
    print(transactionstimestamp.length);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => new GenerateTimelinePage(
              blockstimestamp: blockstimestamp,
              transactionstimestamp: transactionstimestamp,
            )));
    // List<Transactionlog> transactions = await ConnectData.gettransactionlog();
  }

  _listenevent() async {
    network = await SharedData.getNetwork();
    DeployedContract contract;
    var apiUrl = Web3P.serverAddress;
    if (network == "Private") {
      contract = await Web3P.deployedcontract();
      String serveraddress = await SharedData.getServerAddress();
      if (serveraddress.length > 5) {
        apiUrl = serveraddress;
      }
      client = Web3Client(apiUrl, Client());
      final colorChangeEvent = contract.event('ColorChange');
      subscription = client
          .events(
              FilterOptions.events(contract: contract, event: colorChangeEvent))
          .take(50)
          .listen((event) {
        _recordeventtime();
        final decoded =
            colorChangeEvent.decodeResults(event.topics, event.data);

        final deviceid = decoded[0] as String;
        final red = decoded[1] as BigInt;
        final green = decoded[2] as BigInt;
        final blue = decoded[3] as BigInt;
        final blocktime = decoded[4] as BigInt;
        print("event:ID:$deviceid");
        print("event:red:${red.toInt()}");
        print("event:green:${green.toInt()}");
        print("event:blue:${blue.toInt()}");
        print("event:blocktime:${blocktime.toInt()}");
        var curid = widget.curdevice.bid.toInt().toString();
        if (deviceid.contains(curid)) {
          _recordchangetime();
          print("this device changed!");
          var devcolor =
              TransColor.trancolor(red.toInt(), green.toInt(), blue.toInt());
          // print(widget.curdevice.green);
          if (mounted) {
            setState(() {
              currentColor = Color(devcolor);
            });
          }
          Event.eventBus.fire(new DeviceAdd(curdevices.name));
          if (!isController) {
            Future.delayed(new Duration(seconds: 1), () {
              globalKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Generating Timeline now!"),
              ));
              Future.delayed(new Duration(seconds: 2), () {
                _readlogs();
              });
            });
          }
        }
      });
      await subscription.asFuture();
    } else if (network == "Public") {
      print("Listening to public");
      var httpUrl =
          "https://ropsten.infura.io/v3/4164c4424c7d465daab94864544fa622"; //Ropsten

      var wsUrl =
          "wss://ropsten.infura.io/ws/v3/4164c4424c7d465daab94864544fa622"; //Ropsten
      contract = await Web3.deployedcontract();
      final client = Web3Client(httpUrl, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(wsUrl).cast<String>();
      });
      final colorChangeEvent = contract.event('ColorChange');
      subscription = client
          .events(
              FilterOptions.events(contract: contract, event: colorChangeEvent))
          .take(5)
          .listen((event) {
        final decoded =
            colorChangeEvent.decodeResults(event.topics, event.data);

        final deviceid = decoded[0] as String;
        final red = decoded[1] as BigInt;
        final green = decoded[2] as BigInt;
        final blue = decoded[3] as BigInt;
        print("event:ID:$deviceid");
        print("event:red:${red.toInt()}");
        print("event:green:${green.toInt()}");
        print("event:blue:${blue.toInt()}");
        var curid = widget.curdevice.bid.toInt().toString();
        if (deviceid.contains(curid)) {
          print("this device changed!");
          var devcolor =
              TransColor.trancolor(red.toInt(), green.toInt(), blue.toInt());
          // print(widget.curdevice.green);
          if (mounted) {
            setState(() {
              currentColor = Color(devcolor);
            });
          }
          Event.eventBus.fire(new DeviceAdd(curdevices.name));
        }
      });
      await subscription.asFuture();
    }
  }

  _webchangecolor() async {
    RGB color = TransColor.trancolortorgb(currentColor.toString());
    bool res;
    if (network == "Private") {
      res = await Web3P.web3changedevicecolor(curdevices.bid, color);
    } else {
      res = await Web3.web3changedevicecolor(curdevices.bid, color);
    }

    if (res == true) {
      if (isController) {
        _uploadtimestamp1();
      }

      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Change the color successfully!"),
      ));

      // Event.eventBus.fire(new DeviceAdd(curdevices.name));
    } else {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Something wrong!"),
      ));
    }
  }

  _fetchdevicestatus() {
    var devcolor = TransColor.trancolor(widget.curdevice.red.toInt(),
        widget.curdevice.green.toInt(), widget.curdevice.blue.toInt());
    if (mounted) {
      setState(() {
        curdevices = widget.curdevice;
        currentColor = Color(devcolor);
      });
    }
    print("ID is ${widget.curdevice.bid}");
  }

  TextEditingController namecontroller = new TextEditingController(text: "");
  TextEditingController descontroller = new TextEditingController(text: "");
  TextEditingController deviceidcontroller =
      new TextEditingController(text: "");
  bool light = false;
  bool added = true;

  void _adddevice() async {
    setState(() {
      added = false;
    });
    String network = await SharedData.getNetwork();
    String res;
    String res2;
    if (network == "Private") {
      res = await Web3P.web3adddevice(namecontroller.text, descontroller.text);
      res2 = await Web3.web3adddevice(namecontroller.text, descontroller.text);
    } else if (network == "Public") {
      res2 = await Web3.web3adddevice(namecontroller.text, descontroller.text);
    }

    if (res == "success" || res2 == "success") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Added successfully!"),
      ));
      print("added successfully");

      Future.delayed(new Duration(seconds: 2), () {
        setState(() {
          added = true;
        });
        // Event.eventBus.fire(new DeviceAdd(namecontroller.text));
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new LightsHomePage();
          },
        ), (route) => route == null);
      });
    } else {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Something wrong!"),
      ));
    }
  }

  @override
  void initState() {
    _fetchdevicestatus();
    _listenevent();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    client.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return new Container(
      color: Colors.lightGreen[200], //Color(0xFFA4B4A9)
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: globalKey,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                  child: Image.asset(
                "assets/img/homelight.png",
                width: mediaQueryData.size.width,
              )),
            ),
            Positioned(
              top: 240,
              left: 25,
              right: 25,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.chevron_left,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Light Detail",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (BuildContext context) =>
                            //         new ChangeServerPage(
                            //           img: accountjson,
                            //         )));
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                          width: mediaQueryData.size.width * 8 / 10,
                          height: 340,
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        "Light Name:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 30.0),
                                      child: Text(
                                        curdevices.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        "Light Description:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 30.0),
                                      child: Text(
                                        curdevices.description,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        "Current Color:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 30.0),
                                      child: Text(
                                        "Tap to change color",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Select a color'),
                                              content: SingleChildScrollView(
                                                child: BlockPicker(
                                                  pickerColor: currentColor,
                                                  onColorChanged:
                                                      changeColorAndPopout,
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: 150.0,
                                      height: 150.0,
                                      // padding: const EdgeInsets.all(
                                      //     20.0), //I used some padding without fixed width and height
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentColor,
                                      ),
                                      child: new Text("",
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 50.0)),
                                    ),
                                  ),
                                ), //
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Is Controller?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Switch(
                                      value: isController,
                                      onChanged: (value) {
                                        setState(() {
                                          isController = value;
                                          print(isController);
                                        });
                                      },
                                      activeTrackColor: Colors.lightGreenAccent,
                                      activeColor: Colors.green,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                    added
                        ? Container(
                            height: 70.0,
                          )
                        : Container(
                            height: 70.0,
                            child: Column(
                              children: <Widget>[
                                SpinKitFadingCircle(
                                  itemBuilder: (_, int index) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: index.isEven
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    );
                                  },
                                ),
                                Text("Adding new device"),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   right: 40,
            //   bottom: 10,
            //   child: InkWell(
            //     onTap: () {
            //       _adddevice();
            //       // Navigator.of(context).push(MaterialPageRoute(
            //       //     builder: (BuildContext context) => new LightDetailPage()));
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.all(8),
            //       child: Container(
            //         width: 80,
            //         height: 35,
            //         decoration: BoxDecoration(
            //             color: Color(0xFFFF9B52),
            //             borderRadius: BorderRadius.circular(8)),
            //         child: Row(
            //           children: <Widget>[
            //             Padding(
            //               padding: EdgeInsets.only(left: 10),
            //             ),
            //             Container(
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 border: Border.all(color: Colors.white, width: 2),
            //               ),
            //               child: Icon(
            //                 Icons.check,
            //                 color: Colors.white,
            //                 size: 16,
            //               ),
            //             ),
            //             SizedBox(
            //               width: 8,
            //             ),
            //             Text(
            //               "Add",
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 22,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
