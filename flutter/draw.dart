import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';

//otan bazeis px: int? something; dhloneis pos to something mporei na einai nullable
//required shmainei pos h metablhth prepei na mhn einai null
//to slider den doulebei kala
class Draw extends StatefulWidget {
  //final BluetoothDevice server;

  // const Draw({required this.server});

  @override
  DrawMain createState() => new DrawMain();
}

class Widthpaint {
  Offset cords;
  Paint stroke;

  Widthpaint({required this.cords, required this.stroke});
}

class DrawMain extends State<Draw> {
  List<Widthpaint> cords = [];
  late double strokeWidth;
  @override
  void initState() {
    super.initState();
    strokeWidth = 2.0;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; //kanto kai sto gamepad
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: <Widget>[
          Center(
              child: Column(
            //oste o pinakas na einai kentro
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                      //anixneuei input pandown click update drag
                      child: GestureDetector(
                        onPanDown: (details) {
                          this.setState(() {
                            cords.add(Widthpaint(
                                cords: details.localPosition,
                                stroke: Paint()..strokeWidth = strokeWidth));
                          });
                        },
                        onPanUpdate: (details) {
                          this.setState(() {
                            cords.add(Widthpaint(
                                cords: details.localPosition,
                                stroke: Paint()..strokeWidth = strokeWidth));
                          });
                        },
                        onPanEnd: (details) {
                          this.setState(() {
                            // cords.add(details);
                            print("mesa end");
                          });
                        },
                        child: SizedBox.expand(
                            child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: CustomPaint(
                            painter: Painte(cords: cords),
                          ),
                        )),
                      ))),
              //container gia to slider isos to sbhso giati apla ta gama alla 8a krathso to cleaner
              Container(
                width: width * 0.80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Slider(
                        min: 1.0,
                        max: 10.0,
                        label: "Stroke $strokeWidth",
                        value: strokeWidth,
                        onChanged: (double value) {
                          this.setState(() {
                            strokeWidth = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.cleaning_services,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          this.setState(() {
                            cords.clear();
                          });
                        }),
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}

//h class gia zografikh
class Painte extends CustomPainter {
  List<Widthpaint> cords;
  Painte({required this.cords});
  @override
  void paint(Canvas canvas, Size size) {
    print("fuck");
    Paint background = Paint()..color = Colors.white; //fucking 2 telitses
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);
    Paint paint = Paint();
    paint.color = Colors.black54;
    paint.strokeWidth = 4.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;
    //logika kapou edo einai to bug
    for (int i = 0; i < cords.length - 1; i++) {
      if (cords[i] != null && cords[i + 1] != null) {
        canvas.drawLine(cords[i].cords, cords[i + 1].cords, paint);
      } else if (cords[i] != null && cords[i + 1] == null) {
        print("fuck");
        canvas.drawPoints(PointMode.points, [cords[i].cords], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Painte oldDelegate) {
    return true;
  }
}
