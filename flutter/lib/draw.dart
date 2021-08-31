//import 'dart:ffi';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'dart:convert';

//otan bazeis px: int? something; dhloneis pos to something mporei na einai nullable
//required shmainei pos h metablhth prepei na mhn einai null
//to slider den doulebei kala
class Draw extends StatefulWidget {
  final BluetoothDevice server;

  const Draw({required this.server});

  @override
  DrawMain createState() => new DrawMain();
}

//class Widthpaint {
//  Offset cords;
//  Paint stroke;

// Widthpaint({required this.cords, required this.stroke});
//}

class DrawMain extends State<Draw> {
  List<Offset> cords = [];
  late double strokeWidth;
  @override
  void initState() {
    super.initState();
    strokeWidth = 1.0;
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
                      child: GestureDetector(
                        onPanDown: (details) {
                          this.setState(() {
                            cords.add(details.localPosition);
                          });
                        },
                        onPanUpdate: (details) {
                          this.setState(() {
                            this.setState(() {
                              cords.add(details.localPosition);
                            });
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

int forwardCounter = 0;
int turnleft = 0;
int turnright = 0;

//drawing class
class Painte extends CustomPainter {
  List<Offset> cords;
  Painte({required this.cords});
  double lastangle = -1.5707963267948966;
  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);
    Paint paint = Paint();
    paint.color = Colors.black54;
    paint.strokeWidth = 10.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;
    //logika kapou edo einai to bug
    //x,y
    int s = 0;
    int j = 100;
    for (int i = 0; i < cords.length - 1; i++) {
      if (cords[i] != null && cords[i + 1] != null) {
        canvas.drawLine(cords[i], cords[i + 1], paint);
        Offset line1 = cords[i];
        Offset line2 = cords[i + 1];
        if (j % 100 == 0) {
          // prinsome();
          offseTodouble(line1, line2);
        }
        j++;
      } else if (cords[i] != null && cords[i + 1] == null) {
        print("fuck");
        canvas.drawPoints(PointMode.points, [cords[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Painte oldDelegate) {
    return true;
  }

//line1
  double disY1 = 1;
  double disX1 = 1;
//line2
  double disY2 = 1;
  double disX2 = 1;

  void offseTodouble(line1, line2) {
    //Offset distance = line1 + line2;
    disY1 = line2.dy - line1.dy;
    disX1 = line2.dx - line1.dx;
    turn();
  }

  double get distance => sqrt(disX1 * disX2 + disY1 * disY2);
  //double get direction => atan2(disY1, disX1);

  double get angle => atan2(disY1, disX1);

  void prinsome() {
    //print(distance);
    print(angle);
  }

  void turn() {
    double currentAngle = angle;
    double currentDistance = distance;

    if (lastangle != currentAngle) {
      if (currentAngle < lastangle) {
        print("turn left!");
        forwardCounter = 0;
        turnleft++;
        if (turnleft > 3) {
           sendMessage("L");
          turnleft = 0;
        }
      } else if (currentAngle > lastangle) {
        forwardCounter = 0;
        print("turn right!");
        turnright++;
        if (turnright > 3) {
           sendMessage("R");
          turnright = 0;
        }
      }
    } else {
      forwardCounter++;
      print(forwardCounter);
    }
    lastangle = currentAngle;
    if (forwardCounter > 2) {
      //send command go forward
       sendMessage("F");
      forwardCounter = 0;
    }
  }
}

void sendMessage(String movement) async {
  BluetoothConnection? connection;
  final TextEditingController textEditingController =
      new TextEditingController();
  textEditingController.clear();

  if (movement.length > 0) {
    try {
      connection!.output.add(Uint8List.fromList(utf8.encode(movement)));
      await connection.output.allSent;
    } catch (e) {
      //notify state
      //setState(() {});
    }
  }
}
