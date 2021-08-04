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

class ControllerAppMain extends State<ControllerApp> {
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
          child: IconButton(
              onPressed: movement("1"),
              icon: const Icon(Icons.arrow_drop_up)), //pano
          top: 10,
          left: 80,
        ),
        Positioned(
          child: IconButton(
              onPressed: movement("2"),
              icon: const Icon(Icons.arrow_drop_down)), //kato
          bottom: 10,
          left: 80,
        ),
        Positioned(
          child: IconButton(
              onPressed: movement("3"),
              icon: const Icon(Icons.arrow_left_sharp)), //aristera
          top: 80,
          left: 10,
        ),
        Positioned(
          child: IconButton(
              onPressed: movement("4"),
              icon: const Icon(Icons.arrow_right)), //deksia
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

  //sends
  void sendMessage(String movement) async {
    BluetoothConnection? connection;
    final TextEditingController textEditingController =
        new TextEditingController();
    textEditingController.clear();

    if (movement.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(movement)));
        await connection!.output.allSent;
      } catch (e) {
        //notify state
        setState(() {});
      }
    }
  }

  //movement den ksero akoma ama doulebei sosta 8elei tests
  movement(var mov) {
    switch (mov) {
      case 1:
        () => sendMessage("F");
        break;
      case 2:
        () => sendMessage("B");
        break;
      case 3:
        () => sendMessage("L");
        break;
      case 4:
        () => sendMessage("R");
        break;
      default:
        () => sendMessage("Stop");
    }
  }
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
