// ignore_for_file: override_on_non_overriding_member, use_build_context_synchronously

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

  @override
  void addContainer() {
    DateTime now = DateTime.now();
    int hour = now.hour % 12; // Calculate hour in 12-hour format

    ProductTransaction defaultObj = ProductTransaction(
      id: 0,
      productId: widget.productid,
      hh: hour == 0 ? 12 : hour, // Handle 0 hour as 12
      mm: now.minute,
      meridiem: now.hour < 12 ? 'AM' : 'PM',
      cycle: 1,
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

    txtController.text = DateFormat('h:mm a').format(DateTime.now());
    init();
  }

  var robotname;
  var robotlocation;
  var hour;
  var minute;
  var meridiem;
  List<bool> hasUserProvidedTime = [];
  List productTransaction = [];
  init() async {
    pref = await SharedPreferences.getInstance();
    profileImagePath = pref.getString('profileImagePath') ?? '';
    USER_ID = pref.getInt("USER_ID").toString();
    username = pref.getString('username').toString();
    accessToken = pref.getString('accessToken').toString();
    log('${widget.productid}');
    mode = pref.getBool('robotMode');
    IsActive = widget.ISACTIVE;
    switchValue = widget.mode;
    print("@@@@@@@@@@@@@@     ${switchValue}, ${widget.mode}");
    print("isssss    ${IsActive}");
    log('${profileImagePath}');
    var param = new Map<String, dynamic>();
    param['Id'] = widget.productid;
    var resdata = await apiService.tokenWithPostCall2(
        '/api/Product/GetProduct', param, accessToken);
    param['UserId'] = USER_ID.toString();
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
    log('rahul   ${widget.mode}');
    setState(() {
      profileImagePath = resdata1['data'] ?? '';
      robotname = resdata['data']['robotName'];
      robotlocation = resdata['data']['robotLocation'];
      transation = tempTransation;
      loader = false;
      txtController.text = '${hour}${minute} ${meridiem}';
      IsActive;
    });
  }

  TextEditingController masterpass = TextEditingController();
  // Duration duration = const Duration(hours: 0, minutes: 00);

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
                hour: productTransaction.hh, minute: productTransaction.mm),
            // useRootNavigator: false,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
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
              transation[index].meridiem = time.hourOfPeriod < 12 ? 'AM' : 'PM';
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
                          fontSize: 20,
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
                        setState(() {
                          if (productTransaction.cycle > 1) {
                            transation[index].cycle--;
                          }
                        });
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
                        setState(() {
                          transation[index].cycle++;
                        });
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
                                addContainer();
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
                                              .tokenWithPostCall(
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
                        title: CupertinoSwitch(
                          value: switchValue,
                          onChanged: (bool value) {
                            setState(() {
                              switchValue = value;
                              print(switchValue);
                              print(123);
                              print(value);
                              if (!switchValue) {
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
                                      titlePadding: const EdgeInsets.only(
                                          right: 10, top: 30, left: 10),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      backgroundColor: Colors.white,
                                      title: Image.asset(
                                        "assets/warning.png",
                                        scale: 3,
                                      ),
                                      content: const Text(
                                        "You miss your today's daily Cleaning Cycle",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        GestureDetector(
                                          onTap: () async {
                                            var param =
                                                new Map<String, dynamic>();
                                            param['ProductId'] =
                                                widget.productid;
                                            // mode = pref.getBool('robotmode');

                                            var resdata = await apiService
                                                .tokenWithPostCall(
                                                    '/api/Product/UpdateProductMode',
                                                    param,
                                                    accessToken);

                                            param['Mode'] = false;
                                            param['IsdryRun'] = false;
                                            log('${resdata['data']['mode']}');
                                            // await pref.setBool(
                                            //     'mode', !switchValue);
                                            if (resdata['status'] == 1) {
                                              // await pref.setBool("mode", mode!);
                                              await pref.setBool(
                                                  'switchValue', switchValue);
                                              Navigator.pop(context);
                                              snackbar.ToastMsg(
                                                  resdata['message'],
                                                  2,
                                                  'green',
                                                  context);
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 60),
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1539b0),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
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
                                      titlePadding: const EdgeInsets.only(
                                          right: 10, top: 30, left: 10),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      backgroundColor: Colors.white,
                                      title: Image.asset(
                                        "assets/warning.png",
                                        scale: 3,
                                      ),
                                      content: const Text(
                                        "You want to start Auto Mode ?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        GestureDetector(
                                          onTap: () async {
                                            var param =
                                                new Map<String, dynamic>();
                                            param['ProductId'] =
                                                widget.productid;
                                            param['Mode'] = true;
                                            param['IsdryRun'] = true;
                                            var resdata = await apiService
                                                .tokenWithPostCall(
                                                    '/api/Product/UpdateProductMode',
                                                    param,
                                                    accessToken);

                                            log('sauto:${switchValue}');
                                            log('${resdata['data']['mode']}');
                                            if (resdata['status'] == 1) {
                                              // await pref.setBool("mode", mode!);
                                              // await pref.setBool(
                                              //     'switchValue', switchValue);
                                              snackbar.ToastMsg(
                                                  resdata['message'],
                                                  2,
                                                  'green',
                                                  context);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 60),
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1539b0),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            //  !_isEnabled
                            // ? const Color(0xffcb0303)
                            const Color(0xff01b70e),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Error - 01",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var param = new Map<String, dynamic>();
                      param['Id'] = widget.productid;
                      IsActive = pref.getBool("isActive");
                      if (IsActive == true) {
                        IsActive = false;
                      } else {
                        IsActive = true;
                      }
                      param['IsActive'] = IsActive;

                      var resdata = await apiService.tokenWithPostCall2(
                          '/api/Product/UpdateActiveStatus',
                          param,
                          accessToken);
                      await pref.setBool('isActive', IsActive!);
                      if (resdata['status'] == 1) {
                        pref.setBool('isActive', IsActive!);
                        setState(() {
                          IsActive = IsActive!;
                        });
                        snackbar.ToastMsg(
                            resdata['message'], 2, 'green', context);
                      } else if (resdata['status'] == 2) {
                        snackbar.ToastMsg(
                            resdata['message'], 2, 'red', context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 100,
                      width: 60,
                      child: IsActive == true
                          ? Image.asset(
                              "assets/on_btn.png",
                            )
                          : Image.asset(
                              "assets/off.png",
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
