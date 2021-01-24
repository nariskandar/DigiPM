import 'dart:convert';
import 'dart:io';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_home.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/fragments/test.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:digi_pm_skin/models/sbu.dart';
import 'package:digi_pm_skin/api/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:digi_pm_skin/util/util.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class JustificationForm2 extends StatefulWidget {

  // JustificationForm2({Key key, @required this.form, this.picture}) : super(key: key);

  @override
  _JustificationForm2State createState() => _JustificationForm2State();
}

class _JustificationForm2State extends State<JustificationForm2> {


  // _JustificationForm2State(this. form, this.picture);  //constructor

  final valTindakan1 = TextEditingController();
  final valTindakan2 = TextEditingController();
  final valTindakan3 = TextEditingController();
  final valTindakan4 = TextEditingController();
  final valTindakan5 = TextEditingController();
  final valTindakan6 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valTindakan1.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    valTindakan1.dispose();
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
                                          controller: valTindakan1,
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
                        // Navigator.push(context, MaterialPageRoute (builder: (context) => Submissions()));
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
      );
    });
  }

  saveAbnormalityForm2(context, DigiPMProvider digiPM) {
    if (valTindakan1.text == "") {
      Util.alert(context, 'Validation', 'Please Fill Column of What');
      return;
    }

    Util.loader(context, 'Saving', 'Please wait ..');
  }
}