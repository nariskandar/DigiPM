import 'dart:convert';
import 'dart:math';

import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/edit_abnormality_form1.dart';
import 'package:async/async.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form1.dart';
import 'package:digi_pm_skin/fragments/abnormality/timeline_abnormality.dart';

class TabApproved extends StatefulWidget {
  // String flag;

  // TabApproved({Key key, @required this.flag}) : super(key: key);

  @override
  _TabApprovedState createState() => _TabApprovedState();
}

class _TabApprovedState extends State<TabApproved> {

  List _dataEwo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEwo();
    dataewo;
  }

List <Map<String, dynamic>> dataewo = [];

  void getEwo() async {
    var listDataLine = await Api.getEwoList();
    setState(() {
      _dataEwo = listDataLine;
      _dataEwo.forEach((element) {
        if (element['approve_by'] == null){
          return;
        } else {
          setState(() {
            dataewo.add(element);
          });
        }
      });
    });
  }

  List <dynamic> _dataSbu = List();
  String _valSbu;
  void getSbu() async {
    var listDataSbu = await Api.getSbu();
    setState(() {
      _dataSbu = listDataSbu;
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
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TimelineAbnormality(
                                                                      ewoId: dataewo[index]['id'],
                                                                      ewoNumber: dataewo[index]['ewo_number']
                                                                  )));
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
                                                ],
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
      );
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
      String content, dynamic ewoId, dynamic ewoNumber) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
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

              },
            ),
          ],
        );
      },
    );
  }

}
