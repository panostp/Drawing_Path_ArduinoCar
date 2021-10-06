///dart
import 'dart:async';

import 'package:firstapp/controllerapp.dart';

///flutter
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

///our stuff
//import 'package:scoped_model/scoped_model.dart';
import './device.dart';
//import './chatpage.dart';
import './connect.dart';
import './remote.dart';
import 'home.dart';

//---------------------------------------------------------start of the app
void main() => runApp(new FirstApp());
var enable = "Enable Bluetooth"; //for bluetooth state
BluetoothDevice? device = null;

class FirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        theme: ThemeData.dark());
  }
}

class MainPage extends StatefulWidget {
  @override
  Home createState() => new Home();
}

class Home extends State<MainPage> {
  @override
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;

  //@override keep
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
//adapter
    Future.doWhile(() async {
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      //address
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "First connect with the car",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        actions: [
          Opacity(
              opacity: penguinVis,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (penguin == 4) {
                        penguinVis = 1.0;
                      }
                    });
                    penguin++;
                  },
                  icon: Image.asset("assets/happy.png")))
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(title: const Text("General", style: TextStyle())),
            SwitchListTile(
              title: Text(enable),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                var alert = AlertDialog(
                  //might cause problems if so delete alert
                  title: Text("Bluetooth not detected"),
                  content:
                      Text("It seems your device does not support bleutooth"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                );
                if (_bluetoothState == BluetoothState.UNKNOWN) {
                  //enable = "Bluetooth not detected";
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                } else {
                  future() async {
                    if (value)
                      //enable = "Enable Bluetooth";
                      await FlutterBluetoothSerial.instance.requestEnable();
                    else
                      await FlutterBluetoothSerial.instance.requestDisable();
                    print(Text("Bluetooth disabled"));
                  }

                  future().then((_) {
                    setState(() {});
                  });
                }
              },
            ),
            ListTile(
              title: const Text("Bluetooth status"),
              subtitle: Text(_bluetoothState.toString()), //bale if
              trailing: ElevatedButton(
                child: const Text("Settings"),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            ListTile(
              title: const Text("Local adapter address"),
              subtitle: Text(_address),
            ),
            ListTile(
              title: const Text("Local adapter name"),
              subtitle: Text(_name),
              onLongPress: null,
            ),
            ListTile(
              title: _discoverableTimeoutSecondsLeft == 0
                  ? const Text("Discoverable")
                  : Text(
                      "Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
              subtitle: const Text("Test"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _discoverableTimeoutSecondsLeft != 0,
                    onChanged: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      print("Discoverable requested");
                      final int timeout = (await FlutterBluetoothSerial.instance
                          .requestDiscoverable(60))!;
                      if (timeout < 0) {
                        print("Discoverable mode denied");
                      } else {
                        print(
                            "Discoverable mode acquired for $timeout seconds");
                      }
                      setState(() {
                        _discoverableTimeoutTimer?.cancel();
                        _discoverableTimeoutSecondsLeft = timeout;
                        _discoverableTimeoutTimer =
                            Timer.periodic(Duration(seconds: 1), (Timer timer) {
                          setState(() {
                            if (_discoverableTimeoutSecondsLeft < 0) {
                              FlutterBluetoothSerial.instance.isDiscoverable
                                  .then((isDiscoverable) {
                                if (isDiscoverable ?? false) {
                                  print("Discoverable after timeout");
                                  _discoverableTimeoutSecondsLeft += 1;
                                }
                              });
                              timer.cancel();
                              _discoverableTimeoutSecondsLeft = 0;
                            } else {
                              _discoverableTimeoutSecondsLeft -= 1;
                            }
                          });
                        });
                      });
                    },
                  )
                ],
              ),
            ),
            Divider(),
            ListTile(title: const Text("Devices discovery and connection")),
            SwitchListTile(
              title: const Text("Auto-try specific pin when pairing"),
              subtitle: const Text("Pin 1234"),
              value: _autoAcceptPairingRequests,
              onChanged: (bool value) {
                setState(() {
                  _autoAcceptPairingRequests = value;
                });
                if (value) {
                  FlutterBluetoothSerial.instance.setPairingRequestHandler(
                      (BluetoothPairingRequest request) {
                    print("Trying to auto-pair with Pin 1234");
                    if (request.pairingVariant == PairingVariant.Pin) {
                      return Future.value("1234");
                    }
                    return Future.value(null);
                  });
                } else {
                  FlutterBluetoothSerial.instance
                      .setPairingRequestHandler(null);
                }
              },
            ),
            ListTile(
              title: ElevatedButton(
                  child: const Text("Explore discovered devices"),
                  onPressed: () async {
                    final BluetoothDevice? selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DiscoveryPage();
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print("Discovery : selected " + selectedDevice.address);
                    } else {
                      print("Discovery : no device selected");
                    }
                  }),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text("Connect to paired device"),
                onPressed: () async {
                  final BluetoothDevice? selectedDevice =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(checkAvailability: false);
                      },
                    ),
                  );

                  if (selectedDevice != null) {
                    print("Connect : selected " + selectedDevice.address);
                    startChat(context, selectedDevice);
                  } else {
                    print("Connect : no device selected");
                  }
                },
              ),
            ),
            Divider(),
            ListTile(
                title: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Skip()),
                      );
                    },
                    child: Text("Skip")))
          ],
        ),
      ),
    );
  }

  //otan sundaiete se petaei sto homepage mhn sbiseis ta alla
  startChat(BuildContext context, BluetoothDevice server) {
    //Navigator.of(context).push(
    //MaterialPageRoute(
    // builder: (context) {
    ControllerApp(server: server);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage(server: server)),
    );
    device = server;
    //  },
    //  ),
    //  );
  }

  //bleutooth blakies
  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      await _collectingTask!.start();
    } catch (ex) {
      _collectingTask?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error occured while connecting"),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
