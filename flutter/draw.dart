import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';

class Draw extends StatefulWidget {
  //final BluetoothDevice server;

  // const Draw({required this.server});

  @override
  DrawMain createState() => new DrawMain();
}

class DrawMain extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; //kanto kai sto gamepad
    double height = MediaQuery.of(context).size.height;
    List cords = [
      0,
      0
    ]; //wrong list class too tired to give a shit List<offset> is propably the best but null safety gamietai apo ena kopadi pi8ikon
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: <Widget>[
          Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.9,
                height: height * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 1)
                    ]),
                child: GestureDetector(
                    onPanDown: (details) {
                      this.setState(() {
                        cords.add(details.localPosition);
                        print(details.localPosition);
                      });
                    },
                    onPanUpdate: (details) {
                      this.setState(() {
                        cords.add(details.localPosition);
                      });
                    },
                    onPanEnd: (details) {
                      this.setState(() {
                        cords.add(null);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: CustomPaint(painter: Painte(cords: cords)),
                    )),
              )
            ],
          )),
        ],
      ),
    );
  }
}

class Painte extends CustomPainter {
  List cords;
  Painte({required this.cords});
  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white; //fucking 2 telitses
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    Paint paint = Paint();
    paint.color = Colors.black54;
    paint.strokeWidth = 4;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;
    //print(cords.length);
    for (int i = 0; i < cords.length; i++) {
      canvas.drawLine(cords[i], cords[i + 1], paint);
      print("fuck");
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
