// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:mrobotic/home1/contact_us.dart';
import 'package:mrobotic/home1/home1.dart';
import 'package:mrobotic/home1/home2/dashboard.dart';
import 'package:mrobotic/home1/home2/our_product.dart';
import 'package:mrobotic/home1/home2/profile/profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../Bluethooth/FlutterWifiIoT.dart';
import '../hardwareconnect.dart';

class home2 extends StatefulWidget {
  const home2({super.key, required autoid});

  @override
  State<home2> createState() => _home2State();
}

class _home2State extends State<home2> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int selectedButtonIndex = 0;

  // bool training = false;
  // bool order = false;
  // bool feedback = false;
  bool _isVerified = false;
  bool _isLoading = false;
  bool _isTryAgain = false;
  bool verificationSuccessful = true;
  bool allow = false;
  bool dontallow = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CommonWidget snackbar = CommonWidget();
  late SharedPreferences pref;
  ApiService apiService = ApiService();
  List data = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void handleButtonTap(int index) {
    setState(() {
      selectedButtonIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String profileImagePath = "";
  var accessToken;
  var USER_ID;
  var username;
  var status;

  Future<void> init() async {
    try {
      pref = await SharedPreferences.getInstance();
      USER_ID = pref.getInt("USER_ID");
      accessToken = pref.getString('accessToken').toString();
      profileImagePath = pref.getString('profileImagePath') ?? '';
      username = pref.getString('username').toString();

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Center(
            child:
            CircularProgressIndicator(),
          );
        },
      );

      var param = <String, dynamic>{};
      param['UserId'] = USER_ID.toString();
      var resdata = await apiService.tokenWithPostCall2(
          '/api/Setting/GetProfileImage', param, accessToken);
      var resdata1 = await apiService.tokenWithGetCall(
          '/api/Home/$USER_ID', accessToken);
      await pref.setInt('status', resdata1['data']['status']);
      status = pref.getInt('status');


      print('accessToken : $accessToken');
      print('USER_ID : $USER_ID');
      print('status23 : ${resdata1['data']['status']}');
      print('resdata1 : $status');
      print('status23: $status');
      print('status23: $status');
      print('status23: $_isVerified');
      print('status23: $_isLoading');

      setState(() {
        profileImagePath = resdata['data'] ?? '';
        username;
        status;
        Navigator.pop(context);
      });
    } catch (e) {
      // Handle any exceptions that occur during API calls or SharedPreferences access
      print('Error in init: $e');
    }
  }

  Future<void> _handleRefresh() async {
    await init();
  }

  void _showVerificationPopup() async {
    showDialog(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/bg2.png",
                ),
                fit: BoxFit.cover)),
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
            'Your Add product request has been send,Please wait Max 24 working hour, For Verification and Back end process. You will notify once your product add.',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "You will get Master Password on your Register Mobile number and Email Id",
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff1539b0),
                minimumSize: const Size(150, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                    color: Color(0xff1539b0), // blue border color
                    width: 2,
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                  _isVerified = verificationSuccessful;
                  _isTryAgain = !verificationSuccessful;
                });

                var param = new Map<String, dynamic>();
                param['UserId'] = USER_ID.toString();

                print('before: $_isVerified $status');
                try {
                  Navigator.pop(context); // Close the popup

                  var resdata1 = await apiService.tokenWithPostCall2(
                      '/api/Product/ProductRequest', param, accessToken);

                  await pref.setInt('status', resdata1['status']);

                  print('status: ${resdata1}');
                  if (resdata1['status'] == 1) {
                    setState(() {
                      _isLoading = false;
                      _isVerified = false;
                      status = 2;
                    });
                  } else if (resdata1['status'] == 2) {
                    setState(() {
                      _isVerified = true;
                      status = 4;
                    });
                    // snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
                  } else if (resdata1['status'] == 3) {
                    setState(() {
                      _isTryAgain = false;
                      status = 3;
                    });
                    // snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
                  } else if (resdata1['status'] == 4) {
                    setState(() {
                      _isVerified = false;
                      status = 1;
                    });
                    // snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
                  }
                  print('after: $_isVerified $status');
                  // snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
                } catch (error) {
                  print('API Error:1 $error');
                }
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }

  void _loadData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: const Color(0xff1539b0),
          child: const Center(
            child:
                CupertinoActivityIndicator(radius: 100.0, color: Colors.white),
          ),
        );
      },
    );

    await Future.delayed(
      const Duration(milliseconds: 10),
    );
    pref = await SharedPreferences.getInstance();
    await pref.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const home1(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          GestureDetector(
            onTap: () {
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
                    titlePadding:
                        const EdgeInsets.only(right: 10, top: 30, left: 10),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    backgroundColor: Colors.white,
                    title: const Text(
                      "Are you sure want to exit this app?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              dontallow ? Colors.white : Colors.black,
                          backgroundColor: dontallow
                              ? const Color(0xff1539b0)
                              : Colors.white,
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
                          setState(() {
                            dontallow = !dontallow;
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: allow ? Colors.white : Colors.black,
                          backgroundColor:
                              allow ? const Color(0xff1539b0) : Colors.white,
                          minimumSize: const Size(120, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: Color(0xff1539b0),
                              width: 2,
                            ),
                          ),
                        ),
                        onPressed: _loadData,
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: Image.asset(
                "assets/logout.png",
                scale: 2.5,
              ),
            ),
          ),
        ],
        title: username != null
            ? '$username'.text.white.xl2.bold.center.make()
            : 'User'.text.white.xl2.bold.center.make(),
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
                  profileImagePath.isNotEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 35,
                          child: ClipOval(
                            child: Image.network(
                              profileImagePath,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : ClipOval(
                          child: Image.asset("assets/sign_in _icon.png"),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _loadData,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: const Color(0xff1539b0),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Sign out",
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
              onTap: () => handleButtonTap(0),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color: selectedButtonIndex == 0
                        ? const Color(0xff1539b0)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: selectedButtonIndex == 0
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
                        color: selectedButtonIndex == 0
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => handleButtonTap(2),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color: selectedButtonIndex == 2
                        ? const Color(0xff1539b0)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: selectedButtonIndex == 2
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
                        color: selectedButtonIndex == 2
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                handleButtonTap(3);
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
                  color: selectedButtonIndex == 3
                      ? const Color(0xff1539b0)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: selectedButtonIndex == 3
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
                        color: selectedButtonIndex == 3
                            ? Colors.white
                            : Colors.black,
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: const Color(0xff1539b0),
        backgroundColor: Colors.white,
        strokeWidth: 2.0,
        onRefresh: () async {
          _handleRefresh();
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_isTryAgain || _isLoading) {
                                _showVerificationPopup();
                              } else {
                                _showVerificationPopup();
                              }
                            },
                            child: _isLoading || status == 2
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/waiting.png"),
                                      ),
                                    ),
                                    height: 180,
                                    child: const CupertinoActivityIndicator(
                                        radius: 30.0, color: Colors.white),
                                  )
                                : _isVerified || status == 4
                                    ? GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          );

                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => dashboard(
                                                autoid: USER_ID,
                                              ),
                                            ),
                                          );

                                          Navigator.pop(context);
                                        },
                                        child: SizedBox(
                                          height: 180,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.asset(
                                            "assets/dashboard.png",
                                          ),
                                        ),
                                      )
                                    : _isTryAgain || status == 3
                                        ? SizedBox(
                                            height: 180,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Image.asset(
                                                'assets/try_again.png'),
                                          )
                                        : SizedBox(
                                            height: 180,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // child:
                                            //     Image.asset('assets/try_again.png'),
                                            child: Image.asset(
                                              "assets/add_product.png",
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
                                    builder: (context) => profile(
                                      autoid: USER_ID,
                                    ),
                                  ));
                            },
                            child: SizedBox(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                "assets/profile.png",
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
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => out_product(
                                    autoid: USER_ID,
                                  ),
                                ),
                              );

                              Navigator.pop(context);
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
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 50,
                        left: 50,
                      ),
                      child: ElevatedButton(
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
                      ),
                    )
                  ],
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
