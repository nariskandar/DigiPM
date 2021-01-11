import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'popup.dart';
import 'popup_content.dart';
import 'abnormality_form1.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HistoricalActivity extends StatefulWidget {
  @override
  _HistoricalActivityState createState() => _HistoricalActivityState();
}

class _HistoricalActivityState extends State<HistoricalActivity> {
  double _currentSlider = 20;

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('EWO Historical Activity'),
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
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      child: Text('Severity Level : 1'),
                                      onPressed: (){ print('Button Clicked.'); },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                      textColor: Colors.black,
                                      splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                                      color: Colors.orangeAccent,),
                                  ),
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      child: Text('No action needed'),
                                      onPressed: (){ print('Button Clicked.'); },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                      textColor: Colors.black,
                                      splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                                      color: Colors.greenAccent,),
                                  ),
                                ],
                              )),
                          SizedBox(height: 10,),
                          Container(
                            child: current('Curent Date', '2020/12/21', Icons.timer),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: current('Timeline (days)', '0 Days', Icons.today),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: current('Execution Date', '00/00/00', Icons.timer),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton.icon(
                      onPressed: (){ print('Button Clicked.'); },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
            showPopup(context, _popupBody(), 'Severity Level');
          },
          heroTag: "demoValue",
          tooltip: 'Severity Level',
          child: Icon(Icons.info),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  Widget current(String title, String label1, IconData icon1){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700),
        ),
        Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/12,
                child: RaisedButton.icon(
                  icon: Icon(icon1),
                  label: Text('$label1'),
                  onPressed: (){ print('Button Clicked.'); },
                  textColor: Colors.black,
                  splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                  color: Colors.white12,),
              ),
            ))
      ],
    );
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

  Widget _popupBody() {
    return Container(
      // child: AbnormalityFormView1(),
    );
  }

}
