// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CommonWidget with ChangeNotifier {
  void ToastMsg(
      String msg, double fontsize, String color, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Center(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                    color: color == 'red' ? Colors.red[900] : Colors.green[800],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    "${msg}",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 5000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
