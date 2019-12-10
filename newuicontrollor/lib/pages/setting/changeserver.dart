import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newuicontrollor/class/event.dart';
import 'package:newuicontrollor/class/shareddata.dart';
import 'package:newuicontrollor/web3/web3.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ChangeServerPage extends StatefulWidget {
  // String img;
  // ChangeServerPage({Key key, @required this.img}) : super(key: key);

  @override
  _ChangeServerPageState createState() => _ChangeServerPageState();
}

class _ChangeServerPageState extends State<ChangeServerPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController homeservercontroller =
      new TextEditingController(text: "");
  TextEditingController publicservercontroller =
      new TextEditingController(text: "");
  TextEditingController privatekeycontroller =
      new TextEditingController(text: "");

  void _getserver() async {
    var address = await SharedData.getServerAddress();

    if (address != null) {
      if (mounted) {
        setState(() {
          homeservercontroller.text = address;
        });
      }
    }
  }

  void _changeserver() async {
    var res = await SharedData.saveServerAddress(homeservercontroller.text);

    if (res == "success") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Changed successfully!"),
      ));
      Event.eventBus.fire(new ServerChanged("change server"));
      Future.delayed(new Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    _getserver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("Change Server"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Settings',
            onPressed: () {
              _changeserver();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: homeservercontroller,
                    enabled: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "In-house Server",
                      labelStyle: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 0.3,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    controller: publicservercontroller,
                    enabled: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "Public Server",
                      labelStyle: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 0.3,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    controller: privatekeycontroller,
                    enabled: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "Private Key",
                      labelStyle: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 0.3,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Text("Please scan the QR code when control this device"),
                  // CachedNetworkImage(
                  //   imageUrl: widget.img,
                  //   height: 200.0,
                  //   width: 200.0,
                  //   fit: BoxFit.cover,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeserver,
        tooltip: 'Increment',
        child: Icon(Icons.check),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
