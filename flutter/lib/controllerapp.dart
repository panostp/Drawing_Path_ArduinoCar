import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'chatpage.dart';

// to BluetoothDevice server deixnei to device name kai alla stoixia gia connection
//opote ka8e file pou xreiazetai gia sundesh to 8elei
//ama 8es na to deis bgale thn class controllerapp kai allakse to class ths
// "class ControllerAppMain extends State<ControllerApp>"----->"class ControllerApp extends StatefulWidget"
//kai meta phgaine sto main kai ekei pou exei to sfalma bgale tis metablhtes se ControllerApp()
class ControllerApp extends StatefulWidget {
  final BluetoothDevice server;

  const ControllerApp({required this.server});

  @override
  ControllerAppMain createState() => new ControllerAppMain();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class ControllerAppMain extends State<ControllerApp> {
  //-----
  static final clientID = 0;
  BluetoothConnection? connection;
  bool pressed = false;
  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  //-----
  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget outside = new Container(
      //gamo thn flutter
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        color: Colors.black38,
        shape: BoxShape.circle,
      ),
    );
    Widget inside = new Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
    return new Material(
      color: Colors.white,
      child: Center(
          child: Stack(children: <Widget>[
        outside,
        Positioned(
          child: GestureDetector(
            child: Icon(Icons.arrow_drop_up),
            onTap: () {
              sendMessage("F");
            },
            onLongPressStart: (details) async {
              pressed = true;
              do {
                sendMessage("F");
                await Future.delayed(Duration(microseconds: 50));
              } while (pressed);
            },
            onLongPressEnd: (details) {
              setState(() {
                pressed = false;
              });
            },
          ), //pano
          top: 10,
          left: 80,
        ),
        Positioned(
          child: GestureDetector(
            child: Icon(Icons.arrow_drop_down),
            onTap: () {
              sendMessage("B");
            },
            onLongPressStart: (details) async {
              pressed = true;
              do {
                sendMessage("B");
                await Future.delayed(Duration(microseconds: 50));
              } while (pressed);
            },
            onLongPressEnd: (details) {
              setState(() {
                pressed = false;
              });
            },
          ), //kato
          bottom: 10,
          left: 80,
        ),
        Positioned(
          child: GestureDetector(
            child: Icon(Icons.arrow_left_sharp),
            onTap: () {
              sendMessage("L");
            },
            onLongPressStart: (details) async {
              pressed = true;
              do {
                sendMessage("L");
                await Future.delayed(Duration(microseconds: 50));
              } while (pressed);
            },
            onLongPressEnd: (details) {
              setState(() {
                pressed = false;
              });
            },
          ), //aristera
          top: 80,
          left: 10,
        ),
        Positioned(
          child: GestureDetector(
            child: Icon(Icons.arrow_right_sharp),
            onTap: () {
              sendMessage("R");
            },
            onLongPressStart: (details) async {
              pressed = true;
              do {
                sendMessage("R");
                await Future.delayed(Duration(microseconds: 50));
              } while (pressed);
            },
            onLongPressEnd: (details) {
              setState(() {
                pressed = false;
              });
            },
          ), //deksia
          top: 80,
          right: 10,
        ),
        Positioned(
          child: inside,
          top: 70,
          left: 70,
        )
      ])),
    );
  }

  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  //sends
  //put it in the class to set state
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
        setState(() {});
      }
    }
  }

  /*movement(var mov) {
    switch (mov) {
      case 1:
        sendMessage("F");
        break;
      case 2:
        sendMessage("B");
        break;
      case 3:
        sendMessage("L");
        break;
      case 4:
        sendMessage("R");
        break;
    }
  }*/
}

class cirlce extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const cirlce({Key? key, required this.onTap, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.black,
        ),
      ),
    );
  }
}
