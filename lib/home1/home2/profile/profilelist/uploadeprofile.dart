// ignore_for_file: unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrobotic/apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../commonWidget.dart';

class UploadProfile extends StatefulWidget {
  final int autoid;

  const UploadProfile({Key? key, required this.autoid}) : super(key: key);

  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  late SharedPreferences pref;
  ApiService apiService = ApiService();
  late int userId;

  // ignore: unused_field
  String? _filename;

  bool isLoading = false;
  File? fileToDisplay;
  CommonWidget snackbar = CommonWidget();

  @override
  void initState() {
    super.initState();
    // .then((v) => setState(() {}))
    init();
  }

  String profileImagePath = "";
  String fileimagepath = "";
  var USER_ID;
  var accessToken;
  var fileData;
  String imageUrl = "";
  init() async {
    pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken').toString();

    USER_ID = pref.getInt("USER_ID");
    profileImagePath = pref.getString('profileImagePath') ?? "";

    var param = new Map<String, dynamic>();
    param['UserId'] = USER_ID.toString();
    var resdata = await apiService.tokenWithPostCall2(
        '/api/Setting/GetProfileImage', param, accessToken);

    log('zdscsafc ${profileImagePath}');

    setState(() {
      profileImagePath;
      imageUrl = resdata['data'] ?? '';
    });
  }

  // File? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        fileimagepath = pickedFile.path;
        profileImagePath = "";
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: "Upload Profile ".text.white.xl2.bold.center.make(),
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
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _pickImage(ImageSource.gallery);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0xff1539b0),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 80,
                    child: profileImagePath.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              profileImagePath,
                              width: 170,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                          )
                        : fileimagepath.isNotEmpty
                            ? ClipOval(
                                child: Image.file(
                                  File(fileimagepath),
                                  width: 170,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : imageUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      imageUrl,
                                      width: 170,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      "assets/sign in icon1.png",
                                      width: 170,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              log("${USER_ID}");

              if (fileimagepath.isEmpty) {
                snackbar.ToastMsg(
                    "Please Select Profile Image", 10, 'red', context);
              } else if (fileimagepath.isNotEmpty) {
                var param = new Map<String, dynamic>();
                param['UserId'] = USER_ID.toString();
                param['File'] = await MultipartFile.fromFile(fileimagepath);
                showDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                print(param);
                var resdata = await apiService.tokenWithPostCall2(
                    '/api/Setting/UploadProfile', param, accessToken);
                log('${resdata}');
                log("message");

                if (resdata['status'] == 1) {
                  await pref.setString('profileImagePath', resdata['data']);

                  setState(() {
                    profileImagePath = resdata['data'];
                    pref.setString('profileImagePath', resdata['data']);
                  });

                  snackbar.ToastMsg(resdata['message'], 2, 'green', context);

                  Navigator.pop(context);
                  Navigator.pop(context);
                } else if (resdata['status'] == 2) {
                  snackbar.ToastMsg(resdata['message'], 2, 'red', context);
                } else if (resdata['status'] == 3) {
                  snackbar.ToastMsg(resdata['message'], 2, 'red', context);
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xff1539b0),
              ),
              height: 55,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
