import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:velocity_x/velocity_x.dart';

class missionvission extends StatefulWidget {
  const missionvission({super.key});

  @override
  State<missionvission> createState() => _missionvissionState();
}

class _missionvissionState extends State<missionvission> {
  bool loader = true;
  ApiService apiService = ApiService();
  String missionvission = "";
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    var resdata =
        await apiService.getCall('/api/Content?Type=Mission And Vision');
    log('${resdata}');
    setState(() {
      loader = false;
      missionvission = resdata['data']['content'] ?? '';
    });
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
            title: "Mission And Vision".text.white.xl2.bold.center.make(),
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
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Container(
                  child: Text(
                    '${missionvission}',
                    style: TextStyle(
                        color: Color(0xff1539b0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
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
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
