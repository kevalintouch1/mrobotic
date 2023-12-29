import 'dart:async';
import 'dart:developer';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/home2/errorscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../commonWidget.dart';

class dashboard extends StatefulWidget {
  const dashboard({
    super.key,
    required autoid,
  });

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  TextEditingController master_pass = TextEditingController();
  // final bool _roboton = false;
  final bool ISDELETE = true;
  final GlobalKey<FormState> _master = GlobalKey<FormState>();
  CommonWidget snackbar = CommonWidget();
  late SharedPreferences pref;
  ApiService apiService = ApiService();
  List data = [];

  void initState() {
    super.initState();

    init();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String profileImagePath = "";
  var USER_ID;
  var accessToken;
  var username;
  var product_idisId;
  var productTransaction;
  var robot_id;
  var robotmode;
  var status;
  var Last_Cycle;
  bool? IsActive;
  bool? isdryRun;
  late bool? mode = false;
  bool? isDeleted;
  bool loader = true;



  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getInt("USER_ID").toString();
    username = pref.getString('username').toString();
    accessToken = pref.getString('accessToken').toString();
    profileImagePath = pref.getString('profileImagePath') ?? '';
    product_idisId = pref.getInt("product_idisId").toString();
    robot_id = pref.getString("robot_id").toString();
    robotmode = (pref.getBool("robotMode")==true) ? 'Auto' : 'Manual';
    Last_Cycle = pref.getString('createdDate').toString();
    // status = pref.getInt('status').toString();
    var param = new Map<String, dynamic>();
    param['UserId'] = USER_ID.toString();
    var resdata = await apiService.tokenWithPostCall2(
        '/api/Product/GetProduct', param, accessToken);

    var resdata1 = await apiService.tokenWithPostCall2(
        '/api/Setting/GetProfileImage', param, accessToken);
    log('zdscsafc ${resdata}');

    log('${resdata}');

    print('GetProfileImage: ${resdata}');


    setState(() {
      profileImagePath = resdata1['data'] ?? '';
      data = resdata['data'];
      loader = false;
    });

  }




  void _shodialogmasterpassword(
      {bool currentMode: false, bool inactivemode: false}) async {
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
        child: Form(
          key: _master,
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
              'Enter Your Master Password',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              style: const TextStyle(fontFamily: "OpenSans"),
              controller: master_pass,
              validator: (value) {
                if (value == "" || value!.isEmpty) {
                  return "Please Master Password";
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
                hintText: 'Enter Master password',
                hintStyle: const TextStyle(
                    color: Color(0xff969696), fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  if (_master.currentState!.validate()) {
                    var param = new Map<String, dynamic>();
                    param['Id'] = USER_ID.toString();
                    param['MasterPassword'] = master_pass.text;

                    showDialog(
                      context: context,
                      // barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    try {
                      Navigator.pop(context);
                      var resdata = await apiService.tokenWithPostCall2(
                          '/api/Setting/VerifyMasterPassword',
                          param,
                          accessToken);

                      log('${resdata}');
                      print('${resdata}');
                      master_pass.text = '';

                      if (resdata['status'] == 1) {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => errorscreen(
                              autoid: data,
                              productid: product_idisId,
                              mode: currentMode,
                              ISACTIVE: inactivemode,
                            ),
                          ),
                        ).then((value) {
                          setState(() {
                            init();
                          });
                        });
                        snackbar.ToastMsg(
                            resdata['message'], 2, 'green', context);
                        master_pass.text = '';
                      } else if (resdata['status'] == 2) {
                        Navigator.pop(context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => errorscreen(
                        //       autoid: data,
                        //       productid: product_idisId,
                        //       mode: currentMode,
                        //       ISACTIVE: inactivemode,
                        //     ),
                        //   ),
                        // );
                        snackbar.ToastMsg(
                            resdata['message'] ?? '', 2, 'green', context);
                      }
                    } catch (error) {
                      print('API Error: $error');
                    }
                  }
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
                      "GO",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                  ? CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 35,
                      child: ClipOval(
                        child: Image.network(
                          profileImagePath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ))
                  : ClipOval(
                      child: Image.asset(
                        "assets/person.png",
                        scale: 2,
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
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              scrollDirection: Axis.vertical,
              children: [
                for (var item in data)
                  // for (var transaction in item['productTransaction'])

                  GestureDetector(
                    onTap: () async {
                      await pref.setInt('product_idisId', item['id']);
                      await pref.setString('robot_id', item['productID']);
                      await pref.setBool("robotMode", mode ?? false);
                      await pref.setString("createdDate", item['createdDate']);
                      product_idisId = item['id'];
                      // log('#================== ${product_idisId}');

                      _shodialogmasterpassword(
                          currentMode: item['mode'],
                          inactivemode: item['isActive']);
                      log('############ ${product_idisId}');
                      log('currentMode: ${item['mode']}');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                          top: 10, right: 15, left: 5, bottom: 10),
                      margin:
                          const EdgeInsets.only(top: 15, right: 15, left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xfff1f1f1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            autofocus: false,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: item['isActive'] == true
                                  ? const Color(0xff1539b0)
                                  : const Color(0xffa0a2a9),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              // minimumSize: const Size(120, 30),
                            ),
                            onPressed: () async {
                              await pref.setInt('product_idisId', item['id']);

                              product_idisId = item['id'];
                              // log('#================== ${product_idisId}');

                              _shodialogmasterpassword(
                                  currentMode: item['mode'],
                                  inactivemode: item['isActive']);
                              // log('############ ${product_idisId}');
                            },
                            child: Row(
                              children: [
                                Center(
                                  child: Container(
                                      child: (item['isActive'] == true)
                                          ? Image.asset(
                                              "assets/green.png",
                                              scale: 1.5,
                                            )
                                          : Image.asset(
                                              "assets/grey (1).png",
                                              scale: 1.5,
                                            )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    '${item["robotName"]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (item['productTransaction'].isEmpty)
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 17,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          else
                            Column(
                              children: [
                                for (var transaction
                                    in item['productTransaction'])
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        (item['mode'] == true)
                                            ? 'Auto'
                                            : 'Manual',
                                        style: TextStyle(
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            color: const Color(0xff1539b0)),
                                      ),
                                      Text(
                                        '${transaction['hh']}:${transaction['mm']}  ${transaction['meridiem']}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            color: const Color(0xff1539b0)),
                                      ),
                                      Text(
                                        '${transaction['cycle']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (loader)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.transparent),
          ),
        if (loader)
          const Center(
            child: CircularProgressIndicator(
              color: const Color(0xff1539b0),
            ),
          ),
      ],
    );
  }
}
