import 'dart:convert';

import 'package:digi_pm_skin/util/util.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:digi_pm_skin/fragments/form_exe.dart';
import 'package:digi_pm_skin/fragments/sop.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Execution extends StatefulWidget {
  final String title = '';
  final dynamic tasklistUser;
  final caller;
  const Execution({Key key, this.tasklistUser, this.caller}) : super(key: key);

  @override
  _MyExecutionState createState() => _MyExecutionState();
}

class _MyExecutionState extends State<Execution> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Execution Assignment"),
                bottom: TabBar(tabs: digiPM.tabExe),
              ),
              body: TabBarView(children: <Widget>[
                Sop(videoUrl: widget.tasklistUser['video_path']),
                FormExe(caller: widget.caller),
              ]),
              floatingActionButton: setFloatingButton(digiPM, context),
            )),
      );
    });
  }

  Future<bool> _onWillPop() {
    var isStarting = true;

    if (isStarting == false) {
      Navigator.of(context).pop(false);
    } else {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('You are in Execution Mode'),
              content: new Text('Do you want to exit Execution Mode?'),
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

    return Future.value(false);
  }

  Widget setFloatingButton(DigiPMProvider digiPM, context) {
    if (digiPM.displayFloatingButtonCamera) {
      return FloatingActionButton(
        onPressed: () {
          getImage(context, digiPM);
        },
        child: Icon(Icons.camera_alt),
      );
    } else {
      return null;
    }
  }

  Future getImage(context, DigiPMProvider digiPM) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<dynamic> photo = digiPM.executionProperty['photo_evidence'];
    photo.add({'img_path': image.path, 'img': image});
    digiPM.setExeItem("photo_evidence", photo);
  }

  saveExecution(DigiPMProvider digiPM, context) {
    if (digiPM.executionProperty['isStarting'] == true) {
      Util.alert(
          context,
          "Validation Error",
          "Please Stop Time "
              "execution before finishing execution");
      return null;
    }

    if (digiPM.executionProperty['hasExecuted'] != true) {
      Util.alert(
          context,
          "Validation Error",
          "You have to "
              "run execution time before finishing execution");
      return null;
    }

    if (digiPM.executionProperty['execution_status'] == null) {
      Util.alert(
          context,
          "Validation Error",
          "You have to "
              "fill form");
      return null;
    }

    if (digiPM.executionProperty['execution_status'] == 0 &&
        (digiPM.executionProperty['pending_reason_status'] == 0 ||
            digiPM.executionProperty['pending_reason_status'] == "")) {
      Util.alert(
          context,
          "Validation Error",
          "You have to "
              "fill reason pending form");
      return null;
    }

    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirmation'),
            content: new Text('Are you sure you want to save execution?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => saveExecutionResult(digiPM),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  saveExecutionResult(DigiPMProvider digiPM) {
    Util.loader(context, "", "Saving...");

    var data = {
      'before': digiPM.executionProperty['photo_evidence_before'],
      'after': digiPM.executionProperty['photo_evidence_after'],
      'payload': {
        'status_exe': digiPM.executionProperty['execution_status'],
        'second_exe': digiPM.executionProperty['secondExeCount'],
        'recommendation_text': digiPM.executionProperty['recommendation_text'],
        'other_reason_text': digiPM.executionProperty['other_reason_text'],
        'banner_exe': digiPM.executionProperty['bannerExe'],
        'tasklist': digiPM.selectedTasklist
      }
    };

    //debugPrint(data.toString());

    Api.saveExecution(data).then((val) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var daily = await Api.getDailySupervisor(
          {'id_supervisor': prefs.getString("id_user")});
      var weekly = await Api.getWeeklySupervisor(
          {'id_supervisor': prefs.getString("id_user")});

      var res = jsonDecode(val);

      if (res['code_status'] == 1) {
        Util.alert(context, "Success", "You have saved the execution")
            .then((val) {
          setState(() {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
            digiPM.resetExecProperty = digiPM.executionPropertyOrigin;
            digiPM.setTasklistUserSpvDaily(daily);
            digiPM.setTasklistUserSpvWeekly(weekly);
          });
        });
      }
    });
  }

}
