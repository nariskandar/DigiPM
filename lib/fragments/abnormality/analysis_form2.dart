import 'dart:convert';
import 'dart:io';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_home.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/fragments/abnormality/analysis.dart';
import 'package:digi_pm_skin/fragments/test.dart';
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

class AnalysisForm2 extends StatefulWidget {
  Map <String, dynamic> data;
  File picture;

  AnalysisForm2({Key key, @required this.data, this.picture}) : super(key : key);

  @override
  _AnalysisForm2State createState() => _AnalysisForm2State(data, picture);
}

class _AnalysisForm2State extends State<AnalysisForm2> {
  Map <String, dynamic> data;
  File picture;

  _AnalysisForm2State(this.data, this.picture);

  final no1 = TextEditingController();
  final no2 = TextEditingController();
  final no3 = TextEditingController();
  final no4 = TextEditingController();
  final no5 = TextEditingController();
  final no6 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     no1.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    no1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Possible cause of the problem', style: TextStyle(fontSize: 17),),
          ),
          body: Container(
            child: Card(
              shadowColor: Colors.grey,
              margin: EdgeInsets.all(7),
              color: Colors.white,
              elevation: 5,
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
                          child: Text('Checklist of possible causes of the problem', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),)),
                      Container(
                        padding: EdgeInsets.all(13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                textField('1', no1),
                                SizedBox(height: 10,),
                                textField('2', no2),
                                SizedBox(height: 10,),
                                textField('3', no3),
                                SizedBox(height: 10,),
                                textField('4', no4),
                                SizedBox(height: 10,),
                                textField('5', no5),
                                SizedBox(height: 10,),
                                textField('6', no6),
                              ],
                            ),
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
                          Navigator.push(context, MaterialPageRoute (builder: (context) => Analysis()));
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
                          saveAnalysis(context, digiPM);
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
        ),
      );
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

  saveAnalysis(context, DigiPMProvider digiPM) {

    if ( no1.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of What');
      return;
    }

    if ( no2.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of Who');
      return;
    }

    if ( no3.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of Where');
      return;
    }

    if ( no4.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of When');
      return;
    }

    if ( no5.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of Why');
      return;
    }

    if ( no6.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of How');
      return;
    }

    Util.loader(context, 'Saving', 'Please wait ..');

    final data = {
      'id' : null,
      'description' : widget.data['description'],
      'ewo_id' : widget.data['ewo_id'],
      'problem' : {
        'no1': no1.text,
        'no2' : no2.text,
        'no3' : no3.text,
        'no4' : no4.text,
        'no5' : no5.text,
        'no6' : no6.text
      }
    };


    Api.saveAnalysis(data, widget.picture).then((value) {
      var res = json.decode(value);

      if(res['code_status'] == 1) {
        alert(context, 'Save', 'Saving');
      }
    });
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
                Navigator.push(context, MaterialPageRoute (builder: (context) => Analysis()));
              },
            ),
          ],
        );
      },
    );
  }
}