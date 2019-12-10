import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newuicontrollor/class/serverapi.dart';
import 'package:newuicontrollor/class/shareddata.dart';
import 'package:newuicontrollor/class/writefile.dart';
import 'package:newuicontrollor/pages/devices/lights.dart';
import 'package:newuicontrollor/pages/login/password.dart';
import 'package:http/http.dart' as http;

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  bool loaded = true;
  bool success = false;
  TextEditingController addresscontroller = new TextEditingController(text: "");

  Future<void> _scanBarcodeaddress() async {
    String _barcode;
    try {
      _barcode = await BarcodeScanner.scan();
      print(_barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _barcode = 'FThe user did not grant the camera permission!';
      } else {
        _barcode = 'Unknown error: $e';
      }
    } on FormatException {
      _barcode =
          'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      _barcode = 'Unknown error: $e';
    }
    if (_barcode.contains("http")) {
      setState(() {
        addresscontroller.text = _barcode;
      });
      _fetchdata();
    }
  }

  _fetchdata() async {
    print("Fetching data from server");
    setState(() {
      loaded = false;
    });
    String res;
    // int ippos = addresscontroller.text.indexOf("://");
    // int iplast = addresscontroller.text.lastIndexOf(":");
    // String ip = addresscontroller.text.substring(ippos + 3, iplast);
    String ip = addresscontroller.text;
    print(ip);
    List<ServerAPI> list = List();
    ServerAPI serverdata = new ServerAPI();
    try {
      final response = await http
          .get("http://$ip:3000/json/Contract.json")
          .timeout(Duration(seconds: 5));
      // print(response.body.toString());
      int po = response.body.toString().indexOf(":");
      int polast = response.body.toString().lastIndexOf('"');
      String contractaddress =
          response.body.toString().substring(po + 2, polast);
      SharedData.setContractAddress(contractaddress);
      print(contractaddress);
      final chainidres = await http
          .get("http://$ip:3000/json/ChainID.json")
          .timeout(Duration(seconds: 5));
      int chainid = int.parse(chainidres.body.toString());
      print(chainid);
      SharedData.setChainID(chainid);

      final privatekeyres = await http
          .get("http://$ip:3000/json/privatekey.json")
          .timeout(Duration(seconds: 5));
      String privatekey =
          privatekeyres.body.substring(1, privatekeyres.body.length - 1);
      print(privatekey);
      SharedData.setPrivateKey(privatekey);

      File abifile = await WriteFlie.downloadABIFile(
          "http://$ip:3000/json/abi.json", "abi.json");
      File keystorefile = await WriteFlie.downloadKeystoreFile(
          "http://$ip:3000/json/keystore.json", "keystore.json");
      success = true;

      // res = response.body.toString();
      // print(res.length);
      // int firstk = res.indexOf("[");
      // int lastk = res.lastIndexOf("]");
      // print(lastk);
      // String abi = res.substring(firstk,lastk+1);
      // print(abi.length);
      // print(abi);

    } on SocketException {
      print("error");
    } on TimeoutException {
      print("timeout");
    }
    // print(serverdata);
    if (success) {
      Future.delayed(new Duration(seconds: 1), () {
        if (success) {
          globalKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Download data successfully"),
          ));
          Future.delayed(new Duration(seconds: 1), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new LightsHomePage()));
          });
        }
      });
    } else {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Private Contract can not be connected"),
      ));
      Future.delayed(new Duration(seconds: 1), () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => new LightsHomePage()));
      });
    }
  }

  _fetchserver() async {
    String ip = await SharedData.getServerIP();
    if (ip != null) {
      setState(() {
        addresscontroller.text = ip;
      });
    }
  }

  @override
  void initState() {
    _fetchserver();
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
                        height: 300.0,
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
                                  "Input the Home server address:",
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
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0),
                                child: TextFormField(
                                  controller: addresscontroller,
                                  enabled: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: "Home server Address",
                                    labelStyle: TextStyle(
                                        fontSize: 18.0,
                                        letterSpacing: 0.3,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  keyboardType: TextInputType.text,
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                if (addresscontroller.text.length < 4) {
                  _scanBarcodeaddress();
                } else {
                  SharedData.saveServerIP(addresscontroller.text);
                  SharedData.saveServerAddress(
                      'http://' + addresscontroller.text + ':8545');
                  SharedData.saveServerAddressWS(
                      'ws://' + addresscontroller.text + ':8546');
                  _fetchdata();
                  Future.delayed(new Duration(seconds: 1), () {
                    if (success) {
                      globalKey.currentState.showSnackBar(new SnackBar(
                        content: new Text("Download data successfully"),
                      ));
                      // Future.delayed(new Duration(seconds: 1), () {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (BuildContext context) =>
                      //           new LightsHomePage()));
                      // });
                    }
                  });
                }
              },
              tooltip: 'Scan Address',
              child: Icon(Icons.navigate_next),
            ),
            // FloatingActionButton(
            //   onPressed: () {
            //     if (addresscontroller.text.length > 10) {
            //       SharedData.saveServerAddress(addresscontroller.text);
            //       _fetchdata();
            //       Future.delayed(new Duration(seconds: 1), () {
            //         if (success) {
            //           globalKey.currentState.showSnackBar(new SnackBar(
            //             content: new Text("Download data successfully"),
            //           ));
            //           Future.delayed(new Duration(seconds: 1), () {
            //             Navigator.of(context).push(MaterialPageRoute(
            //                 builder: (BuildContext context) =>
            //                     new LightsHomePage()));
            //           });
            //         }
            //       });
            //     } else {
            //       globalKey.currentState.showSnackBar(new SnackBar(
            //         content: new Text("Please input the correct address"),
            //       ));
            //     }
            //   },
            //   tooltip: 'Next',
            //   child: Icon(Icons.keyboard_arrow_right),
            // ),
          ],
        ));
  }
}
