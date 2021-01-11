import 'package:digi_pm_skin/fragments/abnormality/analysis_form.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/fragments/abnormality/submissionData.dart';
import 'package:search_page/search_page.dart';


class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  TextEditingController controller;
  var submissionData = SubmissionData.getData;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Analysis'),
          ),
          body: Column(children: <Widget>[
            RaisedButton(
              child: Text('Print'),
              onPressed: () {

              },
            ),
            new Container(
              color: Colors.white,
              child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: controller,
                      decoration: new InputDecoration(
                          hintText: 'Search',
                          focusColor: Theme
                              .of(context)
                              .primaryColor,
                          border: InputBorder.none),
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.calendar_today),
                      onPressed: () {
                        controller.clear();
                      },
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                color: Colors.white,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: submissionData?.length ?? 0,
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
                                                      text: submissionData[index]
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
                                                                text: submissionData[index]
                                                                ['ewo_number'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors.black,
                                                                    fontSize: 13),
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
                                                                      text: submissionData[
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
                                                          // FlatButton(
                                                          //   onPressed: () {
                                                          //     Navigator.push(
                                                          //         context,
                                                          //         MaterialPageRoute(
                                                          //             builder: (context) =>
                                                          //                 TimelineAbnormality(
                                                          //                     ewoId: _dataEwo[index]['id'],
                                                          //                     ewoNumber: _dataEwo[index]['ewo_number']
                                                          //                 )));
                                                          //   },
                                                          //   child: Column(
                                                          //     children: <Widget>[
                                                          //       Icon(
                                                          //         Icons.linear_scale,
                                                          //         color: Colors.brown,
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          // RaisedButton(
                                                          //   onPressed: () {
                                                          //     onApproved(
                                                          //         context,
                                                          //         "Confirmation",
                                                          //         "Whether you will do approval for\n" +
                                                          //             _dataEwo[0][
                                                          //             'ewo_number'],
                                                          //         _dataEwo[index],
                                                          //         _dataEwo[index]);
                                                          //   },
                                                          //   textColor: Colors.white,
                                                          //   color: Colors.red,
                                                          //   padding:
                                                          //   const EdgeInsets.all(
                                                          //       8.0),
                                                          //   child: new Text(
                                                          //     "Approved",
                                                          //   ),
                                                          // ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          // RaisedButton(
                                                          //   padding:
                                                          //   EdgeInsets.all(8.0),
                                                          //   textColor: Colors.white,
                                                          //   color: Colors.lightBlue,
                                                          //   onPressed: () {
                                                          //     Navigator.push(
                                                          //       context,
                                                          //       MaterialPageRoute(
                                                          //           builder: (context) =>
                                                          //               AbnormalityForm1()),
                                                          //     );
                                                          //   },
                                                          //   child: Text('Edit/Delete'),
                                                          // ),
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
              ),
            ),
          ]));
    });
  }

  Widget sIcon(data) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.adb,
            color: Colors.amber,
            size: 35,
          )),
    );
  }


}