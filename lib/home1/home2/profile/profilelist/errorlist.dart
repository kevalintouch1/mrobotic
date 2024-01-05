import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:mrobotic/home1/home2/home2.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class errorlist extends StatefulWidget {
  const errorlist({Key? key}) : super(key: key);

  @override
  State<errorlist> createState() => _errorlistState();
}

class _errorlistState extends State<errorlist> {
  ApiService apiService = ApiService();
  late SharedPreferences pref;
  var ID;
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
    ID = pref.getInt('id');
    accessToken = pref.getString('accessToken').toString();
    profileImagePath = pref.getString('profileImagePath') ?? '';
    if (mounted) await fetchErrorData();

    setState(() {
      loader = false;
      profileImagePath;
    });
  }

  Future<void> fetchErrorData() async {
    var param = <String, dynamic>{};
    var resData = await apiService.tokenWithPostCall2(
        '/api/Error/GetError', param, accessToken);

    setState(() {
      data = resData['data'];
      log('$data');
    });
  }

  void makeSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        data = []; // Clear the previous search results
      });
      var param = <String, dynamic>{
        'SearchText': query,
      };
      var resData = await apiService.tokenWithPostCall2(
          '/api/Error/GetError', param, accessToken);
      setState(() {
        data = resData['data'];
      });
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => home2(autoid: USER_ID),
                    ),
                    (route) => false);
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
            title: "ERROR LIST".text.white.xl2.bold.center.make(),
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
                  OutlineSearchBar(
                    borderRadius: BorderRadius.circular(15),
                    cursorColor: const Color(0xff1539b0),
                    borderColor: const Color(0xff1539b0),
                    clearButtonColor: const Color(0xff1539b0),
                    searchButtonPosition: SearchButtonPosition.leading,
                    searchButtonIconColor: const Color(0xff1539b0),
                    onKeywordChanged: (query) => makeSearch(query),
                  ),
                  for (var item in data)
                    Container(
                      // height: 100,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xfff1f1f1),
                        image: const DecorationImage(
                          image: AssetImage("assets/text_box.png"),
                        ),
                      ),
                      child: ListTile(
                        title: RichText(
                          text: TextSpan(
                            text: '${item["tittle"]}  ',
                            style: const TextStyle(
                              color: Color(0xff1539b0),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${item["errorCode"]}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: AutoSizeText(
                            '${item["description"]}',
                            style: const TextStyle(
                              color: Color(0xffcecece),
                              fontWeight: FontWeight.w700,
                            ),
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
