import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/Sign/otpforForgotpass.dart';
import 'package:mrobotic/home1/Sign/signup.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:mrobotic/home1/home2/home2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  TextEditingController user_id = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> signin = GlobalKey<FormState>();
  bool _obscureText = true;
  ApiService apiService = ApiService();
  CommonWidget snackbar = CommonWidget();
  late SharedPreferences pref;
  var USER_ID;
  void initState() {
    super.initState();
    init();
  }

  String profileImagePath = "";
  var username;
  var contactNo;
  var status;
  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getInt("USER_ID").toString();
    username = pref.getString('username').toString();
    contactNo = pref.getString('contactNo').toString();
    profileImagePath = pref.getString('profileImagePath') ?? '';
    status = pref.getInt('status').toString();
    log('status : ${status}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: signin,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 80),
                  child: Image.asset("assets/shape.png"),
                ),
                Expanded(
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Container(
                        height: 280,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "User ID",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: user_id,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Please Enter User ID";
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
                                    color: Color(
                                        0xff1539b0), // Set the border color to red
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Image.asset(
                                  "assets/user_id_icon.png",
                                  scale: 2.5,
                                  color: const Color(0xff969696),
                                ),
                                hintText: 'User ID',
                                hintStyle: const TextStyle(
                                  color: Color(0xff969696),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Password",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Please Enter Correct Password";
                                } else {
                                  null;
                                }
                                return null;
                              },
                              cursorColor: const Color(0xff1539b0),
                              controller:
                                  password, // replace with your controller
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
                                    color: Color(
                                        0xff1539b0), // Set the border color to red
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Image.asset(
                                  "assets/password_icon.png",
                                  scale: 2.5,
                                  color: const Color(0xff969696),
                                ),
                                suffixIcon: IconButton(
                                  icon: _obscureText
                                      ? Image.asset(
                                          "assets/hide_icon.png",
                                          scale: 2.5,
                                          color: const Color(0xff969696),
                                        )
                                      : Image.asset(
                                          "assets/show_icon.png",
                                          scale: 2.5,
                                          color: const Color(0xff969696),
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText =
                                          !_obscureText; // toggle password visibility
                                    });
                                  },
                                ),
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                  color: Color(0xff969696),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (signin.currentState!.validate()) {
                                  var param = new Map<String, dynamic>();
                                  param['UserName'] = user_id.text;

                                  var resdata = await apiService.postCall(
                                      '/api/Auth/ForgotPassword', param);

                                  showDialog(
                                    context: context,
                                    // barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                  if (resdata['status'] == 1) {
                                    await pref.setInt(
                                        'USER_ID', resdata['data']);
                                    snackbar.ToastMsg(resdata['message'], 2,
                                        'green', context);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              otpforForgotpass(
                                            autoid: USER_ID,
                                          ),
                                        ));
                                  } else if (resdata['status'] == 2) {
                                    snackbar.ToastMsg(
                                        resdata['message'], 2, 'red', context);
                                  } else if (resdata['status'] == 3) {
                                    snackbar.ToastMsg(
                                        resdata['message'], 2, 'red', context);
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Color(0xff1539b0), fontSize: 15),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (signin.currentState!.validate()) {
                            var param = new Map<String, dynamic>();

                            param["username"] = user_id.text;
                            param["password"] = password.text;

                            var resdata = await apiService.postCall(
                                '/api/Auth/Login', param);

                            if (resdata['status'] == 1) {
                              await pref.setString(
                                'accessToken',
                                resdata['data']['accessToken'].toString(),
                              );
                              await pref.setString(
                                'username',
                                resdata['data']['username'].toString(),
                              );
                              await pref.setInt(
                                  "USER_ID", resdata['data']['id']);
                              await pref.setInt(
                                  "status", resdata['data']['status']);
                              log('status@@@ : ${status}');
                              snackbar.ToastMsg(
                                  resdata['message'], 2, 'green', context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => home2(
                                    autoid: USER_ID,
                                  ),
                                ),
                              );
                            } else if (resdata['status'] == 2) {
                              snackbar.ToastMsg(
                                  resdata['message'], 2, 'red', context);
                            } else if (resdata['status'] == 3) {
                              snackbar.ToastMsg(
                                  resdata['message'], 2, 'red', context);
                            }
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
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => signup(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't Have An Account ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      10), // Adjust the spacing between the texts
                              Text(
                                "Signup",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1539b0),
                                  fontSize:
                                      20, // Adjust the font size as desired
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 30,
              right: 0,
              left: 0,
              bottom: 0,
              child: Column(
                children: [
                  Image.asset(
                    "assets/sign in icon.png",
                    scale: 2.5,
                  ),
                  const Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
