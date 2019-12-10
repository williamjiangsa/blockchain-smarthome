import 'package:flutter/material.dart';
import 'package:newuicontrollor/web3/web3p.dart';

class OutputPage extends StatefulWidget {
  // String img;
  // OutputPage({Key key, @required this.img}) : super(key: key);

  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  List<String> readtimes = new List();

  _getReadtimeRecord() async {
    List<String> readtimesnow = await Web3P.fetchReadtime();
    if (mounted) {
      setState(() {
        readtimes = readtimesnow;
      });
    }
  }

  @override
  void initState() {
    _getReadtimeRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("Records"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Settings',
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Text("Readtime records:"),
                Container(
                  height: 600,
                  width: 100,
                  child: ListView.builder(
                      itemCount: readtimes.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new Text(readtimes[index]);
                      }),
                )

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.check),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
