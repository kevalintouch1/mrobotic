// ignore_for_file: override_on_non_overriding_member, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/commonWidget.dart';
import 'package:mrobotic/home1/model/productTransaction.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: camel_case_types, must_be_immutable
class errorscreen extends StatefulWidget {
  int productid;
  bool mode;
  bool ISACTIVE;

  errorscreen(
      {super.key,
      required autoid,
      required this.productid,
      required this.mode,
      required this.ISACTIVE});

  @override
  State<errorscreen> createState() => _errorscreenState();
}

class _errorscreenState extends State<errorscreen> {
  List<int> _currentIndexList = [];
  CommonWidget snackbar = CommonWidget();
  List<ProductTransaction> transation = [];
  int i = 1;
  TextEditingController ssid = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> verifys = GlobalKey<FormState>();

  @override
  void addContainer() {
    DateTime now = DateTime.now();
    int hour = now.hour % 12;
    print('object $i');
    ProductTransaction defaultObj = ProductTransaction(
      id: 0,
      productId: widget.productid,
      hh: hour == 0 ? 12 : hour,
      // Handle 0 hour as 12
      mm: now.minute,
      meridiem: now.hour < 12 ? 'AM' : 'PM',
      cycle: i + 1,
      isDeleted: false,
    );
    transation.add(defaultObj);
  }

  void removeContainer(int index) {
    if (_currentIndexList.length > 1) {
      setState(() {
        transation = [];
      });
    }
  }

  void initState() {
    super.initState();

    txtController.text = DateFormat('hh:mm a').format(DateTime.now());
    init();
  }

  var robotname;
  var robotlocation;
  var lastRunStatus;
  var hour;
  var minute;
  var meridiem;
  List<bool> hasUserProvidedTime = [];
  List productTransaction = [];
  var robot_id;
  var robotmode;
  var status;
  var Last_Cycle;
  var product_idisId;
  String lastRunStatustext = '';

  Future<void> init() async {
    try {
      pref = await SharedPreferences.getInstance();
      profileImagePath = pref.getString('profileImagePath') ?? '';
      USER_ID = pref.getInt('USER_ID')?.toString() ?? '';
      username = pref.getString('username') ?? '';
      accessToken = pref.getString('accessToken') ?? '';
      robot_id = pref.getString("robot_id").toString();
      robotmode = (pref.getBool('robotmode') == true) ? 'Auto' : 'Manual';
      product_idisId = pref.getInt("product_idisId").toString();
      log('${widget.productid}');
      mode = pref.getBool('robotmode');
      IsActive = widget.ISACTIVE;
      // switchValue = widget.mode;

      log('${profileImagePath}');

      var param = <String, dynamic>{};
      param['Id'] = widget.productid;
      var resdata = await apiService.tokenWithPostCall2(
          '/api/Product/GetProduct', param, accessToken);
      print('resdata ${resdata['status']}');
      pref.setString("status", resdata['status'].toString());
      param['UserId'] = USER_ID!;
      var resdata1 = await apiService.tokenWithPostCall2(
          '/api/Setting/GetProfileImage', param, accessToken);
      List<ProductTransaction> tempTransation = [];

      for (var element in resdata['data']['productTransaction']) {
        tempTransation
            .add(ProductTransaction.fromJson(element as Map<String, dynamic>));
      }

      if (tempTransation.isEmpty) {
        DateTime date = DateTime.now();
        int hour = date.hour % 12;
        bool isAM = date.hour < 12;
        ProductTransaction defaultObj = ProductTransaction(
            id: 0,
            productId: widget.productid,
            hh: DateTime.now().hour % 12 == 0 ? 12 : hour,
            mm: date.minute,
            meridiem: isAM ? 'AM' : 'PM',
            cycle: 1,
            isDeleted: false);
        tempTransation.add(defaultObj);
      }

      print('GetProfileImage2: ${resdata}');
      setState(() {
        profileImagePath = resdata1['data'] ?? '';
        robotname = resdata['data']['robotName'];
        robotlocation = resdata['data']['robotLocation'];
        lastRunStatus = resdata['data']['lastRunStatus'];
        switchValue = resdata['data']['mode'];
        transation = tempTransation;
        loader = false;
        txtController.text = '${hour}${minute} ${meridiem}';
        IsActive;
      });

      print('switchValue: $switchValue');

      if (lastRunStatus == 10) {
        lastRunStatustext = 'Robot stuck in between \n(30 min timeout)';
      } else if (lastRunStatus == 11) {
        lastRunStatustext = 'False sensor detection \n(3 sec timeout)';
      } else if (lastRunStatus == 12) {
        lastRunStatustext = 'False sensor detection \n(3 sec timeout)';
      } else if (lastRunStatus == 13) {
        lastRunStatustext = 'False sensor detection \n(3 sec timeout)';
      } else if (lastRunStatus == 14) {
        lastRunStatustext = 'False sensor detection \n(3 sec timeout)';
      } else if (lastRunStatus == 21) {
        lastRunStatustext = 'Motor Failed Top \n(Buzzer)';
      } else if (lastRunStatus == 22) {
        lastRunStatustext = 'Motor Failed Bottom \n(Buzzer)';
      } else if (lastRunStatus == 23) {
        lastRunStatustext = 'Motor Failed Brush \n(Buzzer)';
      } else if (lastRunStatus == 31) {
        lastRunStatustext = 'Battery Not charging';
      } else if (lastRunStatus == 41) {
        lastRunStatustext = 'RTC Module not working';
      }
      log('lastRunStatus   $lastRunStatus');
    } catch (e) {
      // Handle any exceptions that occur during API calls or SharedPreferences access
      print('Error in init: $e');
      // You can add code here to handle the error, show an error message, or take appropriate action.
    }
  }

  Future<void> callApiUpdate(
      {required String ssid, required String password}) async {
    try {
      print('robot_id $product_idisId');
      Map<String, dynamic> requestBody = {
        "Id": product_idisId,
        "SSID": ssid,
        "Password": password
      };

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      print(' $requestBody');

      var resdata1 = await apiService.tokenWithPostCall2(
          '/api/Product/UpdatePassword', requestBody, accessToken);
      print('resdata1 $resdata1');
      if (resdata1['status'] == 1) {
        print('Data sent successfully!');
        Navigator.pop(context);
        snackbar.ToastMsg(resdata1['message'], 2, 'green', context);
      } else {
        Navigator.pop(context);
        snackbar.ToastMsg(resdata1['message'], 2, 'red', context);
      }
    } catch (e) {
      print('Error getting local IP address: $e');
    }
  }

  TextEditingController masterpass = TextEditingController();
  bool switchValue = true;

  GlobalKey<FormState> master = GlobalKey<FormState>();
  int containerCount = 1;
  bool _isEnabled = true;
  late SharedPreferences pref;
  ApiService apiService = ApiService();
  List data = [];

  var USER_ID;
  var accessToken;
  late bool? IsActive = false;
  late bool? mode = false;
  late bool? isdryRun = false;
  late bool? isDeleted = false;
  var username;
  String profileImagePath = "";
  bool loader = true;
  TextEditingController txtController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  Widget buildContainer(int index, ProductTransaction productTransaction) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        Future<void> pickTime(int index) async {
          TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: productTransaction.hh,
              minute: productTransaction.mm,
            ),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                child: Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: const Color(0xff1539b0),
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xff1539b0),
                    ),
                  ),
                  child: child!,
                ),
              );
            },
            useRootNavigator: false, // Set useRootNavigator to false
          );

          if (time != null) {
            setState(() {
              transation[index].hh = time.hourOfPeriod;
              transation[index].mm = time.minute;
              transation[index].meridiem = time.hour < 12 ? 'AM' : 'PM';
            });
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                pickTime(index);
              },
              child: Container(
                alignment: Alignment.center,
                height: 75,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffe1e1e1), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: const Text(
                    "Time",
                    style: TextStyle(
                      color: Color(0xff303030),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Center(
                      child: Text(
                        "${productTransaction.hh}:${productTransaction.mm} ${productTransaction.meridiem}",
                        style: const TextStyle(
                          color: Color(0xff969696),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              height: 75,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffe1e1e1), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  "Cycle",
                  style: TextStyle(
                    color: Color(0xff303030),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.center,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   if (productTransaction.cycle > 1) {
                        //     transation[index].cycle--;
                        //   }
                        // });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 15,
                        width: 15,
                        child: const Icon(
                          Icons.remove,
                          size: 15,
                          color: Color(0xff1539b0),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white24,
                      height: 35,
                      width: 30,
                      child: NumberPicker(
                        selectedTextStyle: const TextStyle(
                          color: Color(0xff969696),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        value: productTransaction.cycle,
                        minValue: 1,
                        maxValue: 100,
                        itemCount: 1,
                        onChanged: (value) {
                          setState(() {
                            transation[index].cycle = value;
                          });
                        },
                        zeroPad: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   transation[index].cycle++;
                        // });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 15,
                        width: 15,
                        child: const Icon(
                          Icons.add,
                          size: 15,
                          color: Color(0xff1539b0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                var param = new Map<String, dynamic>();
                param['Cycle'] = transation[index].cycle;
                param['ProductId'] = widget.productid;
                param['Id'] = transation[index].id;
                param['HH'] = transation[index].hh;
                param['MM'] = transation[index].mm;
                param['Meridiem'] = transation[index].meridiem;

                var resdata = await apiService.tokenWithPostCall2(
                    '/api/Product/SaveProductTransaction', param, accessToken);
                print('resdata $param');

                pref.setInt("Cycle", transation[index].cycle);
                if (transation[index].cycle == 1) {
                  pref.setString("cycle1",
                      "${transation[index].hh}:${transation[index].mm}");
                } else if (transation[index].cycle == 2) {
                  pref.setString("cycle2",
                      "${transation[index].hh}:${transation[index].mm}");
                }

                DateTime dateTime = DateTime.now().toLocal().add(Duration(
                    hours: transation[index].hh,
                    minutes: transation[index].mm));
                int lastCycle = dateTime.millisecondsSinceEpoch ~/ 1000;
                pref.setInt("createdDate", lastCycle);

                if (resdata['status'] == 1) {
                  snackbar.ToastMsg(resdata['message'], 2, 'green', context);
                } else if (resdata['status'] == 2) {
                  snackbar.ToastMsg(resdata['message'], 2, 'red', context);
                } else if (resdata['status'] == 3) {
                  snackbar.ToastMsg(resdata['message'], 2, 'red', context);
                }
              },
              child: SizedBox(
                height: 100,
                width: 60,
                child: Image.asset("assets/set_btn.png"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
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
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                scrollDirection: Axis.vertical,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Opacity(
                    opacity: _isEnabled ? 0.99 : 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff1539b0),
                      ),
                      child: AutoSizeText(
                        // "",
                        '${robotname}',
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Opacity(
                    opacity: _isEnabled ? 0.99 : 0.2,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AutoSizeText(
                        // '',
                        '${robotlocation}',
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 15, overflow: TextOverflow.ellipsis),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: switchValue == true,
                    child: Column(children: [
                      ...List.generate(transation.length,
                          (index) => buildContainer(index, transation[index]))
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: switchValue == true,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xff1539b0),
                              minimumSize: const Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                  color: Color(0xff1539b0),
                                  width: 2,
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (transation.length < 2) {
                                  addContainer();
                                } else {
                                  print(
                                      'object ${transation[1].hh}:${transation[1].mm}');
                                  DateTime dateTime = DateTime.now()
                                      .toLocal()
                                      .add(Duration(
                                          hours: transation[1].hh,
                                          minutes: transation[1].mm));
                                  int lastCycle =
                                      dateTime.millisecondsSinceEpoch ~/ 1000;
                                  pref.setInt("createdDate", lastCycle);
                                  snackbar.ToastMsg("You can add only 2 cycle",
                                      2, "green", context);
                                }
                              });
                            },
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
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
                                  width: 2,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => Container(
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
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      "Are you sure want Delete All Cycle?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          minimumSize: const Size(120, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: const BorderSide(
                                              color: Color(0xff1539b0),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xff1539b0),
                                          minimumSize: const Size(120, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: const BorderSide(
                                              color: Color(0xff1539b0),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          var param =
                                              new Map<String, dynamic>();
                                          param['Id'] = widget.productid;
                                          print(param);
                                          var resdata = await apiService
                                              .tokenWithPostCall2(
                                                  '/api/Product/DeleteTransacion',
                                                  param,
                                                  accessToken);

                                          if (resdata['status'] == 1) {
                                            setState(() {
                                              removeContainer(
                                                  productTransaction.length -
                                                      1);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                            snackbar.ToastMsg(
                                                resdata['message'],
                                                2,
                                                'green',
                                                context);
                                          } else if (resdata['status'] == 2) {
                                            snackbar.ToastMsg(
                                                resdata['message'],
                                                2,
                                                'red',
                                                context);
                                          }
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'ALL DELETE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Opacity(
                    opacity: _isEnabled ? 0.99 : 0.2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: !switchValue
                                ? const Color(0xffe1e1e1)
                                : const Color(0xff1539b0),
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Auto",
                          style: TextStyle(
                              color: !switchValue
                                  ? const Color(0xffe1e1e1)
                                  : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Opacity(
                    opacity: _isEnabled ? 0.99 : 0.2,
                    child: Center(
                        child: MergeSemantics(
                      child: ListTile(
                        title:
                        CupertinoSwitch(
                          value: switchValue,
                          onChanged: (bool value) {
                            setState(() {
                              if (switchValue) {
                                showAlertDialog(
                                  title: "Warning",
                                  content: "You miss your today's daily Cleaning Cycle",
                                  onOkPressed: () => updateSwitchValue(false),
                                );
                              } else {
                                showAlertDialog(
                                  title: "Confirmation",
                                  content: "You want to start Auto Mode?",
                                  onOkPressed: () => updateSwitchValue(true),
                                );
                              }
                            });
                          },
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Opacity(
                    opacity: _isEnabled ? 0.99 : 0.2,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: !switchValue
                                      ? const Color(0xff1539b0)
                                      : const Color(0xffe1e1e1),
                                  width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Manual",
                                style: TextStyle(
                                    color: !switchValue
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
                        // if (_isEnabled == false)
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: !switchValue
                                      ? const Color(0xff1539b0)
                                      : const Color(0xffe1e1e1),
                                  width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Dry Run",
                                style: TextStyle(
                                    color: !switchValue
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // _isEnabled = !_isEnabled;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 6,top: 10,right: 6,bottom: 10),
                      decoration: BoxDecoration(
                        color: lastRunStatus == 0 || lastRunStatus == null
                            ? const Color(0xff01b70e)
                            : const Color(0xffff0000),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: lastRunStatus == 0 || lastRunStatus == null
                          ? const Center(
                              child: Text(
                                "No Error",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            )
                          : Center(
                              child: Text(
                                "Error - $lastRunStatus \n$lastRunStatustext",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // var param = new Map<String, dynamic>();
                      // param['Id'] = widget.productid;
                      // IsActive = pref.getBool("isActive");
                      // if (IsActive == true) {
                      //   IsActive = false;
                      // } else {
                      //   IsActive = true;
                      // }
                      // param['IsActive'] = IsActive;
                      //
                      // var resdata = await apiService.tokenWithPostCall2(
                      //     '/api/Product/UpdateActiveStatus',
                      //     param,
                      //     accessToken);
                      // await pref.setBool('isActive', IsActive!);
                      // if (resdata['status'] == 1) {
                      //   pref.setBool('isActive', IsActive!);
                      //   setState(() {
                      //     IsActive = IsActive!;
                      //   });
                      //   snackbar.ToastMsg(
                      //       resdata['message'], 2, 'green', context);
                      // } else if (resdata['status'] == 2) {
                      //   snackbar.ToastMsg(
                      //       resdata['message'], 2, 'red', context);
                      // }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 100,
                      width: 60,
                      child: Image.asset(
                        "assets/off.png",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Online Mode"),
                  const SizedBox(
                    height: 5,
                  ),
                  Form(
                    key: verifys,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: ssid,
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
                            hintText: 'Enter SSID',
                            hintStyle:
                                const TextStyle(color: Color(0xff969696)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a SSID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: password,
                          obscureText: true,
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
                            hintText: 'Enter Password',
                            hintStyle:
                                const TextStyle(color: Color(0xff969696)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            // Validate the form
                            if (verifys.currentState!.validate()) {
                              // Form is valid, proceed with the update
                              callApiUpdate(
                                ssid: ssid.text,
                                password: password.text,
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
                              "Update Info",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void showAlertDialog({
    required String title,
    required String content,
    required void Function() onOkPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => Container(
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          backgroundColor: Colors.white,
          title: Image.asset(
            "assets/warning.png",
            scale: 3,
          ),
          content: Text(
            content,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            GestureDetector(
              onTap: onOkPressed,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateSwitchValue(bool isAutoMode) async {
    var param = Map<String, dynamic>();
    param['ProductId'] = widget.productid;
    param['Mode'] = isAutoMode;
    param['IsdryRun'] = !isAutoMode;

    var resdata = await apiService.tokenWithPostCall2(
      '/api/Product/UpdateProductMode',
      param,
      accessToken,
    );

    if (resdata['status'] == 1) {
      setState(() {
        switchValue = isAutoMode;
        pref.setBool('robotmode', resdata['data']['mode']);
      });

      Navigator.pop(context);
      snackbar.ToastMsg(resdata['message'], 2, 'green', context);
    }
    print('switchValue2: $switchValue');
  }
}
