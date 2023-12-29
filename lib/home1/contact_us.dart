import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class contact_us extends StatefulWidget {
  const contact_us({super.key});

  @override
  State<contact_us> createState() => _contact_usState();
}

class _contact_usState extends State<contact_us> {
  TextEditingController fullname = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sendmessage = TextEditingController();
  final GlobalKey<FormState> _contact = GlobalKey<FormState>();
  CommonWidget snackbar = CommonWidget();
  ApiService apiService = ApiService();
  late SharedPreferences pref;
  var ID;
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    ID = pref.getInt('id');
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
          },
          child: Icon(
            Icons.home_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: "Contact Us".text.white.xl2.bold.center.make(),
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
        key: _contact,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Full Name",
                style: TextStyle(color: Color(0xff1539b0), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: fullname,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Enter Full Name";
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
                      color: Color(0xff1539b0), // Set the border color to red
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 7),
                    child: Image.asset(
                      "assets/company_icon (1).png",
                      scale: 2.3,
                      color: const Color(0xff969696),
                    ),
                  ),
                  hintText: 'Full Name',
                  hintStyle: const TextStyle(color: Color(0xff969696)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Contact Number",
                style: TextStyle(color: Color(0xff1539b0), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counterText: "",
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/contact_icon (1).png",
                            scale: 2.3,
                            color: const Color(0xff969696),
                          ),
                        ),
                        Text(
                          '+91 |',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
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
                      color: Color(0xff1539b0),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Contact Number',
                  hintStyle: const TextStyle(color: Color(0xff969696)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Email Address",
                style: TextStyle(color: Color(0xff1539b0), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
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
                      color: Color(0xff1539b0), // Set the border color to red
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
                  hintStyle: const TextStyle(color: Color(0xff969696)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Message",
                style: TextStyle(color: Color(0xff1539b0), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                maxLines: 5,
                controller: sendmessage,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Enter Message";
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
                      color: Color(0xff1539b0), // Set the border color to red
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    child: Image.asset(
                      "assets/user_id_icon.png",
                      scale: 2.3,
                      color: const Color(0xff969696),
                    ),
                  ),
                  hintText: "Message",
                  hintStyle: const TextStyle(
                    color: Color(0xff969696),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  if (_contact.currentState!.validate()) {
                    var param = new Map<String, dynamic>();

                    param['FullName'] = fullname.text;
                    param['ContactNo'] = phoneno.text;
                    param['Email'] = email.text;
                    param['Message'] = sendmessage.text;

                    var resdata =
                        await apiService.postCall('/api/ContactUs', param);
                    log('${resdata}');

                    if (resdata['status'] == 1) {
                      snackbar.ToastMsg("Message Send We contact you Soon", 2,
                          'green', context);
                      fullname.text = '';
                      phoneno.text = '';
                      email.text = '';
                      sendmessage.text = '';
                    } else {
                      return null;
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
                    "Send",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
