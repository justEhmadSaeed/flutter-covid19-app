import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

void main() => runApp(new MaterialApp(
      darkTheme: ThemeData.dark(),
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

List finalData = List();

class HomePageState extends State<HomePage> {
  Future<List> getJsonData() async {
    var data = await http.get("https://corona.lmao.ninja/v2/all");
    var dataDecoded = json.decode(data.body);

    dataDecoded['updated'] = timeago
        .format(DateTime.fromMillisecondsSinceEpoch(dataDecoded['updated']));
    var keyList = dataDecoded.keys.toList();
    var valueList = dataDecoded.values.toList();

    for (int i = 0; i < keyList.length; ++i) {
      finalData.add(
          '${keyList[i][0].toUpperCase()}${keyList[i].substring(1)} : ${valueList[i]}');
    }

    return finalData;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor: Colors.grey[900],
      appBar: new AppBar(
        title: new Text("Coco Corona"),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FutureBuilder(
          future: getJsonData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: finalData == null ? 0 : finalData.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    child: new Center(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Card(
                            child: Container(
                                child: Text(
                                  finalData[index],
                                  style: TextStyle(
                                      // color: Colors.white,
                                      fontSize: 20.0),
                                ),
                                padding: const EdgeInsets.all(20.0)),
                            // color: Colors.grey[800],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              // Loading circular Progress
              return Align(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
