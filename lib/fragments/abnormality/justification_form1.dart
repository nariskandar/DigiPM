import 'dart:convert';
import 'dart:io';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:digi_pm_skin/models/sbu.dart';
import 'package:digi_pm_skin/api/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:digi_pm_skin/util/util.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';

class JustificationForm1 extends StatefulWidget {
  Map <String, dynamic> data;

  JustificationForm1({Key key, @required this.data}) : super(key : key);

  @override
  _JustificationForm1State createState() => _JustificationForm1State(data);
}

class _JustificationForm1State extends State<JustificationForm1> {
  Map <String, dynamic> data;

  _JustificationForm1State(this.data);
  DateTime selectedDateExe;


  String valLevel1, valLevel2, valSuggestion, valAssignedPillar;
  String valIdJustification;
  double valManning = 0;
  TextEditingController valdDuration;

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
    // print(listDataSuggestion);
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
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
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
                          SizedBox( height: 10,),
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
                                          // .split(' ')[0]
                                          child:
                                              selectedDateExe == null ? Text('- - - - : - - : - -', style: TextStyle(fontSize: 16),) :
                                          Text("${selectedDateExe.toLocal()}".split(' ')[0], style: TextStyle(fontSize: 16),),
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
                    // tes(context, digiPM);
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

  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    var employeeName = prefs.getString("employee_name");
    setState(() {
      // _valEmployeeId = employeeId;
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

    print(widget.data);

    final data = {
      'ewo_id' : widget.data['id'],
      'root_cause' : valIdJustification,
      'manning' : valManning,
      'std_durasi' : valdDuration.text,
      'execution_date' : "${selectedDateExe.toLocal()}".split(' ')[0],
    };
    print(data);

    // Navigator.push(context, MaterialPageRoute(builder: (context) => ))
    // Navigator.push(context, MaterialPageRoute(builder: (context) => AbnormalityForm2(form : data, picture: _storedImage)));

  }


}
