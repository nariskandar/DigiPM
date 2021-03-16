import 'package:digi_pm_skin/fragments/abnormality/summary.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:digi_pm_skin/fragments/abnormality/justification_form2.dart';

class JustificationForm1 extends StatefulWidget {
  Map<String, dynamic> data;
  // String ewoId;

  JustificationForm1({Key key, @required this.data}) : super(key : key);

  @override
  _JustificationForm1State createState() => _JustificationForm1State(data);
}

class _JustificationForm1State extends State<JustificationForm1> {
  Map<String, dynamic> data;

  _JustificationForm1State(this.data);
  DateTime selectedDateExe;

  String valLevel1, valLevel2, valSuggestion, valAssignedPillar;
  String valIdJustification;
  double valManning = 0;
  TextEditingController valdDuration;
  String valEmployeeId;

  List <dynamic> listLevel1 = List();
  List <dynamic> listLevel2 = List();
  List <dynamic> listSuggestion = List();

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

  void getSuggestion (String level1, String level2) async {
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
    _setEmployeeId();
  }

  @override
  void dispose() {
    valdDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return WillPopScope(
        onWillPop: (){
          onDialogCancel(context, 'Confirmation',
              'Do you want to go back to the previous page?', abnormality);
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
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(13),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            prefixIcon: Icon(Icons.timer)
                                          ),
                                        )
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(height: 10,),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Execution Date :', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
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
                                          ),Expanded(
                                            flex: 3,
                                            child:
                                                selectedDateExe == null ? Text('Day : Month : Year', style: TextStyle(fontSize: 16),) :
                                            Text(DateFormat('dd-MM-yyyy').format(selectedDateExe.toLocal()), style: TextStyle(fontSize: 16),),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        ),
                    ],
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      saveJustificationForm1(context, digiPM);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    label: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              // print(widget.data);
              Util.showPopup(context, _popupBody(), 'Summary');
            },
            heroTag: 'demoValue',
            tooltip: 'Justification',
            child: Icon(Icons.info),
          ),
        ),
      );
    });
  }

  Widget _popupBody() {
    return Container(
      child: Summary(data : widget.data),
    );
  }
  
  selectDateExe(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:  DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
      if(picked != null && picked != selectedDateExe)
    setState(() {
      selectedDateExe = picked;
      });
  }

  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    var employeeName = prefs.getString("employee_name");
    setState(() {
      valEmployeeId = employeeId;
      // _valEmployeeName = employeeName;
    });
  }

  void reloadUser() {
    SharedPreferences.getInstance().then((prefs) {
      Api.getUserlogin(prefs.getString("id_user")).then((val) {
        setState(() {
          user_login = val;
        });
      });
    });
  }



  saveJustificationForm1(context, DigiPMProvider digiPM) {
    
    if(valLevel1 == null) {
      Util.alert(context, 'Validation', 'Please Select Rootcause Level 1');
      return;
    }

    if(valLevel2 == null){
      Util.alert(context, 'Validation', 'Please Select Rootcause Level 2');
      return;
    }

    if(valManning == null) {
      Util.alert(context, 'Validation', 'Please fill Manning');
      return;
    }

    if(valdDuration == null) {
      Util.alert(context, 'Validation', 'Pease fill std duration');
    }

    if(selectedDateExe == null){
      Util.alert(context, 'Validation', 'Please select execution date');
      return;
    }

    final data = {
      'ewo_id' : widget.data['id'],
      'root_cause_id' : valIdJustification,
      'pillar' : valAssignedPillar,
      'manning' : valManning,
      'std_durasi' : valdDuration.text,
      'execution_date' : DateFormat('dd-MM-yyyy').format(selectedDateExe.toLocal()),
      'created_by' : valEmployeeId
    };
    Navigator.push(context, MaterialPageRoute(builder: (context) => JustificationForm2(data: data)));
  }


  onDialogCancel(BuildContext context, String title, String content,
      AbnormalityProvider abnormality) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  // clearFormData(abnormality);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  dataRefresher(abnormality);
                }),
          ],
        );
      },
    );
  }

  void dataRefresher(AbnormalityProvider abnormality) async {
    abnormality.setLoadingState(true);
    await abnormality.getEWO(context,'PM03');
    abnormality.setLoadingState(false);
  }
}