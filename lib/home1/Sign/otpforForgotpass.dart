import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrobotic/home1/Sign/forgotpass.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class otpforForgotpass extends StatefulWidget {
  const otpforForgotpass({super.key, required autoid});

  @override
  State<otpforForgotpass> createState() => _otpforForgotpassState();
}

class _otpforForgotpassState extends State<otpforForgotpass> {
  ApiService apiService = ApiService();

  TextEditingController otp_mobile = TextEditingController();
  TextEditingController otp_mail = TextEditingController();
  GlobalKey<FormState> otpverification = GlobalKey<FormState>();
  // final bool _obscureText = true;
  late SharedPreferences pref;
  CommonWidget snackbar = CommonWidget();
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
        key: otpverification,
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
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "OTP Mobile",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: otp_mobile,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Please Enter OTP Mobile";
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
                                  "assets/company_icon (1).png",
                                  scale: 2.5,
                                  color: const Color(0xff969696),
                                ),
                                hintText: 'OTP Mobile',
                                hintStyle: const TextStyle(
                                    color: Color(0xff969696),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                var param = new Map<String, dynamic>();
                                param['Id'] = USER_ID.toString();
                                var resendsmsotp = await apiService.postCall(
                                    '/api/Auth/ResendSMSOtp?${USER_ID}', param);
                                log('${resendsmsotp}');
                                log("message");
                                log(USER_ID.toString());

                                if (resendsmsotp['status'] == 1) {
                                  snackbar.ToastMsg(resendsmsotp['message'], 10,
                                      'green', context);
                                } else if (resendsmsotp['status'] == 2) {
                                  snackbar.ToastMsg(resendsmsotp['message'], 10,
                                      'red', context);
                                } else if (resendsmsotp['status'] == 3) {
                                  snackbar.ToastMsg(resendsmsotp['message'], 10,
                                      'red', context);
                                }
                              },
                              child: const Text(
                                "Resend OTP",
                                style: TextStyle(
                                    color: Color(0xff1539b0), fontSize: 15),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "OTP EMail",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: otp_mail,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Please Enter OTP EMail";
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
                                  "assets/company_icon (1).png",
                                  scale: 2.5,
                                  color: const Color(0xff969696),
                                ),
                                hintText: 'OTP Email',
                                hintStyle: const TextStyle(
                                    color: Color(0xff969696),
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                var param = new Map<String, dynamic>();
                                param['Id'] = USER_ID.toString();
                                var resdata = await apiService.postCall(
                                    '/api/Auth/ResendMailOtp', param);
                                log('${resdata}');
                                log("message");
                                log(USER_ID.toString());
                                if (resdata['status'] == 1) {
                                  snackbar.ToastMsg(
                                      resdata['message'], 2, 'green', context);
                                } else if (resdata['status'] == 2) {
                                  snackbar.ToastMsg(
                                      resdata['message'], 2, 'red', context);
                                } else if (resdata['status'] == 3) {
                                  snackbar.ToastMsg(
                                      resdata['message'], 2, 'red', context);
                                }
                              },
                              child: const Text(
                                "Resend OTP",
                                style: TextStyle(
                                    color: Color(0xff1539b0), fontSize: 15),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (otpverification.currentState!.validate()) {
                                  var param = new Map<String, dynamic>();
                                  param['Id'] = USER_ID.toString();
                                  param['SMSOtp'] = otp_mobile.text;
                                  param['EmailOtp'] = otp_mail.text;

                                  var resdata = await apiService.postCall(
                                      '/api/Auth/VerifyOtp', param);

                                  if (resdata['status'] == 1) {
                                    snackbar.ToastMsg(resdata['message'], 2,
                                        'green', context);

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => forgotpass(
                                            autoid: USER_ID,
                                          ),
                                        ),
                                        (route) => false);
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
                    "Verification",
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
