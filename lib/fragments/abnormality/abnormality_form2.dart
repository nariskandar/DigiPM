import 'dart:convert';
import 'dart:io';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_page.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_submission.dart';
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
import 'package:digi_pm_skin/fragments/abnormality/abnormality_status_progress.dart';

class AbnormalityForm2 extends StatefulWidget {
  final Map<String, dynamic> form;

  AbnormalityForm2({Key key, @required this.form}) : super(key: key);

  @override
  _AbnormalityForm2State createState() => _AbnormalityForm2State(form);
}

class _AbnormalityForm2State extends State<AbnormalityForm2> {

  Map<String, dynamic> form;
  _AbnormalityForm2State(this. form);  //constructor

  final valwhat = TextEditingController();
  final valwhen = TextEditingController();
  final valwhere = TextEditingController();
  final valwhy = TextEditingController();
  final valwho = TextEditingController();
  final valhow = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valwhat.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    valwhat.dispose();
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'What / Apa',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                    // color: Colors.black12.withOpacity(0.1),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: TextField(
                                          maxLines: 2,
                                          controller: valwhat,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                                              ),
                                              hintText: "Enter your text here"),
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Who / Siapa',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                    // color: Colors.black12.withOpacity(0.1),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: TextField(
                                          controller: valwho,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                                              ),
                                              hintText: "Enter your text here"),
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Where / Dimana',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                    // color: Colors.black12.withOpacity(0.1),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: TextField(
                                          controller: valwhere,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                                              ),
                                              hintText: "Enter your text here"),
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'When / Kapan',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                    // color: Colors.black12.withOpacity(0.1),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: TextField(
                                          controller: valwhen,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                                              ),
                                              hintText: "Enter your text here"),
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Why / Kenapa',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                    // color: Colors.black12.withOpacity(0.1),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: TextField(
                                          controller: valwhy,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                                              ),
                                              hintText: "Enter your text here"),
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'How / Bagaimana',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                    // color: Colors.black12.withOpacity(0.1),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: TextField(
                                          controller: valhow,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                                              ),
                                              hintText: "Enter your text here"),
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(height: 10,)
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
                        Navigator.push(context, MaterialPageRoute (builder: (context) => Submissions()));
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
                        saveAbnormalityForm2(context, digiPM);
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
      );
    });
  }

  saveAbnormalityForm2(context, DigiPMProvider digiPM) {

    if ( valwhat.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of What');
      return;
    }

    if ( valwho.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of Who');
      return;
    }

    if ( valwhere.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of Where');
      return;
    }

    if ( valwhen.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of When');
      return;
    }

    if ( valwhy.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of Why');
      return;
    }

    if ( valhow.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of How');
      return;
    }

    final data = {
      "pm_type": "PM03",
      "ewo_number": form['ewo_number'],
      "sbu": form['sbu'],
      "line": form['line'],
      "machine": form['machine'],
      "equipment": form['equipment'],
      "sub_unit": form['sub_unit'],
      "problem_description": form['problem_description'],
      "picture": null,
      "type_problem": form['type_problem'],
      "pm_activity_type": form['pm_activity_type'],
      "related_to": form['related_to'],
      "date": form['date'],
      "year": form['year'],
      "month": form['month'],
      "week": form['week'],
      "shift": form['shift'],
      "hours": form['hours'],
      "created_by": form['created_by'],
      "created_at": form['created_at'],
      "approve_by": form['who'],
      "approve_at": form['where'],
      "receive_by": form['receive_by'],
      "receive_at": form['receive_at'],
      "question": {
        "1": valwhat.text,
        "2": valwhen.text,
        "3": valwhere.text,
        "4": valwhy.text,
        "5": valwho.text,
        "6": valhow.text
      }
    };

    print(data);

    Api.saveAbnormalityForm1(data).then((value)async{
      if (value['code_status'] == 1) {
        await alertDialog(context, "Confirmation", "EWO Number : " + form['ewo_number']);
      }
    });
  }

  static Future<void> alertDialog(
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute (builder: (context) => Submissions()));
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Util.loader(context, "", "Saving...");
                Navigator.push(context, MaterialPageRoute (builder: (context) => Submissions()));
              },
            ),
          ],
        );
      },
    );
  }

}