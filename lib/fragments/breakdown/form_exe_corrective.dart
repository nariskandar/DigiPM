import 'dart:convert';
import 'dart:developer';

import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/fragments/breakdown/timer_execution.dart';
import 'package:digi_pm_skin/fragments/execution.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormCorrectiveAction extends StatelessWidget {
  String ewoId;

  FormCorrectiveAction({Key key, this.ewoId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, BreakdownProvider>(
      builder: (context, digiPM, breakdown, _){
        return StatefulWrapper(
          onInit: ()async{
            await breakdown.getEWODetail(breakdown.pm_type, ewoId);
          },
          child: Container(
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ExecutionActionCorrective(),
                            margin: EdgeInsets.only(bottom: 10, top: 10),
                          ),
                          Container(
                            child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: breakdown.executionCorrectiveProperty['max_photo'],
                              children: List.generate(breakdown.executionCorrectiveProperty['max_photo'], (index) {

                                List<dynamic> property = breakdown.executionCorrectiveProperty['photo_evidence_before'];

                                if(property[index]['img'] == null) {
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
                                    property[index]['img'], fit: BoxFit.cover,
                                  ),
                                );

                              }),
                            ),
                          ),
                          FlatButton.icon(
                              onPressed: () async {
                                await getImageBefore(context, breakdown);
                              },
                              color: Theme.of(context).accentColor,
                              textColor: Colors.white,
                              icon: Icon(Icons.add_a_photo),
                              label: Text('Photo Before Execution')),
                          Container(
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: breakdown.executionCorrectiveProperty['max_photo'],
                              children: List.generate(breakdown.executionCorrectiveProperty['max_photo'], (index) {
                                List<dynamic> property =
                                    breakdown.executionCorrectiveProperty['photo_evidence_after'];

                                if(property[index]['img'] == null){
                                  return Container(
                                    margin: EdgeInsets.all(1),
                                    child: Center(child: Icon(Icons.camera_alt),),
                                    color: Colors.grey,
                                  );
                                }

                                return Container(
                                  child: Image.file(
                                    property[index]['img'],
                                    fit: BoxFit.cover,
                                  ),
                                );

                              }),
                            ),
                          ),
                          FlatButton.icon(
                            color: Theme.of(context).accentColor,
                              textColor: Colors.white,
                              onPressed: () async {
                              await getImageAfter(context, breakdown);
                              },
                              icon: Icon(Icons.camera_alt),
                              label: Text('Photo After Execution')
                          )
                        ],
                      ),
                    ),
                    Container(
                     padding: EdgeInsets.all(20),
                     child: FormBuilderRadio(
                       decoration: InputDecoration(
                         labelText: 'Apakah Pekerjaan telah selesai dilaksanakan ?',
                       ),
                       attribute: 'otif_confirm',
                       initialValue: '',
                       onChanged: (val){
                         setStatus(breakdown, val);
                       },
                       validators: [FormBuilderValidators.required()],
                       options: ["Ya", "Tidak"]
                           .map((lang) => FormBuilderFieldOption(value: lang,))
                           .toList(growable: false),
                     ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: cekReason(breakdown),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Tindakan terhadap penyebab",
                          hintText: "Mohon isi tindakan terhadap penyebab"
                        ),
                        onChanged: (val){
                          breakdown.setExecutionCorrectivePropertyItem("recommendation_text", val);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                    MaterialButton(
                      onPressed: (){

                        if(breakdown.executionCorrectiveProperty['secondExeCount'] <= 0){
                          Util.alert(context, "Validation Error", "You have to " "run execution time before finishing execution");
                          return;
                        }

                        var statusPhotoBefore = false;
                        var statusPhotoAfter = false;

                        for (var item in breakdown.executionCorrectiveProperty['photo_evidence_before']){
                          if(item['img_path'] != null) statusPhotoBefore = true;
                        }

                        for (var item in breakdown.executionCorrectiveProperty['photo_evidence_after']){
                          if(item['img_path'] != null) statusPhotoAfter = true;
                        }

                        if(!statusPhotoBefore){
                          Util.alert(context,
                              "Validation Error",
                              "You have to "
                                  "provide photo before");
                          return;
                        }

                        if(!statusPhotoAfter){
                          Util.alert(context,
                              "Validation Error",
                              "You have to "
                                  "provide photo after");
                          return;
                        }

                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text('Do you want to finisih execution ?'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('YES'),
                                    onPressed: (){
                                      saveExecutionResult(context, breakdown);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('NO'),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            }
                        );
                      },

                      child: Text('Finisih Execution'),
                      padding: EdgeInsets.only(right: 30, left: 30, top: 15, bottom: 15),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20),)
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cekReason(BreakdownProvider breakdown) {
    if(breakdown.executionCorrectiveProperty['execution_status'] == null){
      return Text("");
    } else if (breakdown.executionCorrectiveProperty['execution_status'] == 1){
      return Text("");
    }
    return Text("");
  }

  Future getImageBefore(context, BreakdownProvider breakdown) async {
    await breakdown.getImageBefore();
    return Future.value(false);
  }

  Future getImageAfter(context, BreakdownProvider breakdown) async {
    await breakdown.getImageAfter();
    return Future.value(false);
  }

  void setStatus(BreakdownProvider breakdown, val) {
    if(val == "Ya") {
      breakdown.setExecutionCorrectivePropertyItem("execution_status", 1);
    } else {
      // if(breakdown.l)
    }
  }

  saveExecutionResult(context, BreakdownProvider breakdown) async {
    Util.loader(context, "", "Saving...");
    var data = {
      'before'  : breakdown.executionCorrectiveProperty['photo_evidence_before'],
      'after'   : breakdown.executionCorrectiveProperty['photo_evidence_after'],
      'payload' : {
        'id' : null,
        'status_exe' : breakdown.executionCorrectiveProperty['execution_status'],
        'second_exe' : breakdown.executionCorrectiveProperty['secondExeCount'],
        'recommendation_text' : breakdown.executionCorrectiveProperty['recommendation_text'],
        'other_reason_text'   : breakdown.executionCorrectiveProperty['other_reason_text'],
        'banner_exe'          : breakdown.executionCorrectiveProperty['bannerExe'],
        'exec_date'           : breakdown.executionCorrectiveProperty['exec_date'],
        'finish_date'        : breakdown.executionCorrectiveProperty['finish_date'],
        'id_schedule'          : breakdown.EWODetail['TECHNICIAN_ASSIGNMENT_PM02'],
        'ewo_id'                : breakdown.EWODetail['id'],
        'employee_id'           : breakdown.EWODetail['EMPLOYEE_ID']
      },
    };

    try {
      breakdown.saveExeCorrective(data).then((val) async {
        var res = jsonDecode(val);
        if(res['code_status'] == 1){
          await Util.alert(context, 'Success', 'You have saved the execution', 'exeCorrective');
          clearExeprop(breakdown);
        }

      });
    } catch (e) {
      print(e.toString());
    }

  }

  void clearExeprop (BreakdownProvider breakdown) {
    breakdown.setExecutionCorrectivePropertyItem('startExe', null);
    breakdown.setExecutionCorrectivePropertyItem('isStarting', false);
    breakdown.setExecutionCorrectivePropertyItem('hasExecuted', false);
    breakdown.setExecutionCorrectivePropertyItem('txtButton', 'Start Execution');
    breakdown.setExecutionCorrectivePropertyItem('counterSecond', 0);
    breakdown.setExecutionCorrectivePropertyItem('secondExeCount', 0);
    breakdown.setExecutionCorrectivePropertyItem('btnColor', Colors.green);
    breakdown.setExecutionCorrectivePropertyItem('bannerResult', null);
    breakdown.setExecutionCorrectivePropertyItem('bannerExe', "00:00");
    breakdown.setExecutionCorrectivePropertyItem('exec_date', null);
    breakdown.setExecutionCorrectivePropertyItem('finish_date', null);
    breakdown.setExecutionCorrectivePropertyItem('max_photo', 3);
    breakdown.setExecutionCorrectivePropertyItem('photo_evidence', []);
    breakdown.setExecutionCorrectivePropertyItem('photo_evidence_before', [
      {'img_path': null, 'img' : null},
      {'img_path': null, 'img' : null},
      {'img_path': null, 'img' : null}
    ]);
   breakdown.setExecutionCorrectivePropertyItem('photo_before_counter', 0);
   breakdown.setExecutionCorrectivePropertyItem('photo_evidence_after', [
     {'img_path': null, 'img' : null},
     {'img_path': null, 'img' : null},
     {'img_path': null, 'img' : null}
   ]);
   breakdown.setExecutionCorrectivePropertyItem('photo_after_counter', 0);
   breakdown.setExecutionCorrectivePropertyItem('execution_status', null);
   breakdown.setExecutionCorrectivePropertyItem('pending_reason_status', 0);
   breakdown.setExecutionCorrectivePropertyItem('other_reason_text', '');
   breakdown.setExecutionCorrectivePropertyItem('recommendation_text', '');
   breakdown.setExecutionCorrectivePropertyItem('updateFromRating', false);

  }

  // void checkExeCorrectiveItem(BreakdownProvider breakdown, context){
  //   if(breakdown.executionCorrectiveProperty['isStarting'] == true) {
  //     Util.alert(context, 'Validation Error', content)
  //   }
  // }






}
