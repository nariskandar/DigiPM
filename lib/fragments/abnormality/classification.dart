import 'package:digi_pm_skin/fragments/abnormality/abnormality_form2.dart';
import 'package:digi_pm_skin/fragments/abnormality/tindakan_lanjutan.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Classification extends StatefulWidget {
  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
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

  double _currentSlider = 20;

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
          title: Text('Classification'),
        ),
        body: Container(
          child: Card(
            margin: EdgeInsets.all(7),
            color: Colors.white,
            elevation: 5,
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(13),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Rootcause('Rootcause Level 1', '-'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Rootcause('Rootcause Level 2', '-'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Suggestion',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Card(
                                        child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.greenAccent,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      18, 37, 63, 1.0),
                                                  width: 1.0),
                                            ),
                                            hintText: "Enter your text here"),
                                      ),
                                    ))
                                  ],
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
                                        'Jumlah meaning pillar team dibutuhkan',
                                        style: TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                      Card(
                                        // color: Colors.black12.withOpacity(0.1),
                                          child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Slider(
                                                value: _currentSlider,
                                                min: 0,
                                                max: 100,
                                                divisions: 5,
                                                label: _currentSlider.round().toString(),
                                                onChanged: (double value) {
                                                  setState(() {
                                                    _currentSlider = value;
                                                  });
                                                },
                                              )
                                          ))
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Std Durasi (menit)',
                                              style: TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.w700),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    hintText: "Enter your text here"),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: FlatButton(
                                        child: Text('2020/12/21'),
                                        onPressed: (){},
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ]))
                  ],
                ),
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TindakanLanjutan()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  label: Text(
                    'Tindakan Lanjutan',
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

  Widget Rootcause(String title, String teks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        DropdownButton(
          hint: Text('$teks'),
          value: _valFriends,
          items: _myFriends.map((value) {
            return DropdownMenuItem(
              child: Text(
                value,
                style: TextStyle(fontSize: 18),
              ),
              value: value,
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _valFriends = value;
            });
          },
        ),
      ],
    );
  }
}
