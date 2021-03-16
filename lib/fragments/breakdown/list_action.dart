import 'package:digi_pm_skin/fragments/breakdown/form_exe_corrective.dart';
import 'package:digi_pm_skin/fragments/breakdown/edit_submission.dart';
import 'package:digi_pm_skin/fragments/breakdown/tab_exe_corrective.dart';
import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'form_submission.dart';

class BreakdownListAction extends StatefulWidget {
  String tittle;
  BreakdownListAction({Key key, @required this.tittle}) : super(key: key);

  @override
  _BreakdownListActionState createState() => _BreakdownListActionState();
}

class _BreakdownListActionState extends State<BreakdownListAction> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer2<DigiPMProvider, BreakdownProvider>(builder: (context, digiPM, breakdown, __) {
      return StatefulWrapper(
          onInit: () {},
          child: Scaffold(
            appBar: AppBar(title: Text(widget.tittle.toString()),),
            body: buildList(width, digiPM, breakdown, context),)
      );
    });
  }

  //  buildList
  Widget buildList(width, DigiPMProvider digiPM, BreakdownProvider breakdown, context) {
    if (breakdown.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (breakdown.dataBreakdownAction == [] || breakdown.dataBreakdownAction.length == 0) {
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
        return generateBreakdownActionList(context, width, breakdown);
      }
    }
  }

  Widget generateBreakdownActionList(context, width, BreakdownProvider breakdown){
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
        child: ListView.builder(
          itemCount: breakdown.dataBreakdownAction.length,
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
                                    text: breakdown.dataBreakdownAction[int]
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
                                              text: breakdown.dataBreakdownAction[int]
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
                                            child: Text('Problem Desc: ', style: TextStyle(color: Colors.black87),),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              breakdown.dataBreakdownAction[
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
                                            child: Text('Assign to :', style: TextStyle(color: Colors.black87),),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              breakdown.dataBreakdownAction[
                                              int][
                                              'ASSIGN_TO'].toString(),
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
                                            child: Text(breakdown.dataBreakdownAction[int]['IS_NEED_SPARE_PART_PM02'] == '1' ? 'Using Sparepart' : 'Without Sparepart', style: TextStyle(color: Colors.black87),),
                                          ),
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
                                          buttonCardAction(context, breakdown, Colors.green, 'Action', int),
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
        Navigator.push(context, MaterialPageRoute(builder: (context)
        => Timeline(
          ewoId: breakdown.dataBreakdownAction[int]['id'],
          pm_type: breakdown.pm_type,)
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
  Widget buttonCardAction (context, BreakdownProvider breakdown, Color colorCard, String text, int index)  {
    return RaisedButton(
      onPressed: () {
        onActionPM02(context,  "Confirmation",
            "Will you do the execution for \n" + breakdown.dataBreakdownAction[index]['ewo_number'] + " ?",  breakdown, index);
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

  void dataRefresher(BreakdownProvider breakdown) async {
    breakdown.setLoadingState(true);
    await breakdown.getEWO(context, 'PM02');
    breakdown.setLoadingState(false);
  }

  onActionPM02(
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ExecutionCorrective(data: breakdown.dataBreakdownAction[index],)
                ));

              },
            ),
          ],
        );
      },
    );
  }


  saveApproved(BuildContext context, BreakdownProvider breakdown, int index)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = {
      'ewo_id' : breakdown.dataSubmitted[index]['id'],
      'approved_by' : prefs.getString('id_user'),
      'id_technician' : breakdown.selectedTechnicianList
    };

    try {
      breakdown.saveApproved(data).then((val) async {
        print(val);

        // if(val == "timeout") {
        //   Util.alert(context, "Error", "Network error. please check your internet network").then((val)  {
        //     Navigator.of(context).pop(true);
        //     Navigator.of(context).pop(true);
        //   });
        // }
        //
        // if(val == "offline") {
        //   Util.alert(context, "Error", "Network error. please check your internet network").then((val) {
        //     Navigator.of(context).pop(true);
        //     Navigator.of(context).pop(true);
        //   });
        // }
        //
        // var res = jsonDecode(val);

        if(val['code_status'] == 1) {
          await Util.alert(context, "Success", "You have saved Approved", 'approvedPM02');
        }

      });
    } catch (e){
      Util.alert(context, "error", "Internal error occured. Please contact developer").then((value) async {
        Navigator.pop(context);
      });
    }
  }



}
