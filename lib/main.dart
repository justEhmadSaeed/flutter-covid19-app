import 'package:covid19_app/themes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'dark_theme.dart';

void main() => runApp(
      HomePage(),
    );

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

    finalData.clear();

    for (int i = 0; i < keyList.length; ++i) {
      finalData.add(
          '${keyList[i][0].toUpperCase()}${keyList[i].substring(1)} : ${valueList[i]}');
    }
    return finalData;
  }

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: Scaffold(
              // backgroundColor: Colors.grey[900],
              appBar: AppBar(
                actions: <Widget>[
                  Switch(
                      value: themeChangeProvider.darkTheme,
                      onChanged: (bool value) {
                        themeChangeProvider.darkTheme = value;
                      })
                ],
                title: Text(
                  "COCO CORONA",
                ),
                backgroundColor: themeChangeProvider.darkTheme
                    ? Color(0xff0E1D36)
                    : Color(0xFF808E98),
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
                          return Container(
                            child: Center(
                              child: Column(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('RESULTS UPDATING...'),
                            SizedBox(
                              height: 30
                            ),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
