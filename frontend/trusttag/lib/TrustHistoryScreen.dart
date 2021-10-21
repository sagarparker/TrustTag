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
    print(tagData);
    print(tagData);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'TrustTag history',
          style: TextStyle(
            color: Color.fromRGBO(19, 120, 255, 1),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: FutureBuilder(
            future: getTagHistory(tagData['tagId']),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(child: Text('Fetching history from HCS...'));
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
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }
              if (snapshot.data['result'] == true &&
                  snapshot.data['msgs'].length == 0) {
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
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }
              print(snapshot.data['msgs']);
              return ListView.builder(
                  itemCount: snapshot.data['msgs'].length,
                  itemBuilder: (context, index) {
                    String key = snapshot.data['msgs'].keys.elementAt(index);
                    return new Column(
                      children: <Widget>[
                        new ListTile(
                          subtitle: new Text(
                            "$key",
                            style: TextStyle(fontSize: 10),
                          ),
                          title: new Text(
                            "${snapshot.data['msgs'][key]}",
                          ),
                        ),
                        new Divider(
                          height: 2.0,
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
