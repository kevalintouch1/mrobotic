import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';

class hardwareconnect extends StatefulWidget {
  const hardwareconnect({super.key});

  @override
  State<hardwareconnect> createState() => _contact_usState();
}

class _contact_usState extends State<hardwareconnect> {
  TextEditingController ssid = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController url = TextEditingController();
  TextEditingController token = TextEditingController();
  final GlobalKey<FormState> _contact = GlobalKey<FormState>();
  CommonWidget snackbar = CommonWidget();
  ApiService apiService = ApiService();
  late SharedPreferences pref;
  var ID;
  var ipaddress;
  var accessToken;

  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    ID = pref.getInt('id');
    accessToken = pref.getString('accessToken') ?? '';
    _getCurrentNetworkInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: "HARDWARE CONNECT".text.white.xl2.bold.center.make(),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xff1539b0),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
      ),
      body: Form(
        key: _contact,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "SSID",
                style: TextStyle(color: Color(0xff000000), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: ssid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Enter SSID";
                  } else {
                    null;
                  }
                  return null;
                },
                cursorColor: const Color(0xff1539b0),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xffe1e1e1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xff1539b0), // Set the border color to red
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter SSID',
                  hintStyle: const TextStyle(color: Color(0xff969696)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Password",
                style: TextStyle(color: Color(0xff000000), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: password,
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Enter Password";
                  }
                  return null;
                },
                cursorColor: const Color(0xff1539b0),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xffe1e1e1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xff1539b0), // Set the border color to red
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter Password',
                  hintStyle: const TextStyle(color: Color(0xff969696)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "URL",
                style: TextStyle(color: Color(0xff000000), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: url,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Enter URL";
                  } else {
                    null;
                  }
                  return null;
                },
                cursorColor: const Color(0xff1539b0),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xffe1e1e1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xff1539b0), // Set the border color to red
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Enter URL",
                  hintStyle: const TextStyle(
                    color: Color(0xff969696),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  if (_contact.currentState!.validate()) {
                    sendDataToServer();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xff1539b0),
                  ),
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: const Text(
                    "Connect",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String robotSSID = "MRobot_solar";
  final String robotPassword = "12345678";
  final String configPath = ":8080/Config"; // Replace with your actual path

  String _currentSSID = "";
  String _currentPassword = "";
  String _ipAddress = "";

  Future<void> _getCurrentNetworkInfo() async {
    final wifis = await WiFiForIoTPlugin.getIP();
    log("${wifis}");

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.wifi) {
      var wifiInfo = await WifiInfo().getWifiName();
      var ipAddress = await WifiInfo().getWifiIP();
      setState(() {
        _currentSSID = wifiInfo ?? "Not connected to WiFi";
        _ipAddress = ipAddress ?? "Unknown IP";
      });
    } else {
      setState(() {
        _currentSSID = "Not connected to WiFi";
        _ipAddress = "Unknown IP";
      });
    }

    var configUrl = "http://$_ipAddress$configPath";
    url.text = configUrl;
  }

  Future<void> sendDataToServer() async {
    String serverUrl = url.text;
    final Map<String, String> data = {
      'Key': 'JIUzI1NiIsInR5cCI6IkpJ9XVC',
      'SSID': ssid.text,
      'password': password.text,
      'Robot_ID': pref.getString("robot_id").toString(),
    };

    print('data $data');
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('response ${response.statusCode}');
      if (response.statusCode == 200) {
        // Request was successful, handle the response as needed
        // snackbar.ToastMsg('Data sent successfully!', 2, 'green', context);
        print('Data sent successfully!');
        print('Response: ${response.body}');

        Map<String, dynamic> responseMap = jsonDecode(response.body);

        // Get values from the response
        String key = responseMap['Key'];
        String ssid = responseMap['SSID'];
        String password = responseMap['Password'];
        String Robot_ID = responseMap['Robot_ID'];
        sendConnectionLog(key: key, ssid: ssid, password: password, robot_id: Robot_ID);
      } else {
        snackbar.ToastMsg(
            'Failed to send data. Status code: ${response.statusCode}',
            5,
            'red',
            context);
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      snackbar.ToastMsg('Error sending data: $e', 5, 'red', context);
      print('Error sending data: $e');
    }
  }

  Future<void> sendConnectionLog(
      {required String key,
      required String ssid,
      required String password,
      required String robot_id}) async {
    // try {
      Map<String, dynamic> requestBody = {
        "Id": 0,
        "SSID": ssid,
        "Password": password,
        "Robot_ID": pref.getInt("product_idisId").toString(),
        "Key": key
      };

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      print('requestBody $requestBody');

      var resdata1 = await apiService.tokenWithPostCall2(
          '/api/ConnectionLog', requestBody, accessToken);
      print('resdata1 $resdata1');
      if (resdata1['status'] == 1) {
        Navigator.pop(context);
        snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
      } else {
        Navigator.pop(context);
        snackbar.ToastMsg(resdata1['message'], 2, 'red', context);
      }
    // } catch (e) {
    //   print('Error getting local IP address: $e');
    // }
  }
}
