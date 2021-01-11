import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/edit_abnormality_form1.dart';

import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/fragments/abnormality/submissionData.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_status_progress.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form1.dart';
import 'package:digi_pm_skin/fragments/abnormality/timeline_abnormality.dart';

class TabSubmitted extends StatefulWidget {
  @override
  _TabSubmittedState createState() => _TabSubmittedState();
}

class _TabSubmittedState extends State<TabSubmitted> {
  List _dataEwo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEwo();
  }

  void getEwo() async {
    var listDataLine = await Api.getEwoList();
    setState(() {
      _dataEwo = listDataLine;
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
              // FlatButton(
              //   child: Text('print'),
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => TimelineAbnormality()));
              //   },
              // ),
              Expanded(
                child: ListView.builder(
                    itemCount: _dataEwo?.length ?? 0,
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
                                              text: _dataEwo[index]
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
                                                        text: _dataEwo[index]
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
                                                              text: _dataEwo[
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
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TimelineAbnormality(
                                                                      ewoId: _dataEwo[index]['id'],
                                                                      ewoNumber: _dataEwo[index]['ewo_number']
                                                                  )));
                                                    },
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.linear_scale,
                                                          color: Colors.brown,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      onApproved(
                                                          context,
                                                          "Confirmation",
                                                          "Whether you will do approval for\n" +
                                                              _dataEwo[0][
                                                                  'ewo_number'],
                                                          _dataEwo[index],
                                                          _dataEwo[index]);
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
                                                                EditAbnormalityForm1(ewoId: _dataEwo[index]['id'],)),
                                                      );
                                                    },
                                                    child: Text('Edit/Delete'),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TimelineAbnormality(
                          ewoId: ewoId['id'],
                          ewoNumber: ewoNumber['ewo_number']),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
