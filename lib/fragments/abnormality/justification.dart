import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/analysis_form1.dart';
import 'package:digi_pm_skin/fragments/abnormality/edit_abnormality_form1.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/fragments/abnormality/form_non_she.dart';
import 'package:digi_pm_skin/fragments/abnormality/form_she.dart';
import 'package:digi_pm_skin/fragments/abnormality/justification_form1.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'dart:async';

import 'package:digi_pm_skin/fragments/abnormality/abnormality_home.dart';

import 'package:digi_pm_skin/fragments/abnormality/abnormality_form1.dart';
import 'package:digi_pm_skin/fragments/abnormality/timeline_abnormality.dart';

class Justification extends StatefulWidget {
  @override
  _JustificationState createState() => _JustificationState();
}

class _JustificationState extends State<Justification> {

  List _dataEwo;

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEwo();
    dataewo;
  }

  List<Map<String, dynamic>> dataewo = [];

  void getEwo() async {
    var listDataLine = await Api.getEwoList();
    setState(() {
      _dataEwo = listDataLine;
      _dataEwo.forEach((element) {

        if (element['severity_id'] == null) {
          return;
        } else {
          setState(() {
            dataewo.add(element);
          });
        }

      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Analysis'),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Card(
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: search,
                          decoration: new InputDecoration(
                              hintText: 'Search',
                              focusColor: Theme.of(context).primaryColor,
                              border: InputBorder.none),
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.calendar_today),
                          onPressed: () {
                            search.clear();
                          },
                        ),
                      ),
                    ),
                  ),
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
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => JustificationForm1(data: dataewo[index])));
                                                    },
                                                    color: Colors.orange,
                                                    child: Text('Justification', style: TextStyle(color: Colors.white),),
                                                  )
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
      String content, dynamic ewoId, String employeeId) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        final data = {"id": ewoId['id'], "approve_by": employeeId};
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
                Api.saveAbnormalityApproved(data).then((val) {
                  if (val['code_status'] == 1) {
                    Navigator.of(context).pop();
                  } else {
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