import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

void main() => runApp(new MaterialApp(
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  // APIService apiService = APIService();
  List data = [];
  final String url = "https://corona.lmao.ninja/all";

  @override
  void initState() {
    super.initState();
    this.getJsonData();
    // future = apiService.get(endpoint: '/fixtures', query: {"live": "all"});
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(url),
        // accept only json response
        headers: {"Accept": "application/json"});

    print(response.body);

    setState(() {
      Map convertToJson = json.decode(response.body);
      print(convertToJson);
      convertToJson.forEach((k, v) =>
          data.add('${k[0].toUpperCase()}${k.substring(1)}: ${k!='updated'? v.toString(): timeago.format(DateTime.fromMillisecondsSinceEpoch(v))}' ));
      print(data);
      // data = convertToJson['GET'];
    });
    final updateTime = DateTime.fromMillisecondsSinceEpoch(1585433840192);
    print(timeago.format(updateTime));
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Coco Corona"),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          print("{${data[index]}}");
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Card(
                    child: Container(
                        child: new Text(data[index].toString()),
                        padding: const EdgeInsets.all(20.0)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
