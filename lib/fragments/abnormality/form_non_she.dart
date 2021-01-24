import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/fragments/abnormality/view_abnormality_form1.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'popup.dart';
import 'popup_content.dart';
import 'abnormality_form1.dart';
import 'package:intl/intl.dart';
import 'package:digi_pm_skin/fragments/abnormality/tab_submitted.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FormNonShe extends StatefulWidget {
  Map<String, dynamic> data;

  FormNonShe({Key key, @required this.data}) : super(key: key);

  @override
  _FormNonSheState createState() => _FormNonSheState(data);
}

class _FormNonSheState extends State<FormNonShe> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  Map<String, dynamic> data;
  Map<String, dynamic> dataSeverity;

  _FormNonSheState(this.data);

  double _effectSeverity = 0;
  double _occuranceProbability = 0;

  String pillar;

  void cekPillar(){
    if(data['pillar_to'] == "SHE"){
      setState(() {
        var she = pillar;
      });
    }else{
      setState(() {
        var she = pillar;
      });
    }
  }

  void getDataSeverity(dynamic scale_one, dynamic scale_two, String type) async {
    var data = await Api.getDataSeverity(scale_one, scale_two, type);
    setState(() {
      listSeverity = data;
      listSeverity.forEach((element) {
        dataSeverity = element;
        getExecuteDate(dataSeverity['days']);
      });
    });
  }

  String currentDate;
  String executionDate;

  void getExecuteDate (dynamic days) {
    final now = new DateTime.now();

    var day = int.parse(days);
    var execute = new DateTime(now.year, now.month, now.day + day);
    setState(() {
      executionDate = DateFormat('yyyy-MM-dd').format(execute);
    });
  }



  List listSeverity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dataSeverity;
      // dd-MM-yyyy
      final now = new DateTime.now();
      currentDate = DateFormat('yyyy-MM-dd').format(now);
      _setEmployeeId();
    });

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Form Severity - ' + widget.data['related_to']),
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
                                     'Effect Severity',
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                    // color: Colors.black12.withOpacity(0.1),
                                      child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Slider(
                                            value: _effectSeverity,
                                            min: 0,
                                            max: 10,
                                            divisions: 10,
                                            label: _effectSeverity.round().toString(),
                                            onChanged: (double value) {
                                              setState(() {
                                                _effectSeverity = value;
                                              });
                                              getDataSeverity(_occuranceProbability, _effectSeverity, 'NON SHE');
                                            },
                                          )
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Occurance Probability',
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                      child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Slider(
                                            value: _occuranceProbability,
                                            min: 0,
                                            max: 10,
                                            divisions: 10,
                                            label: _occuranceProbability.round().toString(),
                                            onChanged: (double value) {
                                              setState(() {
                                                _occuranceProbability = value;
                                              });
                                              getDataSeverity(_occuranceProbability, _effectSeverity, 'NON SHE');
                                            },
                                          )
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,),
                          card(Colors.orangeAccent, dataSeverity ==  null ? " Severity Level : " : "Severity Level : " + dataSeverity['code'] ),
                          SizedBox(height: 10,),
                          card(dataSeverity == null ? Colors.green : dataSeverity['code_description'] == "No action needed" ? Colors.green : Colors.red, dataSeverity == null ? "-" : dataSeverity['code_description']),
                          SizedBox(height: 30,),
                          tittle('Current Date'),
                          card(Colors.grey, '$currentDate', Icon(Icons.timer)),
                          SizedBox(height: 10,),
                          tittle('Timeline (week)'),
                          card(Colors.grey, dataSeverity == null ? "-" : dataSeverity['number_of_weeks'] + ' Weeks'),
                          SizedBox(height: 10,),
                          tittle('Execution Date'),
                          card(Colors.grey, executionDate == null ? "-" : executionDate, Icon(Icons.timer)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton.icon( 
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute (builder: (context) => AbnormalityTab()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      label: Text('Cancel',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                      icon: Icon(Icons.cancel, color:Colors.white,),  
                      textColor: Colors.white,
                      splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                      color: Colors.red,),
                    RaisedButton.icon(
                      onPressed: (){
                        saveSeverity(context, digiPM);
                        // saveAbnormalityForm2(context, digiPM);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      label: Text('Save',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                      icon: Icon(Icons.save, color:Colors.white,),
                      textColor: Colors.white,
                      splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                      color: Colors.green,),
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showPopup(context, _popupBody(), 'Review');
          },
          heroTag: "demoValue",
          tooltip: 'Severity Level',
          child: Icon(Icons.info),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  Widget tittle (String text){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text('$text', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
    );
  }

  Widget card (Color color1, String text1, [Icon icon1]) {
    return  Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon1 == null ?  Text('') : Icon(Icons.timer, color: Colors.white,),
              SizedBox(width: 10,),
              Text('$text1 ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),)
            ],
          )
        ],
      ),
    );
  }

  String valEmployeeId;

  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    setState(() {
      valEmployeeId = employeeId;
    });
  }


  saveSeverity(context, DigiPMProvider digiPM) {
    final data = {
      "id" : null,
      "ewo_id" : widget.data['id'],
      "severity_id": dataSeverity['id'],
      "current_date": currentDate,
      "execution_date": executionDate,
      "created_by": valEmployeeId,
    };

    Api.saveSeverity(data).then((value)  {
      setState(() {
        if(value['code_status'] == 1)  {
          alert(context, "Success", "You have submit severity form");
        }
      });
    });

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
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  static Future<void> alert(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute (builder: (context) => AbnormalityTab()));
              },
            ),
          ],
        );
      },
    );
  }


  Widget _popupBody() {
    return Container(
      child: ViewAbnormalityForm1(data : widget.data),
    );
  }

}
