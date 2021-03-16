import 'dart:convert';

import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/breakdown/form_submission.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/material.dart';

class FormJustification1 extends StatefulWidget {
  Map<String, dynamic> data;
  @override
  FormJustification1({Key key, @required this.data}) : super(key: key);
  _FormJustification1State createState() => _FormJustification1State();
}

class _FormJustification1State extends State<FormJustification1> {
  Map<String, dynamic> data;

  DateTime selectedDateExe;

  String valLevel1, valLevel2, valSuggestion, valAssignedPillar;
  String valIdJustification;
  double valManning = 0;
  TextEditingController valdDuration;

  final valTindakan1 = TextEditingController();
  final valTindakan2 = TextEditingController();
  final valTindakan3 = TextEditingController();
  final valTindakan4 = TextEditingController();
  final valTindakan5 = TextEditingController();
  final valTindakan6 = TextEditingController();

  List<dynamic> listLevel1 = List();
  List<dynamic> listLevel2 = List();
  List<dynamic> listSuggestion = List();

  void getLevel1() async {
    var listDataLevel1 = await Api.getJustification();
    setState(() {
      listLevel1 = listDataLevel1;
    });
  }

  void getLevel2(String level1) async {
    var listDataLevel2 = await Api.getJustification(level1);
    setState(() {
      listLevel2 = listDataLevel2;
    });
  }

  void getSuggestion(String level1, String level2) async {
    var listDataSuggestion = await Api.getJustification(level1, level2);
    setState(() {
      listSuggestion = listDataSuggestion;

      listSuggestion.forEach((element) {
        valSuggestion = element['suggestion'];
        valAssignedPillar = element['assigned_pillar'];
        valIdJustification = element['id'];
      });
    });
  }

  var user_login;

  @override
  void initState() {
    valdDuration = TextEditingController();
    valdDuration.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
    getLevel1();
  }

  @override
  void dispose() {
    valdDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, BreakdownProvider>(
        builder: (context, digiPM, breakdown, _) {
      return WillPopScope(
        onWillPop: () {
          onDialogCancel(context, 'Confirmation',
              'Do you want to go back to the previous page?', breakdown);
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('EWO Rootcause Classification'),
            ),
            body: Container(
              child: Card(
                margin: EdgeInsets.all(7),
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Rootcause Level 1',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text("-- SELECT --"),
                              value: valLevel1,
                              items: listLevel1.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['level_1']),
                                  value: item['level_1'],
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  valLevel1 = value;
                                  valLevel2 = null;
                                  valSuggestion = null;
                                  valAssignedPillar = null;
                                });
                                getLevel2(value);
                              },
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Rootcause Level 2',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text("-- SELECT --"),
                              value: valLevel2,
                              items: listLevel2.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['level_2']),
                                  value: item['level_2'],
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  valLevel2 = value;
                                  valSuggestion = null;
                                  valAssignedPillar = null;
                                });
                                getSuggestion(valLevel1, value);
                              },
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Sugesstion',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: valSuggestion == null
                                      ? ' - '
                                      : '$valSuggestion',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  border: InputBorder.none,
                                  filled: true),
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Assigned Pillar',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: valAssignedPillar == null
                                      ? ' - '
                                      : '$valAssignedPillar',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  border: InputBorder.none,
                                  filled: true),
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Jumlah manning pillar yang dibutuhkan :',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: Slider(
                              value: valManning,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label: valManning.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  valManning = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Std Duration (minutes) :',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                                child: TextField(
                              controller: valdDuration,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Minutes',
                                  prefixIcon: Icon(Icons.timer)),
                            )),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Execution Date :',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          onPressed: () {
                                            selectDateExe(context);
                                          }),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: selectedDateExe == null
                                          ? Text(
                                              'Day : Month : Year',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          : Text(
                                              DateFormat('dd-MM-yyyy').format(
                                                  selectedDateExe.toLocal()),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Follow up Action : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textField('1', valTindakan1),
                      SizedBox(
                        height: 10,
                      ),
                      textField('2', valTindakan2),
                      SizedBox(
                        height: 10,
                      ),
                      textField('3', valTindakan3),
                      SizedBox(
                        height: 10,
                      ),
                      textField('4', valTindakan4),
                      SizedBox(
                        height: 10,
                      ),
                      textField('5', valTindakan5),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton.icon(
                            onPressed: () {
                              onDialogCancel(
                                  context,
                                  'Confirmation',
                                  'Do you want to go back to the previous page?',
                                  breakdown);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            label: Text('Cancel'),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            textColor: Colors.white,
                            splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                            color: Colors.red,
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              onValidateForm(context, breakdown);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            label: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            icon: Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            textColor: Colors.white,
                            splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                            color: Colors.green,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  selectDateExe(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDateExe)
      setState(() {
        selectedDateExe = picked;
      });
  }

  Widget textField(String no, dynamic controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(padding: EdgeInsets.all(15), child: Text('$no. ')),
      ),
    );
  }

  onValidateForm(BuildContext context, BreakdownProvider breakdown) {
    if (valLevel1 == null) {
      Util.alert(context, 'Validation', 'Please Select Rootcause Level 1');
      return;
    }

    if (valLevel2 == null) {
      Util.alert(context, 'Validation', 'Please Select Rootcause Level 2');
      return;
    }

    if (valManning == null) {
      Util.alert(context, 'Validation', 'Please fill Manning');
      return;
    }

    if (valdDuration == null) {
      Util.alert(context, 'Validation', 'Pease fill std duration');
    }

    if (selectedDateExe == null) {
      Util.alert(context, 'Validation', 'Please select execution date');
      return;
    }

    return onDialogSave(context, 'Confirmation',
        'Do data have been filled in correctly?', breakdown);
  }

  onDialogSave(BuildContext context, String title, String content,
      BreakdownProvider breakdown) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: Text('$content'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Save'),
                onPressed: () {saveForm(context, breakdown);},
              )
            ],
          );
        });
  }

  saveForm (BuildContext context, BreakdownProvider breakdown) async {
    // Util.loader(context, "", "Saving...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = {
      'id' : null,
      'ewo_id' : widget.data['id'],
      'root_cause_id' : valIdJustification,
      'pillar' : valAssignedPillar,
      'manning' : valManning,
      'std_durasi' : valdDuration.text,
      'execution_date' : DateFormat('dd-MM-yyyy').format(selectedDateExe.toLocal()),
      'created_by' : prefs.getString('id_user'),
      'action' : {
        'tindakan1' : valTindakan1.text,
        'tindakan2' : valTindakan2.text,
        'tindakan3' : valTindakan3.text,
        'tindakan4' : valTindakan4.text,
        'tindakan5' : valTindakan5.text
      },
    };

    try {
      print(data);
      breakdown.saveJustification(data).then((val) async {
        print('hai');
        print(val);

        // if(val == "timeout"){
        //   Util.alert(context, "Error",
        //       "Network error. please check your internet network")
        //       .then((val) {
        //     Navigator.of(context).pop(true);
        //     Navigator.of(context).pop(true);
        //   });
        // }
        //
        // if (val == "offline") {
        //   Util.alert(context, "Error",
        //       "Network error. please check your internet network")
        //       .then((val) {
        //     Navigator.of(context).pop(true);
        //     Navigator.of(context).pop(true);
        //   });
        // }

        // var resp = json.decode(val);


        if(val['code_status'] == 1){
          await Util.alert(context, 'Success', 'You have saved the justification', 'exeCorrective');
          // clearExeprop(breakdown);
        }


      });
    } catch (e) {

    }

  }

}
