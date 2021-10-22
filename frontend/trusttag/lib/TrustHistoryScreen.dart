import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TrustHistoryScreen extends StatefulWidget {
  static const routeName = "/trustHistoryScreen";

  @override
  _TrustHistoryScreenState createState() => _TrustHistoryScreenState();
}

class _TrustHistoryScreenState extends State<TrustHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final tagData = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Color.fromRGBO(50, 50, 50, 1),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          'TrustTag ${tagData['tagId']}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: getTagHistory(tagData['tagId']),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                    child: Text(
                  'Fetching history from HCS...',
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ));
              }
              if (snapshot.data['result'] == false) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 60.0,
                      right: 60.0,
                      top: 0,
                    ),
                    child: Text(
                      'No history for the tag found',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                  ),
                );
              }
              if (snapshot.data['result'] == true &&
                  snapshot.data['dataLedger'].length == 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 60.0,
                      right: 60.0,
                      top: 0,
                    ),
                    child: Text(
                      'No history for the tag found',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data['dataLedger'].length,
                  itemBuilder: (context, index) {
                    String key =
                        snapshot.data['dataLedger'].keys.elementAt(index);
                    return new Column(
                      children: <Widget>[
                        new ListTile(
                          subtitle: new Text(
                            "$key",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                            ),
                          ),
                          title: new Text(
                            "${snapshot.data['dataLedger'][key]}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        new Divider(
                          height: 2.0,
                          color: Colors.white,
                        ),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}

// Get all the history of a tag

Future<dynamic> getTagHistory(String tagId) async {
  var request = http.Request(
      'GET', Uri.parse('http://3.135.1.141:8888/api/getTagData/' + tagId));

  http.StreamedResponse response = await request.send();

  return await jsonDecode(await response.stream.bytesToString());
}
