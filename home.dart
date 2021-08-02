import 'dart:html';
import 'package:flutter/material.dart';
//import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import './connect.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('KGL APP',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
          ),
          body: Stack(children: <Widget>[
            new ElevatedButton(
              child: new Text("Controller"),
              style: style,
              onPressed: null,
            ),
          ])),
    );
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    padding: EdgeInsets.all(0.0),
  );
}
