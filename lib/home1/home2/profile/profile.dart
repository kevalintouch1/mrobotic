import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:mrobotic/home1/home2/profile/profilelist/errorlist.dart';
import 'package:mrobotic/home1/home2/profile/profilelist/security.dart';
import 'package:mrobotic/home1/home2/profile/profilelist/uploadeprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import 'profilelist/trouble.dart';

class profile extends StatefulWidget {
  const profile({super.key, required autoid});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  CommonWidget snackbar = CommonWidget();
  late SharedPreferences pref;
  ApiService apiService = ApiService();
  String profileImagePath = "";
  bool loader = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  var resdata;
  var USER_ID;
  var username;
  var accessToken;
  init() async {
    pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken').toString();

    USER_ID = pref.getInt("USER_ID").toString();
    username = pref.getString('username').toString();
    profileImagePath = pref.getString('profileImagePath') ?? '';
    var param = new Map<String, dynamic>();
    param['UserId'] = USER_ID.toString();
    var resdata = await apiService.tokenWithPostCall2(
        '/api/Setting/GetProfileImage', param, accessToken);
    log('zdscsafc ${resdata}');

    setState(() {
      profileImagePath = resdata['data'] ?? '';
      username;
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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
          child: Icon(
            Icons.home_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          profileImagePath.isNotEmpty
              ? Container(
            margin: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 35,
                child: ClipOval(
                  child: Image.network(
                    profileImagePath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )),
          )
              : Container(
            margin: const EdgeInsets.only(right: 15),
            child: ClipOval(
              child: Image.asset(
                "assets/person.png",
                scale: 2,
              ),
            ),
          ),
        ],
        title: username != null
            ? '${username}'.text.white.xl2.bold.center.make()
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: const Color(0xff1539b0),
        backgroundColor: Colors.white,
        strokeWidth: 2.0,
        onRefresh: () async {
          init();
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadProfile(
                          autoid: int.parse(USER_ID),
                        ),
                      ));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(colors: [
                      Color(0xff1c44c8),
                      Color(0xff1539b0),
                    ]),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Upload Profile Picture",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    leading: Image.asset(
                      "assets/profile_icon.png",
                      scale: 3,
                    ),
                    trailing: Image.asset(
                      "assets/next_icon.png",
                      scale: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => security(
                          autoid: USER_ID,
                        ),
                      ));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(colors: [
                      Color(0xff1c44c8),
                      Color(0xff1539b0),
                    ]),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Security Setting",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    leading: Image.asset(
                      "assets/security_icon.png",
                      scale: 3,
                    ),
                    trailing: Image.asset(
                      "assets/next_icon.png",
                      scale: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const trouble(),
                      ));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(colors: [
                      Color(0xff1c44c8),
                      Color(0xff1539b0),
                    ]),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Trouble Shoot",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    leading: Image.asset(
                      "assets/trouble_shoot_icon.png",
                      scale: 3,
                    ),
                    trailing: Image.asset(
                      "assets/next_icon.png",
                      scale: 3,
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => security(
              //             autoid: USER_ID,
              //           ),
              //         ));
              //   },
              //   child: Container(
              //     alignment: Alignment.center,
              //     height: 70,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(15),
              //       gradient: const LinearGradient(colors: [
              //         Color(0xff1c44c8),
              //         Color(0xff1539b0),
              //       ]),
              //     ),
              //     child: ListTile(
              //       title: const Text(
              //         "Daily Reports",
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 18),
              //       ),
              //       leading: Image.asset(
              //         "assets/daily_reports_icon.png",
              //         scale: 3,
              //       ),
              //       trailing: Image.asset(
              //         "assets/next_icon.png",
              //         scale: 3,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const errorlist(),
                      ));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(colors: [
                      Color(0xff1c44c8),
                      Color(0xff1539b0),
                    ]),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Error List",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    leading: Image.asset(
                      "assets/error_icon.png",
                      scale: 3,
                    ),
                    trailing: Image.asset(
                      "assets/next_icon.png",
                      scale: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  var param = new Map<String, dynamic>();
                  param['UserId'] = USER_ID.toString();
                  var resdata1 = await apiService.tokenWithPostCall2(
                      '/api/Product/ProductRequest', param, accessToken);
                  log('${resdata1}');
                  log("message");
                  log(USER_ID.toString());
                  // await Future.delayed(
                  //   const Duration(seconds: 3),
                  // );

                  if (resdata1['status'] == 1) {
                    Navigator.pop(context);
                    snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
                  } else if (resdata1['status'] == 2) {
                    Navigator.pop(context);
                    snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
                  } else if (resdata1['status'] == 3) {
                    Navigator.pop(context);
                    snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(colors: [
                      Color(0xff1c44c8),
                      Color(0xff1539b0),
                    ]),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Add Product Request",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    leading: Image.asset(
                      "assets/add_product_icon.png",
                      scale: 3,
                    ),
                    trailing: Image.asset(
                      "assets/next_icon.png",
                      scale: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
