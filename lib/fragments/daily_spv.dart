import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/pages/Execution.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'form_exe_result.dart';

class DailyAssignment extends StatelessWidget {
  final String caller;
  DailyAssignment({Key key, this.caller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      log("dialy assignment rendered");
      return StatefulWrapper(
          onInit: () {}, child: buildList(width, digiPM, context));
    });
  }

  Widget buildList(width, DigiPMProvider digiPM, context) {
    if (digiPM.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (digiPM.tasklistUserSpvDaily == null ||
          digiPM.tasklistUserSpvDaily.length == 0) {
        return RefreshIndicator(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text("No Tasklist Data",
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                  height: MediaQuery.of(context).size.height,
                )
              ],
            ),
            onRefresh: () async {
              dataRefresher(digiPM);
            });
      } else {
        return generateAssignmentList(width, digiPM);
      }
    }
  }

  void dataRefresher(DigiPMProvider digiPM) async {
    var data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    digiPM.setLoadingState(true);
    if (caller == "team") {
      data['man_power'] = "2";
      data['status'] = "1";
    } else if (caller == "pending") {
      data['man_power'] = "0";
      data['status'] = "4";
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
  }

  Widget generateAssignmentList(width, DigiPMProvider digiPM) {
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
          child: ListView.builder(
            itemCount: digiPM.tasklistUserSpvDaily.length,
            itemBuilder: (context, int) {
              return Container(
                margin: EdgeInsets.all(10),
                child: Card(
                    child: InkWell(
                  onTap: () {
                    Util.alert(context, "Warning", "For Demo only");
                    return;
                    confirmExecution(
                        digiPM, int, digiPM.tasklistUserSpvDaily[int], context);
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
                                                  digiPM
                                                      .tasklistUserSpvDaily[int]
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
                                              digiPM.tasklistUserSpvDaily[int]
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
                                          digiPM.tasklistUserSpvDaily[int]
                                              ['activity'],
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
                                          digiPM.tasklistUserSpvDaily[int]
                                              ['sbu'] +
                                          "  |  Line : " +
                                          digiPM.tasklistUserSpvDaily[int]
                                              ['line'] +
                                          "  |  Machine : " +
                                          digiPM.tasklistUserSpvDaily[int]
                                              ['machine']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: setMachineBanner(
                                          digiPM.tasklistUserSpvDaily[int]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Deskripsi : " +
                                          digiPM.tasklistUserSpvDaily[int]
                                              ['description']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: setUmesc(
                                          digiPM.tasklistUserSpvDaily[int]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: setTasklistNumber(
                                          digiPM.tasklistUserSpvDaily[int]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Category : " +
                                          digiPM.tasklistUserSpvDaily[int]
                                              ['category']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Asignee : " +
                                            digiPM.tasklistUserSpvDaily[int]
                                                ['employee_name'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blueGrey),
                                      ),
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
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: <Widget>[
                                      determineButtonAction(
                                          caller,
                                          digiPM,
                                          context,
                                          digiPM.tasklistUserSpvDaily[int],
                                          int),
                                      determineRating(
                                          digiPM.tasklistUserSpvDaily[int],
                                          digiPM,
                                          context)
                                    ],
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
              );
            },
          ),
          onRefresh: () async {
            dataRefresher(digiPM);
          }),
    );
  }

  Widget determineButtonAction(
      caller, DigiPMProvider digiPM, context, task, index) {
    log(caller);
    if (caller == "trline") {
      return Text("");
    } else if (caller == "ucf_exe") {
      return Row(
        children: <Widget>[
          FlatButton.icon(
            color: Colors.green,
            textColor: Colors.white,
            icon: Icon(Icons.assignment),
            label: Text('Confirm'),
            onPressed: () {
              setConfirm(task, digiPM, context);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          FlatButton.icon(
            color: Colors.red,
            textColor: Colors.white,
            icon: Icon(Icons.assignment),
            label: Text('Unconfirm'),
            onPressed: () {
              setUnConfirm(task, digiPM, context);
            },
          ),
        ],
      );
    } else {
      return Padding(
          padding: EdgeInsets.only(left: 5),
          child: FlatButton.icon(
            color: Colors.green,
            textColor: Colors.white,
            icon: Icon(Icons.add_to_home_screen),
            label: Text('Delegate'),
            onPressed: () {
              choosePerson(digiPM, index, task, context);
            },
          ));
    }
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

  confirmExecution(
      DigiPMProvider digiPM, int i, tasklistUserSpvDaily, context) {
    if (caller == "pending") {
      return;
    }
    if (caller == "trline" || caller == "ucf_exe") {
      log(caller);
      Api.getTasklistExe(tasklistUserSpvDaily['id_assignment']).then((val) {
        digiPM.setSelectedExeTasklistUser(val[0]);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FormExeResult()));
      });
    } else {
      clearExeprop(digiPM);
      generateReasonPendingList(digiPM);
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Confirmation'),
              content: new Text('Do you want to execute the tasklist?'),
              actions: <Widget>[
                setPendingFilter(
                    caller, context, digiPM, tasklistUserSpvDaily, i),
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
  }

  Widget setPendingFilter(
      caller, context, DigiPMProvider digiPM, tasklistUserSpvDaily, i) {
    if (caller != "pending") {
      return new FlatButton(
        onPressed: () =>
            confirmReason(digiPM, i, tasklistUserSpvDaily, context),
        child: new Text('Set Pending'),
      );
    } else {
      return new Text("");
    }
  }

  Widget confirmReason(
      DigiPMProvider digiPM, int i, tasklistUserSpvDaily, context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Pending Reason Confirmation'),
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('Please provide the reason for pending'),
                  cekReason(digiPM, i, tasklistUserSpvDaily, context),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Cancel'),
              ),
              new FlatButton(
                onPressed: () => saveAsPending(
                    digiPM, i, "normal", tasklistUserSpvDaily, context),
                child: new Text('Set Pending'),
              ),
            ],
          ),
        ) ??
        false;
  }

  goToExecutionTask(DigiPMProvider digiPM, int i, context) {
    Navigator.of(context).pop(false);
    digiPM.setSelectedTasklistUser(digiPM.tasklistUserSpvDaily[i]);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Execution(
                  tasklistUser: digiPM.tasklistUserSpvDaily[i],
                  caller: caller,
                )));
  }

  Widget cekReason(
      DigiPMProvider digiPM, int i, tasklistUserSpvDaily, context) {
    if (digiPM.lossTree == null) {
      return generateDropdownLoading("Loading...");
    } else {
      return generateLostTree(
          digiPM.lossTree, digiPM, i, tasklistUserSpvDaily, context);
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

  Widget generateLostTree(List<dynamic> data, DigiPMProvider digiPM, int i,
      tasklistUserSpvDaily, context) {
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
          fillFormOther(digiPM, i, tasklistUserSpvDaily, context);
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

  void fillFormOther(
      DigiPMProvider digiPM, int i, tasklistUserSpvDaily, context) {
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
            onPressed: () {
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
            },
            child: new Text('Cancel'),
          ),
          new FlatButton(
            onPressed: () => saveAsPending(
                digiPM, i, "other", tasklistUserSpvDaily, context),
            child: new Text('Set Pending'),
          ),
        ],
      ),
    );
  }

  saveAsPending(DigiPMProvider digiPM, int i, String from, tasklistUserSpvDaily,
      context) {
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
      if (digiPM.executionProperty["pending_reason_status"].toString() == "9") {
        fillFormOther(digiPM, i, tasklistUserSpvDaily, context);
        return;
      }

      digiPM.executionProperty
          .removeWhere((key, value) => key == "photo_evidence_before");
      digiPM.executionProperty
          .removeWhere((key, value) => key == "photo_evidence_after");
      digiPM.executionProperty.removeWhere((key, value) => key == "btnColor");

      Api.savePendingTasklist({
        'tasklist': tasklistUserSpvDaily,
        'prop': digiPM.executionProperty
      }).then((val) async {
        if (val['code_status'] == 1) {
          Util.alert(context, "Success", "Tasklist has been pending")
              .then((val) async {
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var data = {};
            data['id_supervisor'] = prefs.getString("id_user");

            if (caller == "team") {
              data['man_power'] = '2';
              data['status'] = '1';
            } else if (caller == "pending") {
              data['man_power'] = "0";
              data['status'] = "4";
            } else {
              data['man_power'] = '1';
              data['status'] = '1';
            }

            digiPM.setLoadingState(true);
            await digiPM.getDailySupervisor(data);
            await digiPM.getWeeklySupervisor(data);
            digiPM.setLoadingState(false);
          });
        }
      });
    }

    if (from == "other") {
      if (digiPM.executionProperty["other_reason_text"].toString() == "") {
        Navigator.of(context).pop(false);
        Util.alert(
            context, "Validation", "Please fill the form before submitting");
        return;
      } else {
        digiPM.executionProperty
            .removeWhere((key, value) => key == "photo_evidence_before");
        digiPM.executionProperty
            .removeWhere((key, value) => key == "photo_evidence_after");
        digiPM.executionProperty.removeWhere((key, value) => key == "btnColor");

        Api.savePendingTasklist({
          'tasklist': tasklistUserSpvDaily,
          'prop': digiPM.executionProperty
        }).then((val) async {
          if (val['code_status'] == 1) {
            Util.alert(context, "Success", "Tasklist has been pending")
                .then((val) async {
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var data = {};
              data['id_supervisor'] = prefs.getString("id_user");

              if (caller == "team") {
                data['man_power'] = '2';
                data['status'] = '1';
              } else if (caller == "pending") {
                data['man_power'] = "0";
                data['status'] = "4";
              } else {
                data['man_power'] = '1';
                data['status'] = '1';
              }

              digiPM.setLoadingState(true);
              await digiPM.getDailySupervisor(data);
              await digiPM.getWeeklySupervisor(data);
              digiPM.setExeItem('other_reason_text', "");
              digiPM.setLoadingState(false);
            });
          }
        });
      }
    }
  }

  determineRating(task, DigiPMProvider digiPM, context) {
    if (caller == "trline") {
      if (task['assignment_status'] == '2') {
        if (task['rating'] == null) {
          return Padding(
              padding: EdgeInsets.only(left: 5),
              child: FlatButton.icon(
                color: Colors.green,
                textColor: Colors.white,
                icon: Icon(Icons.star),
                label: Text('Rate'),
                onPressed: () {
                  setRating(task, digiPM, context);
                },
              ));
        } else {
          return Row(
            children: <Widget>[
              Text("Rating : "),
              RatingBar(
                initialRating: double.parse(task['rating']),
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 20,
                ignoreGestures: true,
                itemCount: 5,
                tapOnlyMode: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              )
            ],
          );
        }
      }
    } else {
      return Text("");
    }
  }

  void setRating(task, DigiPMProvider digiPM, context) {
    showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Technician Rating'),
            content: RatingBar(
              initialRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                digiPM.ratingSelectedTasklist = rating;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Cancel'),
              ),
              new FlatButton(
                onPressed: () => saveRate(task, digiPM, context),
                child: new Text('Set Rating'),
              ),
            ],
          ),
        ) ??
        false;
  }

  saveRate(task, DigiPMProvider digiPM, context) async {
    var val = await Api.saveRating({
      'id_assignment': task['id_assignment'].toString(),
      'rating': digiPM.ratingSelectedTasklist.toString()
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {};
    data['id_supervisor'] = prefs.getString("id_user");
    data['man_power'] = "0";
    data['status'] = "2";
    data['is_ready_rating'] = "1";

    if (val['code_status'] == 1) {
      await Util.alert(context, "Success", "Rating has been saved");
      Navigator.of(context).pop(false);
      await digiPM.getDailySupervisor(data);
      await digiPM.getWeeklySupervisor(data);
    }
  }

  choosePerson(DigiPMProvider digiPM, int i, task, context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirmation'),
            content: Container(
              height: 100,
              child: SingleChildScrollView(scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text('Please choose Person for delegation'),
                    cekPerson(digiPM, i),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Cancel'),
              ),
              new FlatButton(
                onPressed: () => delegeteTasklist(task, digiPM, context),
                child: new Text('Set Delegation'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget generatePersonList(List<dynamic> data, DigiPMProvider digiPM, int i) {
    var listTreeDropdown = new List<DropdownMenuItem<dynamic>>();

    listTreeDropdown.add(DropdownMenuItem(
      child: Text("SELECT PERSON"),
      value: "",
    ));

    data.forEach((user) {
      listTreeDropdown.add(DropdownMenuItem(
        child: Text(user['employee_name']),
        value: user['id'].toString(),
      ));
    });

    return FormBuilderDropdown(
      isExpanded: false,
      attribute: "Person List",
      decoration: InputDecoration(labelText: "Person List"),
      initialValue: listTreeDropdown[0].value,
      hint: Text('Person List'),
      onChanged: (val) {
        digiPM.selectedUserDelegation = val;
      },
      validators: [FormBuilderValidators.required()],
      items: listTreeDropdown,
    );
  }

  cekPerson(DigiPMProvider digiPM, int i) {
    if (digiPM.userList == null) {
      return generateDropdownLoading("Loading...");
    } else {
      return generatePersonList(digiPM.userList, digiPM, i);
    }
  }

  delegeteTasklist(task, DigiPMProvider digiPM, context) async {
    Util.loader(context, "", "Delegating...");

    if (digiPM.selectedUserDelegation.toString() == "") {
      Navigator.of(context).pop(false);
      Util.alert(context, "Validation", "Please select person to delegate");
    } else if (digiPM.selectedUserDelegation.toString() == "null") {
      Navigator.of(context).pop(false);
      Util.alert(context, "Validation", "Please select person to delegate");
    } else {
      var val = await Api.saveDelegation({
        'id_assignment': task['id_assignment'].toString(),
        'id_person': digiPM.selectedUserDelegation
      });

      if (val['code_status'] == 1) {
        Util.alert(context, "Success", "Tasklist has been delegated")
            .then((val) async {
          Navigator.of(context).pop(false);
          Navigator.of(context).pop(false);
          digiPM.setLoadingState(true);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var data = {};
          data['id_supervisor'] = prefs.getString("id_user");

          if (caller == "team") {
            data['man_power'] = '2';
            data['status'] = '1';
          } else if (caller == "pending") {
            data['man_power'] = "0";
            data['status'] = "4";
          } else {
            data['man_power'] = '1';
            data['status'] = '1';
          }

          await digiPM.getDailySupervisor(data);
          await digiPM.getWeeklySupervisor(data);
          digiPM.setLoadingState(false);
          digiPM.selectedUserDelegation = null;
        });
      }
    }
  }

  void setConfirm(task, DigiPMProvider digiPM, context) {
    showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirmation'),
            content: new Text('Do you want to confirm the execution result?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => executionConfirmResult(task, digiPM, context),
                child: new Text('Confirm Execution Result'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void executionConfirmResult(task, DigiPMProvider digiPM, context) {
    Util.loader(context, "Confirming", 'Confirming...');

    Api.setConfirmTasklist(task['id_assignment'], task['id_execution'])
        .then((val) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = {};
      data['id_supervisor'] = prefs.getString("id_user");
      data['man_power'] = "0";
      data['status'] = "2";
      data['is_ready_rating'] = "0";
      data['reason'] = "1";

      if (val == "timeout") {
        Util.alert(context, "Error",
                "Network error. please check your internet network")
            .then((val) {
          Navigator.of(context).pop(true);
        });
      }

      if (val == "offline") {
        Util.alert(context, "Error",
                "Network error. please check your internet network")
            .then((val) {
          Navigator.of(context).pop(true);
        });
      }

      if (val['status'] == true) {
        await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Technician Rating'),
            content: RatingBar(
              initialRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                digiPM.ratingSelectedTasklist = rating;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => saveRate(task, digiPM, context),
                child: new Text('Set Rating'),
              ),
            ],
          ),
        );
        await Util.alert(context, "Success", "Tasklist has been confirmed");
        Navigator.of(context).pop(false);
        Navigator.of(context).pop(false);
        digiPM.setLoadingState(true);
        await digiPM.getDailySupervisor(data);
        await digiPM.getWeeklySupervisor(data);
        digiPM.setLoadingState(false);
      }
    });
  }

  void setUnConfirm(task, DigiPMProvider digiPM, context) {
    showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirmation'),
            content: new Text('Do you want to unconfirm the execution result?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Util.loader(context, "Uconfirming", 'Unconfirming...');

                  Api.setUnConfirmTasklist(task['id_assignment'])
                      .then((val) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var data = {};
                    data['id_supervisor'] = prefs.getString("id_user");
                    data['man_power'] = "0";
                    data['status'] = "2";
                    data['is_ready_rating'] = "0";
                    data['man_power'] = "0";
                    data['reason'] = "1";
                    if (val['status'] == true) {
                      Navigator.of(context).pop(false);
                      await Util.alert(
                          context, "Success", "Tasklist has been unconfirmed");
                      Navigator.of(context).pop(false);
                      digiPM.setLoadingState(true);
                      await digiPM.getDailySupervisor(data);
                      await digiPM.getWeeklySupervisor(data);
                      digiPM.setLoadingState(true);
                    }
                  });
                },
                child: new Text('Unconfirm'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
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
