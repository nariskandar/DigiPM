import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'analysis_form2.dart';

class AnalysisForm extends StatefulWidget {
  Map <String, dynamic> data;

  AnalysisForm({Key key, @required this.data}) : super(key : key);

  @override
  _AnalysisFormState createState() => _AnalysisFormState(data);
}

class _AnalysisFormState extends State<AnalysisForm> {
  Map <String, dynamic> data;

  _AnalysisFormState(this.data);

  File _storedImage;
  TextEditingController description;

  @override
  void initState() {
    description = TextEditingController();
    description.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose(){
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Analysis Form'),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Deskripsi Analisis Awal',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: description,
                                          maxLines: 5,
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child:
                                        ButtonTheme(
                                          minWidth: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height/3,
                                          child: OutlineButton(
                                            onPressed: () async {
                                              await getImage();
                                            },
                                            child: _storedImage == null ? Column(
                                              children: [
                                                Icon(Icons.photo, size: 25,),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text('Upload Photo'),
                                              ],
                                            ) : Padding(
                                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                              child: Image.file(
                                                _storedImage,
                                                fit: BoxFit.scaleDown,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height/3,
                                              ),
                                            ),
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(18, 37, 63, 1.0),
                                              style: BorderStyle.solid,
                                              width: 1,
                                            ),
                                          ),
                                        )
                                      ))
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                RaisedButton.icon(
                  onPressed: (){
                    saveAnalysis(context, digiPM);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  label: Text('Next',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                  icon: Icon(Icons.arrow_forward, color:Colors.white,),
                  textColor: Colors.white,
                  splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                  color: Colors.green,),
              ],

            ),
          ),
        ),
      );

    }
    );

  }

  saveAnalysis(context, DigiPMProvider digiPM) {
    if (description.text == ""){
      Util.alert(context, 'Validation', 'Please fill description');
      return;
    }
    if(_storedImage == null) {
      Util.alert(context, 'Validation', 'Please upload photo');
      return;
    }

    final data = {
      'description' : description.text,
      'ewo_id' : widget.data['id']
    };



    Navigator.push(context, MaterialPageRoute(builder: (context) => AnalysisForm2(data: data, picture: _storedImage)));

  }




  getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _storedImage = image;
    });
  }

}