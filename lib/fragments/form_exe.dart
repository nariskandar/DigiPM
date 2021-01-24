import 'dart:convert';
import 'dart:developer';

import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/pages/Home.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'execution.dart';

class FormExe extends StatelessWidget {
  final caller;
  const FormExe({Key key, this.caller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      log("Form Exe rendered");
      log(caller.toString());
      return Container(
          child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ExecutionAction(),
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                    ),
                    Container(
                        child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: digiPM.executionProperty['max_photo'],
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(
                          digiPM.executionProperty['max_photo'], (index) {
                        List<dynamic> property =
                            digiPM.executionProperty['photo_evidence_before'];

                        if (property[index]['img'] == null) {
                          return Container(
                            margin: EdgeInsets.all(1),
                            child: Center(
                              child: Icon(Icons.camera_alt),
                            ),
                            color: Colors.grey,
                          );
                        }
                        
                        return Container(
                            child: Image.file(
                          property[index]['img'],
                          fit: BoxFit.cover,
                        ));
                      }),
                    )),
                    FlatButton.icon(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      icon: Icon(Icons.add_a_photo),
                      label: setLabelFotoBefore(digiPM.selectedTasklist),
                      onPressed: () async {
                        await getImageBefore(context, digiPM);
                      },
                    ),
                    Container(
                        child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: digiPM.executionProperty['max_photo'],
                      children: List.generate(
                          digiPM.executionProperty['max_photo'], (index) {
                        List<dynamic> property =
                            digiPM.executionProperty['photo_evidence_after'];

                        if (property[index]['img'] == null) {
                          return Container(
                            margin: EdgeInsets.all(1),
                            child: Center(
                              child: Icon(Icons.camera_alt),
                            ),
                            color: Colors.grey,
                          );
                        }

                        return Container(
                            child: Image.file(
                          property[index]['img'],
                          fit: BoxFit.cover,
                        ));
                      }),
                    )),
                    FlatButton.icon(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      icon: Icon(Icons.add_a_photo),
                      label: setLabelFotoAfter(digiPM.selectedTasklist),
                      onPressed: () async {
                        await getImageAfter(context, digiPM);
                      },
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: FormBuilderRadio(
                    decoration: InputDecoration(
                      labelText: 'Apakah pekerjaan telah selesai dilaksanakan?',
                    ),
                    attribute: "otif_confirm",
                    initialValue: "",
                    onChanged: (val) {
                      setStatus(digiPM, val);
                    },
                    validators: [FormBuilderValidators.required()],
                    options: ["Ya", "Tidak"]
                        .map((lang) => FormBuilderFieldOption(value: lang))
                        .toList(growable: false),
                  )),
              Container(
                padding: EdgeInsets.all(20),
                child: cekReason(digiPM),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Recommendation",
                    hintText: "Fill Recommendation",
                  ),
                  onChanged: (val) {
                    digiPM.setExeItem("recommendation_text", val);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              MaterialButton(
                onPressed: () {
                  if (digiPM.executionProperty['secondExeCount'] <= 0) {
                    Util.alert(
                        context,
                        "Validation Error",
                        "You have to "
                            "run execution time before finishing execution");
                    return;
                  }

                  var statusPhotoBefore = false;
                  var statusPhotoAfter = false;

                  for (var item
                      in digiPM.executionProperty['photo_evidence_before']) {
                    if (item['img_path'] != null) statusPhotoBefore = true;
                  }

                  for (var item
                      in digiPM.executionProperty['photo_evidence_after']) {
                    if (item['img_path'] != null) statusPhotoAfter = true;
                  }

                  if (!statusPhotoBefore) {
                    Util.alert(
                        context,
                        "Validation Error",
                        "You have to "
                            "provide photo before");
                    return;
                  }

                  if (!statusPhotoAfter) {
                    Util.alert(
                        context,
                        "Validation Error",
                        "You have to "
                            "provide photo after");
                    return;
                  }

                  if (digiPM.executionProperty['execution_status'] == null) {
                    Util.alert(
                        context,
                        "Validation Error",
                        "You have to "
                            "select confirmation done (Yes or no)");
                    return;
                  }

                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Do you want to finish execution?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('YES'),
                            onPressed: () {
                              saveExecutionResult(context, digiPM);
                            },
                          ),
                          FlatButton(
                            child: Text('NO'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Finish Execution"),
                padding:
                    EdgeInsets.only(right: 30, left: 30, top: 15, bottom: 15),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
            ],
          )
        ],
      ));
    });
  }

  Widget cekReason(DigiPMProvider digiPM) {
    if (digiPM.executionProperty['execution_status'] == null) {
      return Text("");
    } else if (digiPM.executionProperty['execution_status'] == 1) {
      return Text("");
    }
    // else if (digiPM.executionProperty['execution_status'] == 0) {
    //   if (digiPM.lossTree == null) {
    //     return generateDropdownLoading("Loading...");
    //   } else {
    //     return generateLostTree(digiPM.lossTree, digiPM);
    //   }
    // }

    return Text("");
  }

  Widget generateLostTree(List<dynamic> data, DigiPMProvider digiPM) {
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
      },
      validators: [FormBuilderValidators.required()],
      items: listTreeDropdown,
    );
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

  void setStatus(DigiPMProvider digiPM, val) {
    if (val == "Ya") {
      digiPM.setExeItem("execution_status", 1);
    } else {
      // if (digiPM.lossTree == null) {
      //   Api.getLostTree().then((val) {
      //     digiPM.setLostTree(val);
      //   });
      // }

      // digiPM.setExeItem("execution_status", 1);
    }
  }

  Future getImageBefore(context, DigiPMProvider digiPM) async {
    await digiPM.getImageBefore();
    return Future.value(false);
  }

  Future getImageAfter(context, DigiPMProvider digiPM) async {
    await digiPM.getImageAfter();
    return Future.value(false);
  }

  Widget setLabelFotoBefore(selectedTasklist) {
    if (selectedTasklist['category'] == 'TBM') {
      return Text('Tambah Foto Baru yang telah diganti');
    } else if (selectedTasklist['category'] == 'IR') {
      return Text('Kondisi Part sebelum diinspeksi/repair');
    } else if (selectedTasklist['category'] == 'CBM') {
      return Text('Kondisi Part sebelum diinspeksi/repair');
    } else if (selectedTasklist['category'] == 'BDM') {
      return Text('Kondisi Part BDM');
    }

    return Text('');
  }

  Widget setLabelFotoAfter(selectedTasklist) {
    if (selectedTasklist['category'] == 'TBM') {
      return Text('Tambah Foto Lama yang telah diganti');
    } else if (selectedTasklist['category'] == 'IR') {
      return Text('Kondisi Part setelah diinspeksi/repair');
    } else if (selectedTasklist['category'] == 'CBM') {
      return Text('Kondisi Part setelah dilakukan CBM');
    } else if (selectedTasklist['category'] == 'BDM') {
      return Text('Kondisi Part BDM');
    }
    return Text('');
  }

  saveExecutionResult(context, DigiPMProvider digiPM) {
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

    try {
      digiPM.saveExecution(data).then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (val == "timeout") {
          Util.alert(context, "Error",
                  "Network error. please check your internet network")
              .then((val) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        if (val == "offline") {
          Util.alert(context, "Error",
                  "Network error. please check your internet network")
              .then((val) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        var res = jsonDecode(val);

        if (res['code_status'] == 1) {
          await Util.alert(context, "Success", "You have saved the execution");
          if (prefs.getBool("is_supervisor")) {
            digiPM.setExeItem('startExe', null);
            digiPM.setExeItem('secondExeCount',
                digiPM.executionProperty['secondExeCount'] + 1);
            digiPM.setExeItem(
                'counterSecond', digiPM.executionProperty['secondExeCount']);
            digiPM.setExeItem('isStarting', false);
            digiPM.setExeItem('hasExecuted', true);
            digiPM.setExeItem('btnColor', Colors.grey);
            digiPM.setExeItem('txtButton', "Executed");
            clearExeprop(digiPM);

            await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return new Home(
                backFrom: caller,
              );
            }), (Route<dynamic> route) => false);

            if (caller == "team") {
              data['man_power'] = "2";
              data['status'] = "1";
            } else {
              data['man_power'] = "1";
              data['status'] = "1";
            }
            data['id_supervisor'] = prefs.getString("id_user");
            await digiPM.getDailySupervisor(data);
            await digiPM.getWeeklySupervisor(data);
          } else {
            digiPM.setExeItem('startExe', null);
            digiPM.setExeItem('secondExeCount',
                digiPM.executionProperty['secondExeCount'] + 1);
            digiPM.setExeItem(
                'counterSecond', digiPM.executionProperty['secondExeCount']);
            digiPM.setExeItem('isStarting', false);
            digiPM.setExeItem('hasExecuted', true);
            digiPM.setExeItem('btnColor', Colors.grey);
            digiPM.setExeItem('txtButton', "Executed");
            clearExeprop(digiPM);
            await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return new Home();
            }), (Route<dynamic> route) => false);
            await digiPM.getUserTasklist({
              'id_user': prefs.getString("id_user"),
              'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
            }, context);
          }
        }
      });
    } catch (e) {
      Util.alert(context, "Error",
              "Internal error occured. Please contact developer"
      )
          .then((val) async {
        clearExeprop(digiPM);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        digiPM.getUserTasklist({
          'id_user': prefs.getString("id_user"),
          'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
        }, context);

        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
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

  void checkExeItem(digiPM, context) {
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
  }
}
