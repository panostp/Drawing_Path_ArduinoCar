import 'package:firstapp/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'controllerapp.dart';
//import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import './connect.dart';

//apps index
//skip einai mia olohdia class me thn homepage alla den kanei tipota isos na thn bgaloume thn kratao gia test
//ostoso den mporeis na anikseis to homepage xoris sundesh bluetooth
//ama 8es na dokimaseis bgale tis protes duo lines tou homepage kai phgaine sto main kai sbhse thn metablith server pou leei to sfalma
//logika 8a prepei na kaneis to idio kai sto controllerapp
class Skip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      padding: EdgeInsets.all(0.0),
    );
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('KGL APP',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ),
        //Divider(),
        body: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //8elo na ftiakso ligo to position apo ta koumpia sunolika 8a mpoun guro sta 4
            Positioned(
              top: 50,
              child: IconButton(
                  icon: const Icon(Icons.gamepad),
                  iconSize: 50,
                  onPressed: () {
                    var alert = AlertDialog(
                      title: Text("Bluetooth not detected"),
                      content:
                          Text("You need a bleutooth connection to continue"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"))
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }),
            ),
            // Spacer(),
            Positioned(
              top: 1000,
              child: IconButton(
                onPressed: () {
                  var alert = AlertDialog(
                    title: Text("Bluetooth not detected"),
                    content:
                        Text("You need a bleutooth connection to continue"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"))
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                icon: const Icon(Icons.border_color),
                iconSize: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  final BluetoothDevice server;

  Homepage({required this.server});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('KGL APP',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ),
        //Divider(),
        body: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Positioned(
              top: 50,
              child: IconButton(
                  icon: const Icon(Icons.gamepad),
                  iconSize: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ControllerApp(server: server)),
                    );
                  }),
            ),
            // Spacer(),
            Positioned(
              top: 1000,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Draw(server: server)),
                  );
                },
                icon: const Icon(Icons.history_edu_rounded),
                iconSize: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    padding: EdgeInsets.all(0.0),
  );
}
