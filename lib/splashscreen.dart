import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mrobotic/home1/home1.dart';
import 'package:mrobotic/home1/home2/home2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  bool allow = false;
  bool dontallow = false;
  late SharedPreferences pref;
  late int USER_ID;
  late String username;
  late bool _isDisposed;
  late String profileImagePath;
  late String accessToken;
  late int status;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    init();
    _checkInternetConnectivity();
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark the State object as disposed
    super.dispose();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getInt("USER_ID") ?? -1;
    username = pref.getString('username') ?? '';
    accessToken = pref.getString('accessToken') ?? '';
    profileImagePath = pref.getString('profileImagePath').toString();
    // status = pref.getInt('status') ?? 1;
    log('Username: $username');
    log('USER_ID: $USER_ID');
    // log('status: $status');

    // log('accessToken: $accessToken');
    log('profileImagePath: $profileImagePath');
  }

  void _checkInternetConnectivity() async {
    await Future.delayed(const Duration(seconds: 3));
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.only(right: 10, top: 30, left: 10),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            actionsAlignment: MainAxisAlignment.spaceAround,
            backgroundColor: Colors.white,
            title: const Text(
              '"MROBOTICS PVT LTD." WOULD LIKE TO CONNECT TO DEVICES ON YOUR LOCAL NETWORK.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            content: const Text(
              "This app will be able to discover and connect to devices on the networks you use.",
              style: TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                      color: Color(0xff1539b0),
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () {
                  _checkInternetConnectivity();
                  setState(() {
                    dontallow = !dontallow;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Don't Allow"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff1539b0),
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                      color: Color(0xff1539b0),
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () {
                  _checkInternetConnectivity();
                  setState(() {
                    allow = !allow;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Allow"),
              ),
            ],
          ),
        ),
      );
    } else {
      if (!_isDisposed) {
        if (accessToken.isNotEmpty &&
            username.isNotEmpty &&
            USER_ID != -1 &&
            username.length > 1) {
          print("if");
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => home2(autoid: USER_ID),
            ),
            (route) => false,
          ).then((value) {
            setState(() {
              init();
            });
          });
        } else {
          print("else");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const home1(),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              child: Image.asset(
                "assets/logo.png",
                scale: 2.5,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: Image.asset(
                "assets/app_name1.png",
                scale: 4,
              ),
            ),
            Container(
              child: _isLoading
                  ? const SizedBox(
                      height: 50,
                      width: 50,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [Colors.white],
                        strokeWidth: 12,
                      ),
                    )
                  : null,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
