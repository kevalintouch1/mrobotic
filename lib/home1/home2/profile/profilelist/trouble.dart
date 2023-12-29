// ignore_for_file: unused_field, depend_on_referenced_packages
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:async';

class trouble extends StatefulWidget {
  const trouble({super.key});

  @override
  State<trouble> createState() => _troubleState();
}

class _troubleState extends State<trouble> {
  String _searchQuery = '';

  late SharedPreferences pref;
  ApiService apiService = ApiService();
  String profileImagePath = "";

  Timer? _debounce;
  List data = [];
  bool loader = true;
  var USER_ID;
  var accessToken;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getInt("USER_ID").toString();
    profileImagePath = pref.getString('profileImagePath') ?? '';
    accessToken = pref.getString('accessToken').toString();
    var param = new Map<String, dynamic>();
    param['UserId'] = USER_ID.toString();
    var resdata1 = await apiService.tokenWithPostCall2(
        '/api/Setting/GetProfileImage', param, accessToken);
    var resdata =
        await apiService.tokenWithGetCall('/api/TroubleShoot', accessToken);

    log('zdscsafc ${resdata}');
    setState(() {
      profileImagePath = resdata1['data'] ?? '';
      data = resdata['data'];
      loader = false;
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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
            title: "TROUBLE SHOOT".text.white.xl2.bold.center.make(),
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
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (var item in data)
                    GestureDetector(
                      onTap: () async {
                        String url = item['troubleShootFilePath'] ?? '';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            '${item['code']} - ${item['tittle']}',
                            // "M1 - Maintenance Manual",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Image.asset(
                            "assets/download_icon.png",
                            scale: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
