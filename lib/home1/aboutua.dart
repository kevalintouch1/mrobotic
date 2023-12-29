import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:velocity_x/velocity_x.dart';

class aboutus extends StatefulWidget {
  const aboutus({super.key});

  @override
  State<aboutus> createState() => _aboutusState();
}

class _aboutusState extends State<aboutus> {
  bool loader = true;
  ApiService apiService = ApiService();
  String aboutus = "";
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var resdata = await apiService.getCall('/api/Content?Type=About Us');
    log('log: ${resdata['data']['content']}');
    log('${resdata}');
    setState(() {
      loader = false;
      aboutus = resdata['data']['content'] ?? "";
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
            title: "About Us".text.white.xl2.bold.center.make(),
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
                Text(
                  '${aboutus}',
                  style: TextStyle(
                      color: Color(0xff1539b0),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
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
