import 'package:flutter/material.dart';
import 'package:wifi_flutter/wifi_flutter.dart';

import 'Wifi.dart';

void main() => runApp(FlutterWifiIoT());

class FlutterWifiIoT extends StatefulWidget {
  @override
  _FlutterWifiIoTState createState() => _FlutterWifiIoTState();
}

class _FlutterWifiIoTState extends State<FlutterWifiIoT> {
  final String robotSSID = "MRobot_solar";
  final String robotPassword = "12345678";
  final String configPath = "/Config"; // Replace with your actual path
  static const _channelName = 'eng.smaho.com/android_wifi_info';
  Iterable<WifiNetwork>? _networks = [];
  String _wifiName = 'click button to get wifi ssid.';
  int level = 0;
  String _ip = 'click button to get ip.';
  List<WifiResult> ssidList = [];
  String ssid = '', password = '';

  String _currentSSID = "";
  String _ipAddress = "";

  @override
  initState() {
    super.initState();
    _scanWifiNetworks();
    loadData();
  }

  Future<void> _scanWifiNetworks() async {
    Iterable<WifiNetwork>? networks = await scanWifiNetworks();
    setState(() {
      _networks = networks;
    });
  }

  Future<Iterable<WifiNetwork>?> scanWifiNetworks() async {
    Iterable<WifiNetwork>? networks = [];

    try {
      networks = await WifiFlutter.wifiNetworks;
    } catch (e) {
      print('Error retrieving Wi-Fi networks: $e');
    }

    return networks;
  }

  // Future<void> _setupServer() async {
  //   // Get IP address of the hotspot
  //   var ipAddress = await WifiInfo().getWifiIP();
  //   setState(() {
  //     _ipAddress = ipAddress ?? "Unknown IP";
  //   });
  //
  //   // Start listening for incoming requests
  //   _startServer();
  // }
  //
  // Future<void> _startServer() async {
  //   // Create a simple HTTP server
  //   final server = await HttpServer.bind(
  //     InternetAddress.anyIPv4,
  //     9000, // Use any available port
  //   );
  //
  //   print('Server running on IP ${server.address.address}:${server.port}');
  //
  //   await for (HttpRequest request in server) {
  //     if (request.method == 'POST' && request.uri.path == configPath) {
  //       // Process the incoming configuration packet
  //       await _handleConfigRequest(request);
  //     } else {
  //       // Respond with 404 for other requests
  //       request.response
  //         ..statusCode = 404
  //         ..close();
  //     }
  //   }
  // }
  //
  // Future<void> _handleConfigRequest(HttpRequest request) async {
  //   try {
  //     // Read the request body
  //     var requestBody = await utf8.decoder.bind(request).join();
  //     var configPacket = json.decode(requestBody) as Map<String, dynamic>;
  //
  //     print('Received config packet: $configPacket');
  //
  //     // Simulate processing the packet and sending a response with Robot_ID
  //     var robotId = "SimulatedRobotID";
  //     configPacket["Robot_ID"] = robotId;
  //
  //     // Send the response back to the Flutter app on Phone 1
  //     request.response
  //       ..statusCode = 200
  //       ..write(json.encode(configPacket))
  //       ..close();
  //
  //     print('Sent response back to Phone 1: $configPacket');
  //   } catch (e) {
  //     // Handle any errors during processing
  //     print('Error processing config request: $e');
  //     request.response
  //       ..statusCode = 500
  //       ..write('Internal Server Error')
  //       ..close();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Networks'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: ssidList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return itemSSID(index);
          },
        ),
      ),
    );
  }

  Widget itemSSID(index) {
    if (index == 0) {
      return Column(
        children: [
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('ssid'),
                onPressed: _getWifiName,
              ),
              Offstage(
                offstage: level == 0,
                child: Image.asset(level == 0 ? 'images/wifi1.png' : 'images/wifi$level.png', width: 28, height: 21),
              ),
              Text(_wifiName),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('ip'),
                onPressed: _getIP,
              ),
              Text(_ip),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.wifi),
              hintText: 'Your wifi ssid',
              labelText: 'ssid',
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              ssid = value;
            },
          ),
          TextField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.lock_outline),
              hintText: 'Your wifi password',
              labelText: 'password',
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              password = value;
            },
          ),
          ElevatedButton(
            child: Text('connection'),
            onPressed: connection,
          ),
        ],
      );
    } else {
      return Column(children: <Widget>[
        ListTile(
          leading: Image.asset('images/wifi${ssidList[index - 1].level}.png', width: 28, height: 21),
          title: Text(
            ssidList[index - 1].ssid,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
            ),
          ),
          dense: true,
        ),
        Divider(),
      ]);
    }
  }

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
    });
  }

  Future<Null> _getWifiName() async {
    int l = await Wifi.level;
    String wifiName = await Wifi.ssid;
    setState(() {
      level = l;
      _wifiName = wifiName;
    });
  }

  Future<Null> _getIP() async {
    String ip = await Wifi.ip;
    setState(() {
      _ip = ip;
    });
  }

  Future<Null> connection() async {
    Wifi.connection(ssid, password).then((v) {
      print(v);
    });
  }
}
