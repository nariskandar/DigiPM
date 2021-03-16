import 'package:digi_pm_skin/fragments/abnormality/edit_abnormality_form1.dart';
import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_form.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/util/util.dart';

class Submitted extends StatefulWidget {
  @override
  _SubmittedState createState() => _SubmittedState();
}

class _SubmittedState extends State<Submitted> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return StatefulWrapper(
          onInit: () {},
          child: Scaffold(body: buildList(width, digiPM, abnormality, context),
            floatingActionButton: FloatingActionButton(
              onPressed: ()  {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AbnormalityForm1()));
                digiPM.FormHome = false;
              },
              child: Icon(Icons.add),
            ),)
      );
    });
  }

  //  buildList
  Widget buildList(width, DigiPMProvider digiPM, AbnormalityProvider abnormality, context) {
    if (abnormality.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (abnormality.dataSubmitted.length == 0) {
        return RefreshIndicator(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text("No Tasklist Data",
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                  height: MediaQuery.of(context).size.height,
                )],
            ),
            onRefresh: () async {
              dataRefresher(abnormality);
            });
      } else {
        return generateEWOSubmittedList(context, width, abnormality);
      }
    }
  }

  Widget generateEWOSubmittedList(context, width, AbnormalityProvider abnormality){
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
        child: Column(
          children: <Widget>[
            // Expanded(
            //   flex: 2,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Padding(
            //         padding: EdgeInsets.only(left: 15),
            //         child: Text('Filter By :', style: TextStyle(fontWeight: FontWeight.w700),),
            //       ),
            //       Container(
            //         width: MediaQuery.of(context).size.width/3,
            //         child: DropdownButton(
            //           isExpanded: true,
            //           hint: Text("-- "
            //               "SBU --", style: TextStyle(fontSize: 12),),
            //           value: abnormality.valueSbu,
            //           items: abnormality.masterSbu.map((item) {
            //             return DropdownMenuItem(
            //               child: Text(item['sbu']),
            //               value: item['sbu'],
            //             );
            //           }).toList(),
            //           onChanged: (value) {
            //             setState(() {
            //               // _valSbu = value;
            //               // _valLine = null;
            //             });
            //             // getLine(value);
            //           },
            //         ),
            //       ),
            //       Container(
            //         width: MediaQuery.of(context).size.width/3,
            //         child: DropdownButton(
            //           isExpanded: true,
            //           hint: Text("-- SELECT LINE --", style: TextStyle(fontSize: 12),),
            //           value: abnormality.valueLine,
            //           items: abnormality.masterLine.map((item) {
            //             return DropdownMenuItem(
            //               child: Text(item['line']),
            //               value: item['line'],
            //             );
            //           }).toList(),
            //           onChanged: (value) {
            //             setState(() {
            //               // _valLine = value;
            //             });
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: abnormality.dataSubmitted.length,
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
                                          text: abnormality.dataSubmitted[int]
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
                                                    text: abnormality.dataSubmitted[int]
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
                                                          text: abnormality.dataSubmitted[
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
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                buttonCardHistory(context, abnormality, Colors.orange, 'History', int),
                                                sizeWidth5(),
                                                buttonCardApproved(context, abnormality, Colors.red, 'Approved', int),
                                                sizeWidth5(),
                                                buttonCardEditDelete(context, abnormality, Colors.blue, 'Edit/Delete', int),
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
                ewoId: abnormality.dataSubmitted[int]['id'],
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
  Widget buttonCardApproved (context, AbnormalityProvider abnormality, Color colorCard, String text, int)  {
    return RaisedButton(
      onPressed: () {
        onApprovedPM03(context,  "Confirmation",
            "Whether you will do approval for\n" + abnormality.dataSubmitted[int]['ewo_number'], abnormality, abnormality.dataSubmitted[int]['id']);
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
  Widget buttonCardEditDelete (context, AbnormalityProvider abnormality, Color colorCard, String text, int)  {
    return RaisedButton(
      onPressed: () {

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => EditAbnormalityForm(
                ewoId: abnormality.dataSubmitted[int]['id']
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
    await abnormality.getEWO(context,'PM03');
    abnormality.setLoadingState(false);
  }

  saveApproved(BuildContext context, AbnormalityProvider abnormality, String ewoId) async {
    // Util.loader(context, "", "Saving...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = {
      'ewo_id' : ewoId,
      'approve_by' : prefs.getString('id_user')
    };
    print(data);


    try {
      abnormality.saveApproved(data).then((val) async {

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
        // print(val);
        // print(val['code_status']);

        // var res = jsonDecode(val);
        // print(res);
        // print(res['code_status']);

        if(val['code_status'] == 1) {
          await Util.alert(context, "Success", "You have saved Approved", "approvedPM03");
        }

      });
    } catch (e){
      Util.alert(context, "error", "Internal error occured. Please contact developer").then((value) async {
        Navigator.pop(context);
      });
    }
  }

  onApprovedPM03(BuildContext context, String title, String content, AbnormalityProvider abnormality, String ewoId) {
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
              onPressed: ()  {
                saveApproved(context, abnormality, ewoId);
              },
            ),
          ],
        );
      },
    );



  }


}
