import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/pages/Execution.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';

class Assignment extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality,__) {
      dev.log("assignment rendered");
      var width = MediaQuery.of(context).size.width;

      if (digiPM.isLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        if (digiPM.tasklistUser == null || digiPM.tasklistUser.length == 0) {
          return RefreshIndicator(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Center(
                        child: Text("No Tasklist Data",
                            style:
                                TextStyle(fontSize: 14, color: Colors.grey))),
                    height: MediaQuery.of(context).size.height,
                  )
                ],
              ),
              onRefresh: () async {
                digiPM.setLoadingState(true);
                var prefs = await SharedPreferences.getInstance();
                await digiPM.getUserTasklist({
                  'id_user': prefs.getString("id_user"),
                  'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
                }, context);
                digiPM.setLoadingState(false);
              });
        } else {
          return generateAssignmentList(width, digiPM, context);
        }
      }
    });
  }

  Widget generateAssignmentList(width, DigiPMProvider digiPM, context) {
    return Container(
        color: Colors.blueGrey,
        child: RefreshIndicator(
          child: new ListView.builder(
            itemCount: digiPM.tasklistUser.length,
            itemBuilder: (context, int) {
              return Container(
                margin: EdgeInsets.all(10),
                child: Card(
                    child: InkWell(
                  onTap: () {
                    // Util.alert(context, "Warning", "For Demo only");
                    // return;
                    confirmExecution(digiPM, int, context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  child: Icon(
                                    Icons.assignment,
                                    size: width < 480 ? 30 : 50,
                                    color: Colors.orange,
                                  ),
                                  alignment: Alignment.centerLeft),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              "Duration : " +
                                                  digiPM.tasklistUser[int]
                                                          ['durasi']
                                                      .toString() +
                                                  ' minutes',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                        ),
                                        Expanded(
                                            child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              digiPM.tasklistUser[int]
                                                  ['execution_date'],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                        ))
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          digiPM.tasklistUser[int]['activity'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("SBU : " +
                                          digiPM.tasklistUser[int]['sbu'] +
                                          "  |  Line : " +
                                          digiPM.tasklistUser[int]['line'] +
                                          "  |  Machine : " +
                                          digiPM.tasklistUser[int]['machine']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: setMachineBanner(
                                          digiPM.tasklistUser[int]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Deskripsi : " +
                                          digiPM.tasklistUser[int]
                                              ['description']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: setUmesc(digiPM.tasklistUser[int]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: setTasklistNumber(
                                          digiPM.tasklistUser[int]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Category : " +
                                          digiPM.tasklistUser[int]['category']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Assigned To : " +
                                          digiPM.tasklistUser[int]
                                              ['assigned_to']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                  ],
                                ),
                              ),
                              flex: width > 960 ? 13 : 8,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                        ),
                      ],
                    ),
                  ),
                )),
              );
            },
          ),
          onRefresh: () async {
            digiPM.setLoadingState(true);
            var prefs = await SharedPreferences.getInstance();
            await digiPM.getUserTasklist({
              'id_user': prefs.getString("id_user"),
              'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
            }, context);
            digiPM.setLoadingState(false);
          },
        ));
  }

  setMachineBanner(tasklistUser) {
    var unit = tasklistUser['unit'];
    var subEquipment = tasklistUser['sub_equipment'];

    return Text("Unit: $unit  |  Sub Equipment : $subEquipment");
  }

  setUmesc(tasklistUser) {
    var umesc = tasklistUser['umesc'];
    if (umesc == null || umesc == "") umesc = "-";
    return Text("UMESC : $umesc");
  }

  setTasklistNumber(tasklistUser) {
    var tasklist = tasklistUser['tasklist_no'];
    return Text("Tasklist Number : $tasklist");
  }

  confirmExecution(DigiPMProvider digiPM, int i, context) {
    clearExeprop(digiPM);
    generateReasonPendingList(digiPM);
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirmation'),
            content: new Text('Do you want to execute the tasklist?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => confirmReason(digiPM, i, context),
                child: new Text('Set Pending'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => goToExecutionTask(digiPM, i, context),
                child: new Text('Yes'),
              )
            ],
          ),
        ) ??
        false;
  }

  Widget confirmReason(DigiPMProvider digiPM, int i, context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Pending Reason Confirmation'),
            content: Container(
              height: 180,
              child: Column(
                children: <Widget>[
                  new Text('Please provide the reason for pending'),
                  cekReason(digiPM, i, context),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Cancel'),
              ),
              new FlatButton(
                onPressed: () => saveAsPending(digiPM, i, "normal", context),
                child: new Text('Set Pending'),
              ),
            ],
          ),
        ) ??
        false;
  }

  goToExecutionTask(DigiPMProvider digiPM, int i, context) {
    Navigator.of(context).pop(false);
    digiPM.setSelectedTasklistUser(digiPM.tasklistUser[i]);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Execution(tasklistUser: digiPM.tasklistUser[i])));
  }

  Widget cekReason(DigiPMProvider digiPM, int i, context) {
    if (digiPM.lossTree == null) {
      return generateDropdownLoading("Loading...");
    } else {
      return generateLostTree(digiPM.lossTree, digiPM, i, context);
    }
  }

  Widget generateDropdownLoading(text) {
    return FormBuilderDropdown(
      attribute: "Loading...",
      items: [
        DropdownMenuItem(
          child: Text(text),
          value: "",
        )
      ],
      initialValue: "",
      decoration: InputDecoration(labelText: "Loading..."),
      hint: Text("Loading..."),
    );
  }

  Widget generateLostTree(
      List<dynamic> data, DigiPMProvider digiPM, int i, context) {
    var listTreeDropdown = new List<DropdownMenuItem<dynamic>>();

    listTreeDropdown.add(DropdownMenuItem(
      child: Text("SELECT REASON PENDING"),
      value: "",
    ));

    data.forEach((lostTree) {
      listTreeDropdown.add(DropdownMenuItem(
        child: Text(lostTree['loss_type']),
        value: lostTree['id'].toString(),
      ));
    });

    return FormBuilderDropdown(
      isExpanded: false,
      attribute: "Reason Pending",
      decoration: InputDecoration(labelText: "Reason Pending"),
      initialValue: listTreeDropdown[0].value,
      hint: Text('Select Reason Pending'),
      onChanged: (val) {
        digiPM.setExeItem("pending_reason_status", val);
        if (val == "9") {
          fillFormOther(digiPM, i, context);
        }
      },
      validators: [FormBuilderValidators.required()],
      items: listTreeDropdown,
    );
  }

  void generateReasonPendingList(DigiPMProvider digiPM) {
    if (digiPM.lossTree == null) {
      Api.getLostTree().then((val) {
        digiPM.setLostTree(val);
      });
    }
  }



  void fillFormOther(DigiPMProvider digiPM, int i, context) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Please Fill the Reason below'),
        content: TextFormField(
          decoration: InputDecoration(
            labelText: "Reason",
            hintText: "Fill Reason",
          ),
          initialValue: digiPM.executionProperty['other_reason_text'],
          onChanged: (val) {
            digiPM.setExeItem('other_reason_text', val);
          },
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Cancel'),
          ),
          new FlatButton(
            onPressed: () => saveAsPending(digiPM, i, "other", context),
            child: new Text('Set Pending'),
          ),
        ],
      ),
    );
  }

  saveAsPending(DigiPMProvider digiPM, int i, String from, context) {
    Util.loader(context, "", "Saving...");

    if (digiPM.executionProperty["pending_reason_status"].toString() == "") {
      Navigator.of(context).pop(false);
      Util.alert(context, "Validation",
          "Please fill the reason pending before submitting");
      return;
    } else if (digiPM.executionProperty["pending_reason_status"].toString() ==
        "0") {
      Navigator.of(context).pop(false);
      Util.alert(context, "Validation",
          "Please fill the reason pending before submitting");
      return;
    }
    
    if (from == "normal") {
      if (digiPM.executionProperty["pending_reason_status"] == "9") {
        fillFormOther(digiPM, i, context);
        return;
      }

      digiPM.executionProperty
          .removeWhere((key, value) => key == "photo_evidence_before");
      digiPM.executionProperty
          .removeWhere((key, value) => key == "photo_evidence_after");
      digiPM.executionProperty.removeWhere((key, value) => key == "btnColor");

      Api.savePendingTasklist({
        'tasklist': digiPM.tasklistUser[i],
        'prop': digiPM.executionProperty
      }).then((val) async {
        if (val['code_status'] == 1) {
          Util.alert(context, "Success", "Tasklist has been pending")
              .then((val) {
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            SharedPreferences.getInstance().then((prefs) {
              digiPM.setLoadingState(true);
              digiPM.getUserTasklist({
                'id_user': prefs.getString("id_user"),
                'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
              }, context);
              digiPM.setLoadingState(true);
            });
          });
        }
      });
    }

    if (from == "other") {
      if (digiPM.executionProperty["other_reason_text"] == "") {
        Util.alert(
            context, "Validation", "Please fill the form before submitting");
        return;
      }

      digiPM.executionProperty
          .removeWhere((key, value) => key == "photo_evidence_before");
      digiPM.executionProperty
          .removeWhere((key, value) => key == "photo_evidence_after");
      digiPM.executionProperty.removeWhere((key, value) => key == "btnColor");

      Api.savePendingTasklist({
        'tasklist': digiPM.tasklistUser[i],
        'prop': digiPM.executionProperty
      }).then((val) async {
        if (val['code_status'] == 1) {
          Util.alert(context, "Success", "Tasklist has been pending")
              .then((val) {
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            SharedPreferences.getInstance().then((prefs) {
              digiPM.setLoadingState(true);
              digiPM.setExeItem('other_reason_text', "");
              digiPM.getUserTasklist({
                'id_user': prefs.getString("id_user"),
                'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
              }, context);
              digiPM.setLoadingState(true);
            });
          });
        }
      });
    }
  }

  void clearExeprop(DigiPMProvider digiPM) {
    digiPM.setExeItem('startExe', null);
    digiPM.setExeItem('isStarting', false);
    digiPM.setExeItem('hasExecuted', false);
    digiPM.setExeItem('txtButton', "Start Execution");
    digiPM.setExeItem('counterSecond', 0);
    digiPM.setExeItem('secondExeCount', 0);
    digiPM.setExeItem('btnColor', Colors.green);
    digiPM.setExeItem('bannerResult', null);
    digiPM.setExeItem('bannerExe', "00:00");
    digiPM.setExeItem('max_photo', 3);
    digiPM.setExeItem('photo_evidence', []);
    digiPM.setExeItem('photo_evidence_before', [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ]);
    digiPM.setExeItem('photo_before_counter', 0);
    digiPM.setExeItem('photo_evidence_after', [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ]);
    digiPM.setExeItem('photo_after_counter', 0);
    digiPM.setExeItem('execution_status', null);
    digiPM.setExeItem('pending_reason_status', 0);
    digiPM.setExeItem('other_reason_text', '');
    digiPM.setExeItem('recommendation_text', '');
    digiPM.setExeItem('updateFromRating', false);
  }
}
