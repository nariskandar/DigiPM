import 'dart:developer';

import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/fragments/weekly_spv.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'daily_spv.dart';

class SpvAssignment extends StatelessWidget {
  final String caller;
  const SpvAssignment({Key key, this.caller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      log("spv assignment rendered");
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: StatefulWrapper(
            onInit: () {
              var data = {};
              SharedPreferences.getInstance().then((prefs) async {
                digiPM.setLoadingState(true);
                if (caller == "team") {
                  data['man_power'] = "2";
                  data['status'] = "1";
                } else if (caller == "trline") {
                  data['man_power'] = "0";
                  data['status'] = "2";
                  data['is_ready_rating'] = "1";
                } else if (caller == "ucf_exe") {
                  data['man_power'] = "0";
                  data['status'] = "2";
                  data['reason'] = "1";
                  data['is_ready_rating'] = "0";
                } else {
                  data['man_power'] = "1";
                  data['status'] = "1";
                }
                data['id_supervisor'] = prefs.getString("id_user");
                await digiPM.getDailySupervisor(data);
                await digiPM.getWeeklySupervisor(data);
                digiPM.setLoadingState(false);
              });
            },
            child: DefaultTabController(
                length: 2,
                child: Scaffold(
                    body: Column(
                      children: <Widget>[
                        Material(
                          color: Theme.of(context).accentColor,
                          child: TabBar(
                              labelColor: Colors.white,
                              indicatorColor: Colors.blueAccent,
                              unselectedLabelColor: Colors.blueAccent,
                              tabs: [
                                digiPM.tasklistUserSpvDaily != null
                                    ? Tab(
                                        text: "Daily" +
                                            " (" +
                                            digiPM.tasklistUserSpvDaily.length
                                                .toString() +
                                            ")")
                                    : Tab(text: "Daily"),
                                digiPM.tasklistUserSpvWeekly != null
                                    ? Tab(
                                        text: "Weekly" +
                                            " (" +
                                            digiPM.tasklistUserSpvWeekly.length
                                                .toString() +
                                            ")")
                                    : Tab(text: "Weekly")
                              ]),
                        ),
                        Expanded(
                          flex: 1,
                          child: TabBarView(children: <Widget>[
                            DailyAssignment(caller: caller),
                            WeeklyAssignment(caller: caller),
                          ]),
                        )
                      ],
                    ),
                    floatingActionButton: setFloatingButton(digiPM, context)))),
      );
    });
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
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
