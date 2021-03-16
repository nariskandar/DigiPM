import 'dart:async';
import 'dart:convert';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';


class ApprovedBreakdown extends StatefulWidget {

  @override
  _ApprovedBreakdownState createState() => _ApprovedBreakdownState();
}

class _ApprovedBreakdownState extends State<ApprovedBreakdown> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer2<DigiPMProvider, BreakdownProvider>(builder: (context, digiPM, breakdown, __) {
      return StatefulWrapper(
          onInit: () {},
          child: Scaffold(body: buildList(width, digiPM, breakdown, context),)
      );
    });
  }

  //  buildList
  Widget buildList(width, DigiPMProvider digiPM, BreakdownProvider breakdown, context) {
    if (breakdown.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (breakdown.dataApproved == [] || breakdown.dataApproved.length == 0) {
        return RefreshIndicator(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text("No Data",
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                  height: MediaQuery.of(context).size.height/1.5,
                )],
            ),
            onRefresh: () async {
              dataRefresher(breakdown);
            });
      } else {
        return generateEWOSubmittedList(context, width, breakdown);
      }
    }
  }

  Widget generateEWOSubmittedList(context, width, BreakdownProvider breakdown){
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: breakdown.dataApproved.length,
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
                                          text: breakdown.dataApproved[int]
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    text: breakdown.dataApproved[int]
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
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Text('Problem Desc: ', style: TextStyle(color: Colors.black54),),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    breakdown.dataApproved[
                                                    int][
                                                    'problem_description'].toString(),
                                                    style: TextStyle(color: Colors.grey),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: false,),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: <Widget>[
                                                buttonCardHistory(context, breakdown, Colors.blueGrey, 'History', int),
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
          dataRefresher(breakdown);
        },
      ),
    );
  }

  Widget sizeWidth5(){
    return SizedBox(width: 5,);
  }
  Widget buttonCardHistory (context, BreakdownProvider breakdown, Color colorCard, String text, int)  {
    return RaisedButton(
      onPressed: () {

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Timeline(
                ewoId: breakdown.dataApproved[int]['id'],
                pm_type: 'PM02',
            )
        ));
        
      },

      textColor: Colors.white,
      color: colorCard,
      padding:
      const EdgeInsets.all(
          8.0),
      child: new Text(
        "History",
      ),
    );
  }

  void dataRefresher(BreakdownProvider breakdown) async {
    breakdown.setLoadingState(true);
    await breakdown.getEWO(context, 'PM02');
    breakdown.setLoadingState(false);
  }



}
