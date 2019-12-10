import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newuicontrollor/class/shareddata.dart';
import 'package:newuicontrollor/web3/web3.dart';
import 'package:newuicontrollor/web3/web3p.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'lights.dart';

var images = ["assets/img/light.png", "assets/img/light.png"];
var title = ["Lights", "Smart Tv"];

class AddLightPage extends StatefulWidget {
  @override
  _AddLightPageState createState() => _AddLightPageState();
}

class _AddLightPageState extends State<AddLightPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
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
    super.initState();
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
                          "Add a new light",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(),
                        // IconButton(
                        //   icon:
                        //       Icon(Icons.settings, color: Colors.white, size: 30),
                        //   onPressed: () {
                        //     // Navigator.of(context).push(MaterialPageRoute(
                        //     //     builder: (BuildContext context) =>
                        //     //         new ChangeServerPage(
                        //     //           img: accountjson,
                        //     //         )));
                        //   },
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                          width: mediaQueryData.size.width * 8 / 10,
                          height: 180,
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: namecontroller,
                                  enabled: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.lightGreen),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    labelText: "Device Name",
                                    labelStyle: TextStyle(
                                        fontSize: 18.0,
                                        letterSpacing: 0.3,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                TextFormField(
                                  controller: descontroller,
                                  enabled: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.lightGreen),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    labelText: "Device Description",
                                    labelStyle: TextStyle(
                                      fontSize: 18.0,
                                      letterSpacing: 0.3,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
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
            Positioned(
              right: 40,
              bottom: 10,
              child: InkWell(
                onTap: () {
                  _adddevice();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => new AddLightPage()));
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Color(0xFFFF9B52),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
