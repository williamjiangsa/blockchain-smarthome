import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newuicontrollor/class/shareddata.dart';
import 'package:newuicontrollor/pages/login/password.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  bool scaned = false;
  String qr;
  bool camState = true;
  bool gotjson = false;
  _nextstep() {
    Future.delayed(new Duration(seconds: 1), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new PasswordPage()));
    });
  }

  _readFile() async{
    const account = './assets/abi/account.json';
    String accountJson = await rootBundle.loadString(account);
    if(accountJson != null){
      SharedData.saveAccountJson(accountJson);
    }
    setState(() {
      gotjson = true;
    });
    _nextstep();
  }

  @override
  void initState() {
    _readFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/0.jpg'), fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Color.fromRGBO(0, 0, 0, 0.3),
                Color.fromRGBO(0, 0, 0, 0.4)
              ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),

                    /// Text header "Welcome To" (Click to open code)
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 19.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Smart Home",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 35.0,
                        letterSpacing: 0.4,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    Container(
                      height: 400.0,
                      width: 300.0,
                      child: Card(
                        elevation: 5.0,
                        color: Colors.white24,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Scan the QR code on the device:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30.0),
                            ),
                            new Expanded(
                                child: camState
                                    ? new Center(
                                        child: new SizedBox(
                                          width: 300.0,
                                          height: 300.0,
                                          // child: new QrCamera(
                                          //   onError: (context, error) => Text(
                                          //         error.toString(),
                                          //         style: TextStyle(
                                          //             color: Colors.red),
                                          //       ),
                                          //   qrCodeCallback: (code) {
                                          //     //TODO: Judgement need to be modified
                                          //     if (code.length > 50)
                                          //       setState(() {
                                          //         camState = false;
                                          //         qr = code;
                                          //         scaned = true;
                                          //       });
                                          //     _nextstep();
                                          //   },
                                          //   child: new Container(
                                          //     decoration: new BoxDecoration(
                                          //       color: Colors.transparent,
                                          //       border: Border.all(
                                          //           color: Colors.orange,
                                          //           width: 10.0,
                                          //           style: BorderStyle.solid),
                                          //     ),
                                          //   ),
                                          // ),
                                        ),
                                      )
                                    : new Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 100.0,
                                          color: Colors.blue,
                                        ),
                                      )),
                            new Text("QRCODE: $qr"),
                            Padding(
                              padding: EdgeInsets.only(top: 40.0, left: 20.0),
                              child: scaned
                                  ? Text(
                                      "You are good to go!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19.0,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          camState = true;
                                        });
                                      },
                                      child: Text(
                                        "Click to Scan again",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 19.0,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (scaned) {
            _nextstep();
          } else {
            globalKey.currentState.showSnackBar(new SnackBar(
              content:
                  new Text("Please scan the QR code again"),
            ));
          }
        },
        tooltip: 'Next Step',
        child: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
