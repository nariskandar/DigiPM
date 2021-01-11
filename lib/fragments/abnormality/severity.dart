import 'package:digi_pm_skin/fragments/abnormality/historical_activity.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/fragments/abnormality/submissionData.dart';

class Severity extends StatefulWidget {
  @override
  _SeverityState createState() => _SeverityState();
}

class _SeverityState extends State<Severity> {
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
            title: Text('Severity Ratings'),
          ),
          body: Column(children: <Widget>[
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
                          // scrollDirection: Axis.horizontal,
                            itemCount: submissionData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
                                height: 200,
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
                                                  child: sDate(),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, top: 5),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          sIcon(
                                                              submissionData[index]),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          sName(),
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
                                                          sDescription()
                                                        ],
                                                      ),
                                                      sConfirm()
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

  Widget sName() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: 'SKIN-Tube 03 - LINE01 - 7792',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
        ),
      ),
    );
  }

  Widget sDate() {
    return RichText(
      text: TextSpan(
        text: '2020/12/25',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 10),
      ),
    );
  }

  Widget sDescription() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text:
                'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Duis congue sapien eu\negestas accumsan.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sConfirm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => HistoricalActivity() )
            );
          },
          textColor: Colors.white,
          color: Colors.orange,
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "Set Severity",
          ),
        ),
      ],
    );
  }
}