import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:async';

Map _data;
List _features;
void main() async {
  _data = await getQuakes();
  _features = _data["features"];
  //print("_${data["features"][0]["properties"]}");
  runApp(new MaterialApp(title: "quakes", home: new Quakes()));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Quakes"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _features.length,
            padding: EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              var date = new DateTime.fromMicrosecondsSinceEpoch(
                  _features[position]["properties"]["time"] * 1000,
                  isUtc: true,);
              return Column(
                children: <Widget>[
                  Divider(
                    height: 16.0,
                    color: Colors.purple,
                  ),
                  ListTile(
                    title: Text(
                      "At: $date",
                      style: TextStyle(
                          fontSize: 19.5,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle:
                        Text("${_features[position]["properties"]["place"]}"),
                    leading: CircleAvatar(
                      child: new Text(
                          "${_features[position]["properties"]["mag"]}"),
                      backgroundColor: Colors.greenAccent,
                    ),
                    onTap: () => showmessage(context, position),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

  void showmessage(BuildContext context, int position) {
    var alert = new AlertDialog(
      title: Text("${_features[position]["properties"]["mag"]}"),
      actions: <Widget>[
        FlatButton(
          child: Text("ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
}

Future<Map> getQuakes() async {
  String apiurl ="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiurl);
  return json.decode(response.body);
}
