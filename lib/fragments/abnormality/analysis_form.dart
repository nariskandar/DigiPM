import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AnalysisForm extends StatefulWidget {
  @override
  _AnalysisFormState createState() => _AnalysisFormState();
}

class _AnalysisFormState extends State<AnalysisForm> {
  String _valGender; //Ini untuk menyimpan value data gender
  String _valFriends; //Ini untuk menyimpan value data friend
  List _listGender = ["Male", "Female"]; //Array gender
  List _myFriends = [
    "Clara",
    "John",
    "Rizal",
    "Steve",
    "Laurel",
    "Bernard",
    "Miechel"
  ]; //Array My Friend

  bool _isChecked = true;
  List<String> _checked = ["A", "B"];

  List<String> _months = [
    "AM - Automous Maintenance",
    "BLD - Building",
    "CAL - Calibration"
  ].toList();
  // String _selectedMonth = null;
  String _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = _months.first;
  }

  List _selecteCategorys = List();
  String _picked = "Two";

  void onMonthChange(String item) {
    setState(() {
      _selectedMonth = item;
    });
  }

  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);
      });
    } else {
      setState(() {
        _selecteCategorys.remove(category_id);
      });
    }
  }

  Map<String, dynamic> _categories = {
    "responseCode": "1",
    "responseText": "List categories.",
    "responseBody": [
      {"category_id": "5", "category_name": "Barber"},
      {"category_id": "3", "category_name": "Carpanter"},
      {"category_id": "7", "category_name": "Cook"}
    ],
    "responseTotalResult":
    3 // Total result is 3 here becasue we have 3 categories in responseBody.
  };

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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            height: 20,
                          ),
                          Container(
                              child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/8,
                                child: OutlineButton(
                                  child: Column(
                                    children: [
                                      Icon(Icons.photo, size: 25,),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Upload Photo'),
                                    ],
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(18, 37, 63, 1.0),
                                    style: BorderStyle.solid,
                                    width: 1.8,
                                  ),
                                  onPressed: () {},
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                RaisedButton.icon(
                  onPressed: (){
                    // Navigator.push(
                    //   context,
                      // MaterialPageRoute(builder: (context) => AbnormalityForm2()),
                    // );
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
    });
  }
}
