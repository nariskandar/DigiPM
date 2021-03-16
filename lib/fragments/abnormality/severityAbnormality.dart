import 'package:digi_pm_skin/fragments/abnormality/form_non_she.dart';
import 'package:digi_pm_skin/fragments/abnormality/form_she.dart';
import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';

class Severity extends StatefulWidget {

  @override
  _SeverityState createState() => _SeverityState();
}

class _SeverityState extends State<Severity> {

  @override

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return StatefulWrapper(
          onInit: () {
            dataRefresher(abnormality);
          },
          child: Scaffold(
            appBar: AppBar(title: Text('Severity PM03'),),
            body: buildList(width, digiPM, abnormality, context),)
      );
    });
  }

  //  buildList
  Widget buildList(width, DigiPMProvider digiPM, AbnormalityProvider abnormality, context) {
    if (abnormality.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (abnormality.dataSeverity.length == 0) {
        return RefreshIndicator(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text("No Tasklist Data",
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                  height: MediaQuery.of(context).size.height/1.5,
                )],
            ),
            onRefresh: () async {
              dataRefresher(abnormality);
            });
      } else {
        return generateEWOSeverityList(context, width, abnormality);
      }
    }
  }

  Widget generateEWOSeverityList(context, width, AbnormalityProvider abnormality){
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: abnormality.dataSeverity.length,
                itemBuilder: (context, int){
                  return Container(
                    margin: EdgeInsets.all(7),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(2),
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
                                          text: abnormality.dataSeverity[int]
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
                                                    text: abnormality.dataSeverity[int]
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
                                                          text: abnormality.dataSeverity[
                                                          int][
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
                                              MainAxisAlignment.end,
                                              children: <Widget>[
                                                buttonCardHistory(context, abnormality, Colors.orange, 'HISTORY', int),
                                                sizeWidth5(),
                                                buttonCardAddSeverity(context, abnormality, Colors.green, 'SET SEVERITY', int)
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
                },
              ),
            )
          ],
        ),
        onRefresh: () async {
          dataRefresher(abnormality);
        },
      ),
    );
  }

  Widget sizeWidth5(){
    return SizedBox(width: 5,);
  }

  Widget buttonCardHistory (context, AbnormalityProvider abnormality, Color colorCard, String text, int)  {
    return RaisedButton(
      onPressed: () {

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Timeline(
                ewoId: abnormality.dataSeverity[int]['id'],
                pm_type: 'PM03',
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
    );
  }

  Widget buttonCardAddSeverity (context, AbnormalityProvider abnormality, Color colorCard, String text, int)  {
    return RaisedButton(
      onPressed: () {

        abnormality.dataSeverity[int]['related_to'] == "SHE" ?
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => FormShe(
                data: abnormality.dataSeverity[int]
            )
        ))
            :
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => FormNonShe(
                data: abnormality.dataSeverity[int]
            )
        ));
      },

      textColor: Colors.white,
      color: colorCard,
      padding:
      const EdgeInsets.all(
          8.0),
      child: new Text(
        text.toString(),
      ),
    );
  }

  void dataRefresher(AbnormalityProvider abnormality) async {
    abnormality.setLoadingState(true);
    await abnormality.getEWO(context, 'PM03');
    abnormality.setLoadingState(false);
  }



}
