import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class out_product extends StatefulWidget {
  const out_product({super.key, required autoid});

  @override
  State<out_product> createState() => _out_productState();
}

class _out_productState extends State<out_product> {
  late SharedPreferences pref;
  bool rowonepart = true;
  ApiService apiService = ApiService();
  String profileImagePath = "";
  bool loader = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List data = [];
  var resdata;
  var USER_ID;

  init() async {
    pref = await SharedPreferences.getInstance();
    USER_ID = pref.getInt("USER_ID").toString();
    profileImagePath = pref.getString('profileImagePath') ?? '';

    var resdata = await apiService.getCall('/api/OurProduct');

    setState(() {
      data = resdata['data'];
      profileImagePath;
      loader = false;
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
            title: "Products".text.white.xl2.bold.center.make(),
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
              children: [
                SizedBox(
                  height: 10,
                ),
                for (var item in data)
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 25, right: 15, left: 15, bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xfff1f1f1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        right: 15,
                                        left: 15,
                                        bottom: 15),
                                    child: (item['productImageUrl'] != null)
                                        ? Image.network(
                                            item['productImageUrl'],
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/logo.png',
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 10, top: 20, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          '${item['features']}'
                                              .text
                                              .maxFontSize(12)
                                              .color(
                                                Color(0xff1539b0),
                                              )
                                              .align(TextAlign.start)
                                              .overflow(TextOverflow.ellipsis)
                                              .make(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Color(0xff1539b0),
                                height: 2,
                                indent: 10,
                                endIndent: 10,
                                thickness: 2,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      '${item['description']}'
                                          .text
                                          .maxFontSize(12)
                                          .color(
                                            Color(0xff1539b0),
                                          )
                                          .align(TextAlign.start)
                                          .overflow(TextOverflow.ellipsis)
                                          .make(),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff1539b0),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          height: 30,
                          width: 100,
                          child: "${item['code']}"
                              .text
                              .center
                              .white
                              .bold
                              .align(TextAlign.center)
                              .overflow(TextOverflow.ellipsis)
                              .make(),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 30,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff1539b0),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          height: 30,
                          width: 100,
                          child: '${item['tittle']}'
                              .text
                              .color(
                                Colors.white,
                              )
                              .bold
                              .align(TextAlign.start)
                              .overflow(TextOverflow.ellipsis)
                              .make(),
                        ),
                      )
                    ],
                  ),
                SizedBox(
                  height: 10,
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
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
