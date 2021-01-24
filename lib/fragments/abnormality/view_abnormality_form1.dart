import 'dart:convert';
import 'dart:io';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'popup.dart';
import 'popup_content.dart';
import 'package:digi_pm_skin/fragments/abnormality/view_abnormality_form2.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:digi_pm_skin/fragments/abnormality/edit_abnormality_form2.dart';
import 'package:digi_pm_skin/api/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:digi_pm_skin/util/util.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as syspaths;


class ViewAbnormalityForm1 extends StatefulWidget {
  Map<String, dynamic> data;

  ViewAbnormalityForm1({Key key, @required this.data}) : super(key: key);

  @override
  _ViewAbnormalityForm1State createState() => _ViewAbnormalityForm1State(data);
}

class _ViewAbnormalityForm1State extends State<ViewAbnormalityForm1> {
  Map<String, dynamic> data;

  _ViewAbnormalityForm1State(this.data);

  String _valSbu, _valLine, _valMachine, _valUnit, _valSubUnit, _valKerusakan, _valPerbaikan, _valActivity, _valPillar, _autoNumber, _valEmployeeId, _valEmployeeName, _valPmaDesc, _valAllDate;

  String _date, _year, _month, _week, _dinas, _hours;

  File _storedImage;


  List<dynamic>
  _dataSbu = List(), _dataLine = List(), _dataMachine = List(), _dataUnit = List(), _dataSubUnit = List(), _dataActivity = List(), _dataPillar = List(), _dataAllDate = List();
  List <dynamic> dataAnswer = List();

  var user_login;


  void getSbu() async {
    var listDataSbu = await Api.getSbu();
    setState(() {
      _dataSbu = listDataSbu;
    });
  }

  void getLine(String sbu) async {
    var listDataLine = await Api.getLine(sbu.toUpperCase());
    setState(() {
      _dataLine = listDataLine;
    });
  }

  void getMachine(String sbu, String line) async {
    var listDataMachine = await Api.getMachine(sbu, line);
    setState(() {
      _dataMachine = listDataMachine;
    });
  }

  void getUnit(String sbu, String line, String machine) async {
    var listDataUnit = await Api.getUnit(sbu, line, machine);
    setState(() {
      _dataUnit = listDataUnit;
    });
  }

  void getSubUnit(String sbu, String line, String machine, String unit) async {
    var listDataSubUnit = await Api.getSubUnit(sbu, line, machine, unit);
    setState(() {
      _dataSubUnit = listDataSubUnit;
    });
  }


  void getIdActivity(String pmat_description) async {
    var listDataActivity = await Api.getActivity(pmat_description);
    setState(() {
      _valActivity = listDataActivity[0]['id'];
    });
  }

  void getActivity() async {
    var listDataActivity = await Api.getActivity();
    setState(() {
      _dataActivity = listDataActivity;
    });
  }

  void getAutoNumber() async {
    var autoNumber = await Api.getAutoNumber();
    // print(autoNumber);
    setState(() {
      _autoNumber = autoNumber;
    });
  }

  String pmat;

  void getPillar(String id) async {
    var listDataPillar = await Api.getPillar(id);
    print(listDataPillar);
    setState(() {
      _valPillar = listDataPillar[0]['pillar_pic'];
      pmat = listDataPillar[0]['pmat_description'];
    });
  }

  String numbLast;

  void getAllDate() async {
    var listAllDate = await Api.getAllDate();
    setState(() {
      _date = listAllDate['date'];
      _year = listAllDate['year'];
      _month = listAllDate['month'];
      _week = listAllDate['week'];
      _dinas = listAllDate['dinas'];
      _hours = listAllDate['hours'];
    });
  }
  TextEditingController description;

  void getEarlyQuestion(String ewoId) async{
    var dataEarlyQuestion = await Api.getEarlyQuestion(ewoId);
    setState(() {
      dataAnswer = dataEarlyQuestion;
    });
  }

  @override
  void initState() {
    description = TextEditingController();
    description.addListener(() {
      setState(() {});
    });

    // TODO: implement initState
    super.initState();

    if (widget.data != null){
      String numbLastEwo = widget.data['ewo_number'];
      numbLast = numbLastEwo.substring(numbLastEwo.length - 7);
      _valActivity;
      _valSbu = widget.data['sbu'].toString().toUpperCase();
      _valLine = widget.data['line'].toString();
      _valMachine = widget.data['machine'].toString();
      _valUnit = widget.data['equipment'].toString();
      _valSubUnit = widget.data['sub_unit'].toString();
      _valKerusakan = widget.data['type_problem'].toString();
      _valPerbaikan = widget.data['type_activity'].toString();
      description.text = widget.data['problem_description'];
      _valPmaDesc = widget.data['pm_activity_type'];
      _valPillar = widget.data['related_to'];
    }

    //function
    getSbu();
    getLine(_valSbu);
    getMachine(_valSbu, _valLine);
    getUnit(_valSbu, _valLine, _valMachine);
    getSubUnit(_valSbu, _valLine, _valMachine, _valUnit);
    getActivity();
    getIdActivity(widget.data['pm_activity_type']);
    getPillar(_valActivity);
    getEarlyQuestion(widget.data['id']);

    getAutoNumber();
    getAllDate();
    _setEmployeeId();
  }

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
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
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: _valSbu == null
                                      ? 'SKIN-'.toUpperCase()
                                      : _valLine == null
                                      ? 'SKIN-$_valSbu-03'.toUpperCase()
                                      : 'SKIN-$_valSbu-03-$_valLine-$numbLast'
                                      .toUpperCase(),
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  border: InputBorder.none,
                                  fillColor: Colors.black12,
                                  filled: true),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'SBU',
                                              style: TextStyle(
                                                  fontSize: 15, fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Text(_valSbu)
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'LINE',
                                              style: TextStyle(
                                                  fontSize: 15, fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Text(_valLine)
                                                )
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
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
                                    'MACHINE',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(_valMachine)
                                      )
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
                                    'Unit',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(_valUnit)
                                      )
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Sub Unit',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(_valSubUnit)
                                      )
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Problem Type',
                                              style: TextStyle(
                                                  fontSize: 15, fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Text(_valKerusakan)
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                          'Activity Type',
                                              style: TextStyle(
                                                  fontSize: 15, fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Text(_valPerbaikan)
                                                )
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Problem Description',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          readOnly: true,
                                          controller: description,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.greenAccent,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  Color.fromRGBO(18, 37, 63, 1.0),
                                                  width: 1.0),
                                            ),
                                            hintText: "Problem Description",
                                          ),
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'EWO Related to',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(_valPillar + ' - ' +_valPmaDesc)
                                      )
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Pillar Related to',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    child: TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          hintText: _valPillar == null
                                              ? ' - '
                                              : ' $_valPillar',
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
                        ],
                      ),
                    )
                  ],
                ),
                RaisedButton.icon(
                  onPressed: () {
                    showPopup(context, _popupBody(), 'Popup Demo');
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

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _storedImage = image;
    });

  }

  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    var employeeName = prefs.getString("employee_name");
    setState(() {
      _valEmployeeId = employeeId;
      _valEmployeeName = employeeName;
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

  saveAbnormalityForm1(context, DigiPMProvider digiPM) {
    final data = {
      'id' : widget.data['id'],
      'pm_type': 'PM03',
      'ewo_number': 'SKIN-$_valSbu-03-$_valLine-$numbLast',
      'sbu': _valSbu,
      'line': _valLine,
      'machine': _valMachine,
      'equipment': _valUnit,
      'sub_unit': _valSubUnit,
      'problem_description': description.text,
      'picture': _storedImage,
      'type_problem': _valKerusakan,
      'type_activity' : _valPerbaikan,
      'pm_activity_type': _valPmaDesc,
      'related_to': _valPillar,
      'date': _date,
      'year': _year,
      'month': _month,
      'week': _week,
      'shift': _dinas,
      'hours': _hours,
      'created_by': _valEmployeeId,
      'created_at': _date,
      'approve_by': null,
      'approve_at': null,
      'receive_by': null,
      'receive_at': null
    };

    // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAbnormalityForm2(form : data, answer : dataAnswer, picture : _storedImage)));

  }

  showPopup(BuildContext context, Widget widget, String title,
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
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.dark,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBody() {
    return Container(
      child: ViewAbnormalityForm2(form : data, answer : dataAnswer, picture : _storedImage),
    );
  }

}
