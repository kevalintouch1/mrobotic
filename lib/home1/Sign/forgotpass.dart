import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/Sign/signin.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class forgotpass extends StatefulWidget {
  const forgotpass({super.key, required autoid});

  @override
  State<forgotpass> createState() => _forgotpassState();
}

class _forgotpassState extends State<forgotpass> {
  var resdata;
  final resetpassword = GlobalKey<FormState>();

  TextEditingController Password = TextEditingController();
  TextEditingController confirm_Password = TextEditingController();
  bool _obscureText = true;
  ApiService apiService = ApiService();
  CommonWidget snackbar = CommonWidget();
  late SharedPreferences pref;
  var USER_ID;
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getInt("USER_ID").toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: resetpassword,
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
                              "Password",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: Password,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Please Enter New Password";
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
                                hintText: 'New Password',
                                hintStyle: const TextStyle(
                                  color: Color(0xff969696),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Confirm Password",
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
                                  return "Re Enter Password";
                                } else if (Password.text !=
                                    confirm_Password.text) {
                                  return "Password not Match";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: const Color(0xff1539b0),
                              controller:
                                  confirm_Password, // replace with your controller
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
                                hintText: 'Confirm Password',
                                hintStyle: const TextStyle(
                                  color: Color(0xff969696),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (resetpassword.currentState!.validate()) {
                            var param = new Map<String, dynamic>();
                            param['Id'] = USER_ID.toString();
                            param['Password'] = Password.text;
                            param['ConfirmPassword'] = confirm_Password.text;
                            var resdata = await apiService.postCall(
                                '/api/Auth/ForgotSetPassword', param);
                            log("${resdata}");

                            //======================================================
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => signin(),
                            //     ));
                            //======================================================

                            if (resdata['status'] == 1) {
                              snackbar.ToastMsg(
                                  resdata['message'], 2, 'green', context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => signin(),
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
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xff1539b0),
                          ),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: const Text(
                            "Done",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                    "Reset Your Pasword",
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
