// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class security extends StatefulWidget {
  const security({super.key, required autoid});

  @override
  State<security> createState() => _securityState();
}

class _securityState extends State<security> {
  TextEditingController current_password = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  GlobalKey<FormState> donepage = GlobalKey<FormState>();
  bool _obscureText = true;
  ApiService apiService = ApiService();
  CommonWidget snackbar = CommonWidget();
  late SharedPreferences pref;
  String profileImagePath = "";
  var USER_ID;
  var accessToken;
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken').toString();

    USER_ID = pref.getInt("USER_ID").toString();
    var Token = pref.getString('token');
    profileImagePath = pref.getString('profileImagePath') ?? '';
    var param = new Map<String, dynamic>();
    param['UserId'] = USER_ID.toString();
    var resdata = await apiService.tokenWithPostCall2(
        '/api/Setting/GetProfileImage', param, accessToken);
    log('zdscsafc ${resdata}');
    setState(() {
      profileImagePath = resdata['data'] ?? '';
    });
    return Token;
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
        title: "SECURITY SETTING ".text.white.xl2.bold.center.make(),
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
        key: donepage,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              child: const Text(
                "Change sign in Password",
                style: TextStyle(
                    color: Color(0xff1539b0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Container(
              // height: 320,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Enter Your Current Password",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(fontFamily: "OpenSans"),
                    controller: current_password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Current Password ";
                      } else if (value != current_password.text) {
                        return "Password Invalid ";
                      } else {
                        return null;
                      }
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
                          color:
                              Color(0xff1539b0), // Set the border color to red
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Image.asset(
                        "assets/password_icon.png",
                        scale: 2.5,
                        color: const Color(0xff969696),
                      ),
                      hintText: 'Enter Your Current Password',
                      hintStyle: const TextStyle(
                          color: Color(0xff969696),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Enter New Password",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(fontFamily: "OpenSans"),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == "" || value!.isEmpty) {
                        return "Please Enter New Password";
                      } else {
                        null;
                      }
                      return null;
                    },
                    cursorColor: const Color(0xff1539b0),
                    controller: password, // replace with your controller
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
                          color:
                              Color(0xff1539b0), // Set the border color to red
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
                      hintText: 'Enter New Password',
                      hintStyle: const TextStyle(
                        color: Color(0xff969696),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Re Enter New Password",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(fontFamily: "OpenSans"),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == "" || value!.isEmpty) {
                        return "Re Enter Password";
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
                          color:
                              Color(0xff1539b0), // Set the border color to red
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Image.asset(
                        "assets/password_icon.png",
                        scale: 2.5,
                        color: const Color(0xff969696),
                      ),
                      hintText: 'Re Enter New Password',
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
                        param['OldPassword'] = current_password.text;
                        param['Password'] = password.text;
                        param['ConfirmPassword'] = confirmpass.text;
                        var resdata = await apiService.tokenWithPostCall2(
                            '/api/Setting/ChangePassword', param, accessToken);
                        log('${resdata}');
                        log("message");
                        log(USER_ID.toString());

                        if (resdata['status'] == 1) {
                          Navigator.pop(context);
                          Navigator.pop(context);

                          snackbar.ToastMsg(
                              resdata['message'], 2, 'green', context);

                          current_password.text = '';
                          password.text = '';
                          confirmpass.text = '';
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
                      margin: const EdgeInsets.only(
                        top: 30,
                        right: 20,
                        left: 20,
                      ),
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
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 50, bottom: 10),
                    child: const Text(
                      "Request for Master Password Change",
                      style: TextStyle(
                          color: Color(0xff1539b0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  Divider(
                    color: Color(0xff1539b0),
                    height: 1.5,
                    endIndent: 15,
                    indent: 15,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var param1 = new Map<String, dynamic>();
                      param1['UserId'] = USER_ID.toString();
                      var resdata1 = await apiService.tokenWithPostCall2(
                          '/api/Setting/MasterPasswordRequest',
                          param1,
                          accessToken);
                      log('${resdata1}');
                      log('${accessToken}');
                      log("message");
                      log(USER_ID);

                      if (resdata1['status'] == 1) {
                        Navigator.pop(context);
                        Navigator.pop(context);

                        snackbar.ToastMsg(
                            resdata1['message'], 2, 'green', context);
                      } else if (resdata1['status'] == 2) {
                        snackbar.ToastMsg(
                            resdata1['message'], 2, 'red', context);
                      } else if (resdata1['status'] == 3) {
                        snackbar.ToastMsg(
                            resdata1['message'], 2, 'red', context);
                      }
                    },
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xff1539b0),
                        ),
                        height: 50,
                        width: 120,
                        alignment: Alignment.center,
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
