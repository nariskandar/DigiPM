import 'dart:developer';

import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:flutter/material.dart';

class Util {
  static Future<void> alert(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  static Future<void> loader(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: AlertDialog(
                content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(padding: EdgeInsets.only(right: 10)),
                Text('$content')
              ],
            )),
            onWillPop: () {
              return Future.value(false);
            });
      },
    );
  }

  static Future<bool> onWillPop(context) {
    return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

}
