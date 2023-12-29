import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:numberpicker/numberpicker.dart';

class robot extends StatefulWidget {
  const robot({super.key, required autoid});

  @override
  State<robot> createState() => _robotState();
}

class _robotState extends State<robot> {
  TextEditingController masterpass = TextEditingController();
  Duration duration = const Duration(hours: 0, minutes: 00);
  bool isPM = false;
  bool switchValue = false;
  GlobalKey<FormState> master = GlobalKey<FormState>();
  int containerCount = 1;
  CommonWidget snackbar = CommonWidget();
  // void _showDialog(Widget child) {
  //   showCupertinoModalPopup<void>(
  //       context: context,
  //       builder: (BuildContext context) => Container(
  //             height: 216,
  //             padding: const EdgeInsets.only(top: 6.0),
  //             margin: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //             ),
  //             color: CupertinoColors.systemBackground.resolveFrom(context),
  //             child: SafeArea(
  //               top: false,
  //               child: child,
  //             ),
  //           ));
  // }
  late SharedPreferences pref;
  ApiService apiService = ApiService();
  TextEditingController txtController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
    txtController.text = DateFormat('h:mm a').format(DateTime.now());
    init();
  }

  List data = [];
  var USER_ID;
  var accessToken;
  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getString("USER_ID").toString();
    accessToken = pref.getString('accessToken').toString();

    var param = new Map<String, dynamic>();
    param['UserId'] = USER_ID.toString();
    var resdata = await apiService.tokenWithPostCall2(
        '/api/Product/GetProduct', param, accessToken);
    log('${resdata}');
    // log('${resdata['productTransaction'][0]}');
    setState(() {
      data = resdata['data'];
    });
  }

  void _shodialogmasterpassword() async {
    showDialog(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/bg2.png",
              ),
              fit: BoxFit.cover),
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
          title: Image.asset(
            "assets/warning.png",
            scale: 3,
          ),
          content: const Text(
            "You miss your today's daily Cleaning Cycle",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xff1539b0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.abc,
          color: Colors.transparent,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              child: Image.asset(
                "assets/person.png",
                scale: 2,
              ),
            ),
          ),
        ],
        title: "User".text.white.xl2.bold.center.make(),
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff1539b0),
              ),
              child: AutoSizeText(
                "",
                maxLines: 2,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const AutoSizeText(
                "XXX123",
                maxLines: 2,
                style: TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            //===========================================================//
            Column(
              children: List.generate(
                containerCount,
                (index) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  // String timeValue = 'Initial Time';

                  Future pickTime() async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Color.fromARGB(255, 39, 107, 96),
                            colorScheme: ColorScheme.light(
                              primary: Color.fromARGB(255, 39, 107, 96),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                        txtController.text = DateFormat('h:mm a').format(
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            time.hour,
                            time.minute,
                          ),
                        );
                      });
                    }
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickTime();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 75,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffe1e1e1), width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: const Text(
                              "Time",
                              style: TextStyle(
                                  color: Color(0xff303030),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              "${txtController.text}",
                              style: TextStyle(
                                color: Color(0xff969696),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 75,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffe1e1e1), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: const Text(
                            "Cycle",
                            style: TextStyle(
                                color: Color(0xff303030),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: NumberPicker(
                            selectedTextStyle: TextStyle(
                              color: Color(0xff969696),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            value: _currentIndex,
                            itemCount: 1,
                            minValue: 1,
                            maxValue: 100,
                            onChanged: (value) =>
                                setState(() => _currentIndex = value),
                            zeroPad: false,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        height: 100,
                        width: 60,
                        child: Image.asset(
                          "assets/set_btn.png",
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  containerCount += 1;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xff1539b0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "ADD",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                    color: switchValue
                        ? const Color(0xffe1e1e1)
                        : const Color(0xff1539b0),
                    width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Auto",
                  style: TextStyle(
                      color:
                          switchValue ? const Color(0xffe1e1e1) : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: CupertinoSwitch(
                value: switchValue,
                activeColor: const Color(0xff01b70e),
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    if (switchValue) _shodialogmasterpassword();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: switchValue
                              ? const Color(0xff1539b0)
                              : const Color(0xffe1e1e1),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Manual",
                        style: TextStyle(
                            color: switchValue
                                ? Colors.black
                                : const Color(0xffe1e1e1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: switchValue
                              ? const Color(0xff1539b0)
                              : const Color(0xffe1e1e1),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Dry Run",
                        style: TextStyle(
                            color: switchValue
                                ? Colors.black
                                : const Color(0xffe1e1e1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xff01b70e),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "No Error",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 100,
              width: 60,
              child: Image.asset(
                "assets/on_btn.png",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future pickTime() async {
  //   TimeOfDay? time = await showTimePicker(
  //     context: context,
  //     initialTime: selectedTime,
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor: Color.fromARGB(255, 39, 107, 96),
  //           colorScheme: ColorScheme.light(
  //             primary: Color.fromARGB(255, 39, 107, 96),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (time != null) {
  //     setState(() {
  //       selectedTime = time;
  //       txtController.text = DateFormat('h:mm a').format(
  //         DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day, time.hour, time.minute),
  //       );
  //     });
  //   }
  // }
}
