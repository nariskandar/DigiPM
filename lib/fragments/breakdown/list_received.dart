import 'dart:convert';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/breakdown/form_analysis.dart';
import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digi_pm_skin/util/util.dart';

class Received extends StatefulWidget {
  @override
  _ReceivedState createState() => _ReceivedState();
}

class _ReceivedState extends State<Received> {

  String selectDelegate;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer2<DigiPMProvider, BreakdownProvider>(builder: (context, digiPM, breakdown, __) {
      return StatefulWrapper(
          onInit: ()  {
          },
          child: Scaffold(
            body: buildList(width, digiPM, breakdown, context),)
      );
    });
  }

  //  buildList
  Widget buildList(width, DigiPMProvider digiPM, BreakdownProvider breakdown, context) {
    if (breakdown.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (breakdown.dataReceived.length == 0) {
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
        return generateTechnicianCallOff(context, width, breakdown);
      }
    }
  }

  void sparepart()async {

  }

  Widget generateTechnicianCallOff(context, width, BreakdownProvider breakdown){
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
        child: Column(
          children: <Widget>[
          // RaisedButton(child: Text('D'), onPressed: () async {
          //     // var cek = await Api.getTimeline('520', 'PM02');
          //     // print(cek);
          //
          //   print(cek);
          //
          //   },),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: breakdown.dataReceived.length,
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
                                          text: breakdown.dataReceived[int]
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
                                                    text: breakdown.dataReceived[int]
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
                                                    breakdown.dataReceived[
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
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Text('Assign to: ', style: TextStyle(color: Colors.black54),),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    breakdown.dataReceived[int]['ASSIGN_TO'],
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
                                                sizeWidth5(),
                                                buttonCardRConfirmation(context, breakdown, Colors.green, 'Confirm', int),
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
                ewoId: breakdown.dataReceived[int]['id'],
                pm_type: 'PM02',
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

  Widget buttonCardRConfirmation(context, BreakdownProvider breakdown, Color colorCard, String text, int index)  {
    return RaisedButton(
      onPressed: () async {
        await breakdown.getEWODetail('PM02', breakdown.dataReceived[index]['id']);
        isAnalyst(context, breakdown, index);
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

  onConfirmationPM02(
      BuildContext context, String title, String content, BreakdownProvider breakdown, int index) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content', style: TextStyle(fontSize: 14),),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Ok'),
                onPressed: () async {
                  await saveConfirmation(context, breakdown, index);
                }
            ),
          ],
        );
      },
    );
  }

  void isAnalyst(BuildContext context, BreakdownProvider breakdown, int index) {
    if(breakdown.EWODetail['IS_ANALYST_PM02'] == '1'){
      Util.alert(context, 'Attention', 'Analysis is in progress');
    } else {
      onConfirmationPM02(context, 'Confirmation', 'Please make sure you are near the engine area', breakdown, index);
    }
  }

  void saveConfirmation(BuildContext context, BreakdownProvider breakdown, int index) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = {
      'id_step14' : breakdown.dataReceived[index]['ID_STEP14'],
      'ewo_id' : breakdown.dataReceived[index]['id'],
      'employee_id' : prefs.getString('id_user')
    };

    print(data);


    try{
      breakdown.isAnalyst(breakdown.EWODetail['id'], '1').then((val)async{

        if(val['code_status'] == 1){

          breakdown.saveConfirmation(data).then((value) async {
            print(value);

            if(value['code_status'] == 1){
              Navigator.push(context, MaterialPageRoute(builder: (context)
              => AnalysisFormBreakdown(ewoId: breakdown.EWODetail['id'],)
              ));
            }

          });
        }

      });
    }catch (e){
      print(e.toString());
    }

  }


  void dataRefresher(BreakdownProvider breakdown) async {
    breakdown.setLoadingState(true);
    await breakdown.getEWO(context, 'PM02');
    breakdown.setLoadingState(false);
  }

  saveReceived(BuildContext context, BreakdownProvider breakdown, int index)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = {
      'ewo_id' : breakdown.dataReceived[index]['id'],
      'employee_id' : prefs.getString('id_user')
    };

    print(data);

    try {
      breakdown.saveReceived(data).then((val) async {
        if(val == "timeout") {
          Util.alert(context, "Error", "Network error. please check your internet network").then((val)  {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        if(val == "offline") {
          Util.alert(context, "Error", "Network error. please check your internet network").then((val) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        var res = jsonDecode(val);

        if(res['code_statis'] == 1) {
          await Util.alert(context, "Success", "You have saved Approved");
        }

      });
    } catch (e){
      Util.alert(context, "error", "Internal error occured. Please contact developer").then((value) async {
        Navigator.pop(context);
      });
    }
  }



}
