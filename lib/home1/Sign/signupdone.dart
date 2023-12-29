import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/Sign/signin.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signupdone extends StatefulWidget {
  const signupdone({super.key, required autoid});

  @override
  State<signupdone> createState() => _signupdoneState();
}

class _signupdoneState extends State<signupdone> {
  ApiService apiService = ApiService();

  TextEditingController user_id = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  GlobalKey<FormState> donepage = GlobalKey<FormState>();
  bool _obscureText = true;
  CommonWidget snackbar = CommonWidget();
  late SharedPreferences pref;
  var USER_ID;
  var contactNo;
  var username;
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getInt("USER_ID").toString();
    username = pref.getString('username').toString();
    contactNo = pref.getString('contactNo').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: donepage,
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
                        // height: 320,
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
                                    fontWeight: FontWeight.bold),
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
                              height: 20,
                            ),
                            const Text(
                              "Re-Enter Password",
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
                                  return "Re-Enter Password";
                                } else if (password.text != confirmpass.text) {
                                  return "Password not Match";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: const Color(0xff1539b0),
                              controller: confirmpass,
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
                                hintText: 'Re-Enter Password',
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
                                if (donepage.currentState!.validate()) {
                                  var param = new Map<String, dynamic>();
                                  param['Id'] = USER_ID.toString();
                                  param["Username"] = user_id.text;
                                  param["Password"] = password.text;
                                  param["ConfirmPassword"] = confirmpass.text;

                                  var resdata = await apiService.postCall(
                                      '/api/Auth/RegisterUser', param);

                                  log('${resdata}');
                                  log("message");
                                  log(USER_ID.toString());

                                  //===========================================================================

                                  if (resdata['status'] == 1) {
                                    await pref.setString(
                                      'contactNo',
                                      resdata['data']['contactNo'].toString(),
                                    );
                                    await pref.setString(
                                      'username',
                                      resdata['data']['username'].toString(),
                                    );
                                    log('1233333,${resdata['data']['contactNo'].toString()}');
                                    log('${resdata['data']['username'].toString()}');
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => signin(
                                              // autoid: USER_ID,
                                              ),
                                        ),
                                        (route) => false);
                                    snackbar.ToastMsg(resdata['message'], 2,
                                        'green', context);
                                  } else if (resdata['status'] == 2) {
                                    snackbar.ToastMsg(resdata['message'], 2,
                                        'green', context);
                                  } else if (resdata['status'] == 3) {
                                    snackbar.ToastMsg(resdata['message'], 2,
                                        'green', context);
                                  }
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xff1539b0),
                                ),
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Done",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                    "Sign Up",
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
