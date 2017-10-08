import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => new HomePageState();

}

class HomePageState extends State<HomePage> {

  List data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.coinmarketcap.com/v1/ticker/"),
        headers: {
          "Accept": "application/json"
        }
    );

    this.setState(() {
      data = JSON.decode(response.body);
    });
    print(data[1]["name"]);

    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  TextStyle isRaised(String priceChange) {
    if(priceChange.substring(0, 1) == "-") {
      return new TextStyle(color: Colors.red);
    } else {
      return new TextStyle(color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("CryptoMarket"),
        centerTitle: true,
      ),
      body: new ListView.builder(
        addAutomaticKeepAlives: true,
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: new Image(
                      image: new NetworkImage("https://files.coinmarketcap.com/static/img/coins/32x32/"+data[index]["name"].toString().toLowerCase().replaceAll(" ", "-")+".png", scale: 1.0)
                  ),
                  title: new Text(
                    data[index]["rank"] + ". " + data[index]["name"],
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: new Container(
                    child: new Row(
                      children: <Widget>[
                        new Text(
                          "percent change 1h : ",
                          overflow: TextOverflow.ellipsis,
                        ),
                        new Text(
                          data[index]["percent_change_1h"] + "%",
                          style: isRaised(data[index]["percent_change_1h"]),
                        )
                      ],
                    ),
                  ),
                ),
                new ButtonTheme.bar( // make buttons use the appropriate styles for cards
                  child: new ButtonBar(
                    children: <Widget>[
                      new MaterialButton(
                        child: const Text('INFO'),
                        onPressed: () { /* ... */ },
                      ),
                      new MaterialButton(
                        child: const Text('FORECAST'),
                        onPressed: () { /* ... */ },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}