import 'dart:async';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/edit_abnormality_form1.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/fragments/abnormality/tab_approved.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';


import 'package:digi_pm_skin/fragments/abnormality/abnormality_home.dart';

import 'package:digi_pm_skin/fragments/abnormality/abnormality_form1.dart';
import 'package:digi_pm_skin/fragments/abnormality/timeline_abnormality.dart';

class TabSubmitted extends StatefulWidget {

  @override
  _TabSubmittedState createState() => _TabSubmittedState();
}

class _TabSubmittedState extends State<TabSubmitted> {

  List _dataEwo;
  String _valEmployeeId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEwo();
    getSbu();
    _setEmployee();
    dataewo;
  }

  List <Map<String, dynamic>> dataewo = [];

  void getEwo() async {
    var listDataLine = await Api.getEwoList();
    setState(() {
      _dataEwo = listDataLine;
      _dataEwo.forEach((element) {
        if (element['approve_by'] != null){
          return;
        } else {
          setState(() {
            print(element);
            dataewo.add(element);
          });
        }
      });
    });
  }

  List <dynamic> _dataSbu = List();
  List <dynamic> _dataLine = List();

  String _valSbu, _valLine;

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

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Filter By :', style: TextStyle(fontWeight: FontWeight.w700),),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text("-- "
                            "SBU --", style: TextStyle(fontSize: 12),),
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
                          });
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text("-- SELECT LINE --", style: TextStyle(fontSize: 12),),
                        value: _valLine,
                        items: _dataLine.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['line']),
                            value: item['line'],
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valLine = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: ListView.builder(
                    itemCount: dataewo?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
                        height: 180,
                        width: double.maxFinite,
                        child: Card(
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 2.0,
                                    color: Color.fromRGBO(18, 37, 63, 1.0),
                                  ),
                                )),
                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: RichText(
                                            text: TextSpan(
                                              text: dataewo[index]
                                              ['created_at'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 3.0),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Icon(
                                                          Icons.assignment,
                                                          color: Colors.amber,
                                                          size: 35,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: dataewo[index]
                                                        ['ewo_number'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          RichText(
                                                            textAlign:
                                                            TextAlign.left,
                                                            text: TextSpan(
                                                              text: dataewo[
                                                              index][
                                                              'problem_description'],
                                                              style: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    RaisedButton(
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(
                                                          builder: (context) => TimelineAbnormality(
                                                              ewoId: dataewo[index]['id'],
                                                              ewoNumber: dataewo[index]['ewo_number']
                                                          )
                                                        ));
                                                      },
                                                      textColor: Colors.white,
                                                      color: Colors.grey,
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: new Text(
                                                        "History",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    RaisedButton(
                                                      onPressed: () {
                                                        onApproved(
                                                            context,
                                                            "Confirmation",
                                                            "Whether you will do approval for\n" +
                                                                dataewo[index][
                                                                'ewo_number'],
                                                            dataewo[index],
                                                            _valEmployeeId);
                                                      },
                                                      textColor: Colors.white,
                                                      color: Colors.red,
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: new Text(
                                                        "Approved",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    RaisedButton(
                                                      padding:
                                                      EdgeInsets.all(8.0),
                                                      textColor: Colors.white,
                                                      color: Colors.lightBlue,
                                                      onPressed: () {

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditAbnormalityForm1(data : dataewo[index])),
                                                        );

                                                      },
                                                      child: Text('Edit/Delete'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AbnormalityForm1()),
            );
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }


  Future<String> _setEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    setState(() {
      _valEmployeeId = employeeId;
    });
  }

  Widget sIcon(data) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.assignment,
            color: Colors.amber,
            size: 35,
          )),
    );
  }


  static Future<void> onApproved(BuildContext context, String title,
      String content, dynamic ewoId, String employeeId) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        final data = {
          "id" : ewoId['id'],
          "approve_by" : employeeId
        };
        return AlertDialog(
          title: Text('$title'),
          content: Text(
            '$content',
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Ok ',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Api.saveAbnormalityApproved(data).then((val){
                  if (val['code_status'] == 1) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AbnormalityTab()));
                  }else {
                    Navigator.of(context).pop();
                  }
                });

              },
            ),
          ],
        );
      },
    );
  }

}
