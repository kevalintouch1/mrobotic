import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mrobotic/home1/Sign/signin.dart';
import 'package:mrobotic/home1/Sign/signup.dart';
import 'package:mrobotic/home1/aboutua.dart';
import 'package:mrobotic/home1/contact_us.dart';
import 'package:mrobotic/home1/hardwareconnect.dart';
import 'package:mrobotic/home1/home2/our_product.dart';
import 'package:mrobotic/home1/mission&vission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../apiservice.dart';

class home1 extends StatefulWidget {
  const home1({super.key});

  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {
  bool training = false;
  bool order = false;
  bool feedback = false;
  late SharedPreferences pref;
  ApiService apiService = ApiService();

  // final int _selectedContainer = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance()
        .then((pref) => {print('${pref.getInt('USER_ID')} Rahul')});
    SharedPreferences.getInstance()
        .then((pref) => {print('${pref.getString('username')} Rahul')});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        // Set the drawer icon color to white
        actions: [
          GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const signup(),
                  ));
            },
            child: Container(
                margin: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  "assets/person.png",
                  scale: 2,
                )),
          ),
        ],
        title: "MROBOTICS".text.white.xl2.bold.center.make(),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => aboutus(),
                              ));
                        },
                        child: SizedBox(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/about_us.png",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => missionvission(),
                              ));
                        },
                        child: SizedBox(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/mission_&_vision.png",
                          ),
                          // child: Image.asset(""),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => out_product(autoid: ""),
                              ));
                        },
                        child: SizedBox(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/our_product.png",
                          ),
                          // child: Image.asset(""),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => contact_us(),
                              ));
                        },
                        child: SizedBox(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/contact_us.png",
                          ),
                          // child: Image.asset(""),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              requestPermissions();
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF173BB5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              padding: const EdgeInsets.only(
                  left: 30, top: 15, right: 30, bottom: 15),
              elevation: 5.0,
              shadowColor: Colors.black,
            ),
            child: const Text(
              '+ Connect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff1539b0),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/sign_in _icon.png",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const signin(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: const Color(0xff1539b0),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 250,
              child: Image.asset(
                "assets/img.png",
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  training = !training;
                  order = false;
                  feedback = false;
                });
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color:
                        training ? const Color(0xff1539b0) : Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: training
                      ? Image.asset(
                          "assets/select_training_icon.png",
                          scale: 1.5,
                        )
                      : Image.asset(
                          "assets/selunect_training_icon.png",
                          scale: 1.5,
                        ),
                  title: Text(
                    "Training",
                    style: TextStyle(
                        color: training ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  order = !order;
                  training = false;
                  feedback = false;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color: order ? const Color(0xff1539b0) : Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: order
                      ? Image.asset(
                          "assets/select_spares_icon.png",
                          scale: 1.5,
                        )
                      : Image.asset(
                          "assets/unselect_spares_icon.png",
                          scale: 1.5,
                        ),
                  title: Text(
                    "Spares Order",
                    style: TextStyle(
                        color: order ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  order = false;
                  training = false;
                  feedback = !feedback;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => contact_us(),
                    ));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                  color:
                      feedback ? const Color(0xff1539b0) : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: feedback
                      ? Image.asset(
                          "assets/select_feedback_icon.png",
                          scale: 1.5,
                        )
                      : Image.asset(
                          "assets/unselect_feedback_icon.png",
                          scale: 1.5,
                        ),
                  title: Text(
                    "Feedback",
                    style: TextStyle(
                        color: feedback ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> requestPermissions() async {
    // Request location permission
    var status = await Permission.location.request();
    if (status.isGranted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => hardwareconnect(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => hardwareconnect(),
          ));
    }

    // Request network state permission
    status = await Permission.accessMediaLocation.request();
    if (status.isGranted) {
      print('Media location permission granted');
    } else {
      print('Media location permission denied');
    }
  }
}
