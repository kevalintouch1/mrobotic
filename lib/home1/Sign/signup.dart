// ignore_for_file: unused_local_variable

import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/Sign/otpverification.dart';
import 'package:mrobotic/home1/Sign/signin.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  late SharedPreferences pref;
  List DATA = [];
  ApiService apiService = ApiService();
  bool allow = false;
  bool dontallow = false;
  CommonWidget snackbar = CommonWidget();
  TextEditingController company = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController person = TextEditingController();
  final GlobalKey<FormState> _signkey = GlobalKey<FormState>();

  String generateCaptchaCode(int length) {
    final rand = Random();
    const chars = '0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(
          rand.nextInt(chars.length),
        ),
      ),
    );
  }

  List data = [];
  bool _isEnabled = false;

  late String _captchaCode;
  final _verificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _captchaCode = generateCaptchaCode(6);
    init();
  }

  @override
  void dispose() {
    _verificationController.dispose();
    super.dispose();
  }

  var contactNo;
  var Username;
  var resdata;
  var policy;

  init() async {
    pref = await SharedPreferences.getInstance();
    contactNo = pref.getString("contactNo").toString();
    Username = pref.getString("username").toString();
    // policy = pref.getString("policy").toString();
    var resdata = await apiService.getCall('/api/Content?Type=privacy policy');
    d.log('${resdata}');
    if (mounted) {
      setState(() {
        policy = resdata['data']['content'];
      });
    }
  }

  void _showdialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
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
                'Before you can complete your registration, you must accept the MROBOTICS Terms and Conditions and Privacy Policy.',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              content: Row(
                children: [
                  Checkbox(
                    value: _isEnabled,
                    onChanged: (bool? value) {
                      setState(() {
                        _isEnabled = value ?? false;
                      });
                    },
                    activeColor: _isEnabled ? Colors.green : null,
                  ),
                  TextButton(
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 50));
                      showDialog(
                          context: context,
                          builder: (context) {
                            _isEnabled == false;
                            return Container(
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
                                titlePadding: const EdgeInsets.only(
                                    right: 10, top: 30, left: 10),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                backgroundColor: Colors.white,
                                title: const Text(
                                  'Terms and Conditions & Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                content: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    '${policy}',
                                    style: TextStyle(color: Color(0xff1539b0)),
                                  ),
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
                                          // blue border color
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
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
                                          // blue border color
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      var param = new Map<String, dynamic>();

                                      param['CompanyName'] = company.text;
                                      param['ContactNo'] = phoneno.text;
                                      param['Email'] = email.text;
                                      param['PersonName'] = person.text;
                                      showDialog(
                                        context: context,
                                        // barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      var resdata = await apiService.postCall(
                                          '/api/Auth/Register', param);

                                      d.log('${resdata}');
                                      print('resdata ${resdata['status']}');
                                      if (resdata['status'] == 1) {
                                        await pref
                                            .setInt("USER_ID", resdata['data'])
                                            .toString();
                                        snackbar.ToastMsg(resdata['message'], 2,
                                            'green', context);
                                      } else if (resdata['status'] == 2) {
                                        snackbar.ToastMsg(resdata['message'], 2,
                                            'red', context);
                                      } else if (resdata['status'] == 3) {
                                        snackbar.ToastMsg(resdata['message'], 2,
                                            'red', context);
                                      }

                                      Navigator.pop(context);
                                    },
                                    child: const Text("I Agree"),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Text("View Terms and Privacy Policy"),
                  ),
                ],
              ),
              actions: [
                Opacity(
                  opacity: _isEnabled ? 0.99 : 0.2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Color(0xff1539b0), // blue border color
                          width: 2,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_isEnabled) {
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                Opacity(
                  opacity: _isEnabled ? 0.99 : 0.2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff1539b0),
                      minimumSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Color(0xff1539b0), // blue border color
                          width: 2,
                        ),
                      ),
                    ),
                    onPressed: _isEnabled
                        ? () async {
                      setState(() {
                        allow = !allow; // update button press state
                      });
                      var param = new Map<String, dynamic>();

                      param['CompanyName'] = company.text;
                      param['ContactNo'] = phoneno.text;
                      param['Email'] = email.text;
                      param['PersonName'] = person.text;
                      showDialog(
                        context: context,
                        // barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      var resdata = await apiService.postCall(
                          '/api/Auth/Register', param);

                      d.log('${resdata}');
                      if (resdata['status'] == 1) {
                        pref.setInt("USER_ID", resdata['data']).toString();

                        Future.delayed(const Duration(milliseconds: 10),
                                () async {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      otpverification(autoid: DATA),
                                ),
                                    (route) => false,
                              );
                            });
                        snackbar.ToastMsg(
                            resdata['message'], 2, 'green', context);
                      } else if (resdata['status'] == 2) {
                        snackbar.ToastMsg(
                            resdata['message'], 2, 'red', context);
                      } else if (resdata['status'] == 3) {
                        snackbar.ToastMsg(
                            resdata['message'], 2, 'red', context);
                      }

                      Navigator.pop(context);

                      // Future.delayed(const Duration(milliseconds: 10),
                      //         () {
                      //       Navigator.pushAndRemoveUntil(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               otpverification(autoid: DATA),
                      //         ),
                      //             (route) => false,
                      //       );
                      //     });
                    }
                        : null,
                    child: const Text("I Agree"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signkey,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 70),
                  child: Image.asset("assets/shape.png"),
                ),
                Expanded(
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Container(
                        // height: 280,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Company Name",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: company,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Enter Company Name";
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
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 7),
                                  child: Image.asset(
                                    "assets/company_icon (1).png",
                                    scale: 2.3,
                                    color: const Color(0xff969696),
                                  ),
                                ),
                                hintText: 'Company Name',
                                hintStyle:
                                    const TextStyle(color: Color(0xff969696)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Contact Number",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: phoneno,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Enter Phone Number";
                                } else if (value.length != 10) {
                                  return "Phone Number should be exactly 10 digits";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: const Color(0xff1539b0),
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.phone,
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
                                    color: Color(
                                        0xff1539b0), // Set the border color to red
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Image.asset(
                                          "assets/contact_icon (1).png",
                                          scale: 2.3,
                                          color: const Color(0xff969696),
                                        ),
                                      ),
                                      Text(
                                        '+91 |',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: 'Contact Number',
                                hintStyle:
                                    const TextStyle(color: Color(0xff969696)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Email Address",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: email,
                              validator: (value) {
                                String pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (value!.isEmpty || value == "") {
                                  return "Email is requird ";
                                } else if (!(regex.hasMatch(value))) {
                                  return "Invalid Email";
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
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Image.asset(
                                    "assets/email_icon (1).png",
                                    scale: 2.3,
                                    color: const Color(0xff969696),
                                  ),
                                ),
                                hintText: 'Email Address',
                                hintStyle:
                                    const TextStyle(color: Color(0xff969696)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Contact person",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: const TextStyle(fontFamily: "OpenSans"),
                              controller: person,
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return "Enter Person Name";
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
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 7, right: 7),
                                  child: Image.asset(
                                    "assets/user_id_icon.png",
                                    scale: 2.3,
                                    color: const Color(0xff969696),
                                  ),
                                ),
                                hintText: "Contact person",
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
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _captchaCode,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff969696),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 80),
                        child: TextFormField(
                          style: const TextStyle(fontFamily: "OpenSans"),
                          cursorColor: const Color(0xff1539b0),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: _verificationController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: Color(
                                    0xffe1e1e1), // Set the border color to your desired color
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: Color(
                                    0xffe1e1e1), // Set the border color to your desired color
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: "Enter Captcha",
                            hintStyle: const TextStyle(
                              color: Color(0xff969696),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_verificationController.text == _captchaCode) {
                            if (_signkey.currentState!.validate()) {
                              _showdialog();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Verification code does not match!'),
                                backgroundColor: Colors.red,
                              ),
                            );
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
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => signin(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already Have an Account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      10), // Adjust the spacing between the texts
                              Text(
                                "Signin",
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
                      const SizedBox(
                        height: 30,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
