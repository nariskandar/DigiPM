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

class AbnormalityForm1 extends StatefulWidget {
  @override
  _AbnormalityForm1State createState() => _AbnormalityForm1State();
}

class _AbnormalityForm1State extends State<AbnormalityForm1> {

  String _valSbu,
      _valLine,
      _valMachine,
      _valUnit,
      _valSubUnit,
      _valPerbaikan,
      _valKerusakan,
      _valActivity,
      _valPillar,
      _autoNumber,
      _valEmployeeId,
      _valEmployeeName,
      _valPmaDesc,
      _valAllDate;
  List<dynamic> _dataSbu = List(),
      _dataLine = List(),
      _dataMachine = List(),
      _dataUnit = List(),
      _dataSubUnit = List(),
      _dataActivity = List(),
      _dataPillar = List(),
      _dataAllDate = List();

  File _storedImage;

  var user_login;

  void getSbu() async {
    var listDataSbu = await Api.getSbu();
    setState(() {
      _dataSbu = listDataSbu;
    });
  }

  void getLine(String sbu) async {
    var listDataLine = await Api.getLine(sbu);
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

  void getActivity() async {
    var listDataActivity = await Api.getActivity();
    setState(() {
      _dataActivity = listDataActivity;
    });
  }

  void getAutoNumber() async {
    var autoNumber = await Api.getAutoNumber();
    setState(() {
      _autoNumber = autoNumber;
    });
  }

  void getPillar(String id) async {
    var listDataPillar = await Api.getPillar(id);
    setState(() {
      _valPillar = listDataPillar[0]['pillar_pic'];
      _valPmaDesc = listDataPillar[0]['pmat_description'];
    });
  }




  // final description = TextEditingController();
  TextEditingController description;

  @override
  void initState() {
    description = TextEditingController();
    description.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
    getSbu();
    getActivity();
    getAutoNumber();
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
        appBar: AppBar(
          title: Text('EWO Abnormality Form'),
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
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: _valSbu == null
                                      ? 'SKIN-'.toUpperCase()
                                      : _valLine == null
                                          ? 'SKIN-$_valSbu-03'.toUpperCase()
                                          : 'SKIN-$_valSbu-03-$_valLine-$_autoNumber'
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'SBU',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text("-- SELECT --"),
                                  value: _valSbu,
                                  items: _dataSbu.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item['sbu']),
                                      value: item['sbu'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _valSbu = value;
                                      _valLine = null;
                                      _valMachine = null;
                                      _valUnit = null;
                                      _valSubUnit = null;
                                    });
                                    getLine(value);
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
                                'LINE',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text("-- SELECT --"),
                                  value: _valLine,
                                  items: _dataLine.map((item) {
                                    return DropdownMenuItem(
                                      child: Text("${item['line']}"),
                                      value: item['line'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _valLine = value;
                                      _valMachine = null;
                                      _valUnit = null;
                                      _valSubUnit = null;
                                    });
                                    getMachine(_valSbu, value);
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
                                'MACHINE',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text("-- SELECT --"),
                                  value: _valMachine,
                                  items: _dataMachine.map((item) {
                                    return DropdownMenuItem(
                                      child: Text("${item['machine']}"),
                                      value: item['machine'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _valMachine = value;
                                      _valUnit = null;
                                      _valSubUnit = null;
                                    });
                                    getUnit(_valSbu, _valLine, value);
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
                                'Unit',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text("-- SELECT --"),
                                  value: _valUnit,
                                  items: _dataUnit.map((item) {
                                    return DropdownMenuItem(
                                      child: Text("${item['unit']}"),
                                      value: item['unit'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _valUnit = value;
                                      _valSubUnit = null;
                                    });
                                    getSubUnit(_valSbu, _valLine, _valMachine, value);
                                  },
                                ),
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
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text("-- SELECT --"),
                                  value: _valSubUnit,
                                  items: _dataSubUnit.map((item) {
                                    return DropdownMenuItem(
                                      child: Text("${item['sub_equipment']}"),
                                      value: item['sub_equipment'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _valSubUnit = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Problem Type',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: RadioButtonGroup(
                                          orientation: GroupedButtonsOrientation
                                              .VERTICAL,
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          onSelected: (String selected) =>
                                              setState(() {
                                            _valKerusakan = selected;
                                          }),
                                          labels: <String>[
                                            "ELECTRIC",
                                            "MECHANIC",
                                          ],
                                          picked: _valKerusakan,
                                          itemBuilder:
                                              (Radio rb, Text txt, int i) {
                                            return Row(
                                              children: <Widget>[
                                                rb,
                                                txt,
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Activity Type',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: RadioButtonGroup(
                                          orientation: GroupedButtonsOrientation
                                              .VERTICAL,
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          onSelected: (String selected) =>
                                              setState(() {
                                            _valPerbaikan = selected;
                                          }),
                                          labels: <String>[
                                            "STOP",
                                            "RUNNING",
                                          ],
                                          picked: _valPerbaikan,
                                          itemBuilder:
                                              (Radio rb, Text txt, int i) {
                                            return Row(
                                              children: <Widget>[
                                                rb,
                                                txt,
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 3,
                                child: OutlineButton(
                                  onPressed: () async {
                                    await getImage();
                                  },
                                  child: _storedImage == null
                                      ? Column(
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('Upload Photo'),
                                          ],
                                        )
                                      : Image.file(
                                          _storedImage,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                        ),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(18, 37, 63, 1.0),
                                    style: BorderStyle.solid,
                                    // width: 1.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text("-- SELECT --"),
                                  value: _valActivity,
                                  items: _dataActivity.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item['activity_type'] +
                                          ' - ' +
                                          item['pmat_description']),
                                      value: item['id'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _valActivity = value;
                                    });
                                    getPillar(value);
                                  },
                                ),
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
                                          : '$_valPillar',
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
                    ),
                  ],
                ),
                RaisedButton.icon(
                  onPressed: () {
                    // tes(context, digiPM);
                    saveAbnormalityForm1(context, digiPM);
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



  getImage() async{
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

    if ( _valSbu == null) {
      Util.alert(context, 'Validation', 'Please Select SBU');
      return;
    }

    if ( _valLine == null) {
      Util.alert(context, 'Validation', 'Please Select Line');
      return;
    }

    if ( _valMachine == null) {
      Util.alert(context, 'Validation', 'Please Select Machine');
      return;
    }

    if ( _valUnit == null) {
      Util.alert(context, 'Validation', 'Please Select Unit');
      return;
    }

    if ( _valSubUnit == null) {
      Util.alert(context, 'Validation', 'Please Select SubUnit');
      return;
    }

    if ( _valKerusakan == null) {
      Util.alert(context, 'Validation', 'Please Select Problem Type');
      return;
    }

    if ( _valPerbaikan == null) {
      Util.alert(context, 'Validation', 'Please Select Activity Type');
      return;
    }

    if( _storedImage == null ){
      Util.alert(context, 'Validation', 'Please Upload Photo');
      return;
    }

    if ( description.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Problem Description');
      return;
    }

    if ( _valPmaDesc == null) {
      Util.alert(context, 'Validation', 'Please Select EWO Related to');
      return;
    }

    final data = {
      'pm_type': 'PM03',
      'ewo_number': 'SKIN-$_valSbu-03-$_valLine-$_autoNumber',
      'sbu': _valSbu,
      'line': _valLine,
      'machine': _valMachine,
      'equipment': _valUnit,
      'sub_unit': _valSubUnit,
      'problem_description': description.text,
      'type_problem': _valKerusakan,
      'type_activity' : _valPerbaikan,
      'pm_activity_type': _valPmaDesc,
      'related_to': _valPillar,
      'created_by': _valEmployeeId,
      'approve_by': null,
      'approve_at': null,
      'receive_by': null,
      'receive_at': null
    };
      Navigator.push(context, MaterialPageRoute(builder: (context) => AbnormalityForm2(form : data, picture: _storedImage)));
  }



}
