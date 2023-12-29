import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

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

  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    ID = pref.getInt('id');
    fetchIPAddress();
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
                "Username",
                style: TextStyle(color: Color(0xff000000), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: username,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Enter Username";
                  } else {
                    return null;
                  }
                },
                cursorColor: const Color(0xff1539b0),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  counterText: "",
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
                      color: Color(0xff1539b0),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter Username',
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
                height: 20,
              ),
              const Text(
                "Token",
                style: TextStyle(color: Color(0xff000000), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: token,
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
                  hintText: "Enter Token",
                  hintStyle: const TextStyle(
                    color: Color(0xff969696),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
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

  Future<void> sendDataToServer() async {
    String serverUrl = url.text;
    final Map<String, String> data = {
      'Key': 'JIUzI1NiIsInR5cCI6IkpJ9XVC',
      'SSID': ssid.text,
      'password': password.text,
      'Robot_ID': '$ipaddress',
    };
    pref.setString("ssid", ssid.text);
    pref.setString("password", password.text);
    print('serverUrl $ipaddress');
    print('serverUrl $serverUrl');
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Request was successful, handle the response as needed
        print('Data sent successfully!');
        print('Response: ${response.body}');
        snackbar.ToastMsg('Data sent successfully!', 5, 'green', context);
      } else {
        // Request failed, handle the error
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        snackbar.ToastMsg(
            'Failed to send data. Status code: ${response.statusCode}',
            5,
            'red',
            context);
      }
    } catch (e) {
      // Handle exceptions such as network errors
      print('Error sending data: $e');
      snackbar.ToastMsg('Error sending data: $e', 5, 'red', context);
    }
  }

  Future<void> fetchIPAddress() async {
    try {
      for (NetworkInterface interface in await NetworkInterface.list()) {
        for (InternetAddress addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            url.text = 'http://192.168.29.115:3000/Config';
            print('IP address: ${url.text}');
            ipaddress = addr.address;
          }
        }
      }
    } catch (e) {
      url.text = 'http://192.168.29.115:3000/Config';
      print('Error getting local IP address: $e');
    }
  }
}
