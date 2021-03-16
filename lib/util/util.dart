import 'dart:developer';
import 'package:digi_pm_skin/fragments/abnormality/popup_content.dart';
import 'package:digi_pm_skin/fragments/abnormality/popup.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';

import 'package:flutter/material.dart';

class Util {
  static Future<void> alert(
      BuildContext context, String title, String content, [String from, AbnormalityProvider abnormality, BreakdownProvider breakdown]) {
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
              onPressed: () async {
                if(from == 'submissionPM03'){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  await abnormality.getEWO(context, 'PM03');
                  abnormality.setLoadingState(false);
                }
                if(from == 'submissionPM02'){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  await abnormality.getEWO(context, 'PM03');
                  abnormality.setLoadingState(false);
                }
                if(from == 'approvedPM03'){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
                if(from == 'severityPM03'){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
                if(from == 'analysisPM03'){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  await abnormality.getEWO(context, 'PM03');
                  abnormality.setLoadingState(false);
                }
                if(from == 'approvedPM02'){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  await breakdown.getEWO(context, 'PM02');
                  abnormality.setLoadingState(false);
                }
                if(from == 'receivedpm02'){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  await breakdown.getEWO(context, 'PM02');
                  abnormality.setLoadingState(false);
                }
                if(from == 'exeCorrective') {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  await breakdown.getEWO(context, 'PM02');
                }
                if(from == 'woApproval') {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  static showPopup(BuildContext context, Widget widget, String title,
      {BuildContext AbnormalityFormView1}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
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

  static Future<void> alertAfterSaved(
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
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> confirmPreviousPage(abnormality, breakdown, context, String tittle, String content) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('$tittle'),
        content: new Text('$content'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ;
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

  // static Future<bool> showPopup(BuildContext context, Widget widget, String title) {
  //    Navigator.push(
  //     context,
  //      PopupLayout(
  //       top: 30,
  //       left: 30,
  //       right: 30,
  //       bottom: 50,
  //       child: PopupContent(
  //         content: Scaffold(
  //           appBar: AppBar(
  //             title: Text(title),
  //             leading: new Builder(builder: (context) {
  //               return IconButton(
  //                 icon: Icon(Icons.clear),
  //                 onPressed: () {
  //                   try {
  //                     Navigator.pop(context); //close the popup
  //                   } catch (e) {}
  //                 },
  //               );
  //             }),
  //             brightness: Brightness.light,
  //           ),
  //           resizeToAvoidBottomPadding: false,
  //           body: widget,
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
