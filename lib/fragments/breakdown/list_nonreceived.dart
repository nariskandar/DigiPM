import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digi_pm_skin/util/util.dart';


class NonReceived extends StatefulWidget {
  @override
  _NonReceivedState createState() => _NonReceivedState();
}

class _NonReceivedState extends State<NonReceived> {

  String selectDelegate;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer2<DigiPMProvider, BreakdownProvider>(builder: (context, digiPM, breakdown, __) {
      return StatefulWrapper(
          onInit: ()  {},
          child: Scaffold(
            body: buildList(width, digiPM, breakdown, context), )
      );
    });
  }

  //  buildList
  Widget buildList(width, DigiPMProvider digiPM, BreakdownProvider breakdown, context) {
    if (breakdown.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (breakdown.dataNonReceived.length == 0) {
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
        return generateTechnicianCallOff(context, width, digiPM, breakdown);
      }
    }
  }

  Widget generateTechnicianCallOff(context, width, DigiPMProvider digiPM, BreakdownProvider breakdown){
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: breakdown.dataNonReceived.length,
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
                                          text: breakdown.dataNonReceived[int]
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
                                                    text: breakdown.dataNonReceived[int]
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
                                                    breakdown.dataNonReceived[
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
                                                    breakdown.dataNonReceived[int]['ASSIGN_TO'],
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
                                                buttonCardDelegate(context, breakdown, Colors.blue, 'Delegate', int),
                                                sizeWidth5(),
                                                buttonCardReceived(context, breakdown, Colors.green, 'Received', int),
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

  Widget buttonCardReceived (context, BreakdownProvider breakdown, Color colorCard, String text, int index)  {
    return RaisedButton(
      onPressed: () => onReceivedPM02(context, 'Confitmation', 'Do you accept EWO number: \n${breakdown.dataNonReceived[index]['ewo_number']}', breakdown, index),
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

  Widget buttonCardHistory (context, BreakdownProvider breakdown, Color colorCard, String text, int)  {
    return RaisedButton(
      onPressed: () {

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Timeline(
                ewoId: breakdown.dataNonReceived[int]['id'],
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

  Widget buttonCardDelegate (context, BreakdownProvider breakdown, Color colorCard, String text, int index)  {
    return RaisedButton(
      onPressed: () {
        breakdown.getTechnicianByDepartment(breakdown.dataNonReceived[index]['sbu']);
        delegateTechnicalCallOff(breakdown, context, index);
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

  Widget delegateTechnicalCallOff(BreakdownProvider breakdown, BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirmation'),
        content: Container(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getAListOfTechnicians("local", breakdown)
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Cancel'),
          ),
          new FlatButton(
            onPressed: (){},
            child: new Text('Ok'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget getAListOfTechnicians(mapKey, BreakdownProvider breakdown) {
    return new SearchableDropdown(
      items: breakdown.technicianList.map((item) {
        return DropdownMenuItem(
          child: Text(item['employee_name']),
          value: item['id'],
        );
      }).toList(),
      value: selectDelegate,
      // selectedItems: int.parse(selectedItems),
      isCaseSensitiveSearch: false,
      hint: new Text(
          'Select Technician'
      ),
      onChanged: (value) {
        print(value);
        setState(() {
          selectDelegate = value;
          print(value);
        });
      },
      isExpanded: true,
    );
  }


  void dataRefresher(BreakdownProvider breakdown) async {
    breakdown.setLoadingState(true);
    await breakdown.getEWO(context, 'PM02');
    breakdown.setLoadingState(false);
  }

  onReceivedPM02(
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
                  saveReceived(context, breakdown, index);
                }
            ),
          ],
        );
      },
    );
  }

  Widget technicianAssignment(BreakdownProvider breakdown, int index, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Technician Assignment'),
        content: Container(
          height: 180,
          child: ListView(
            children: <Widget>[
              new Text('EWO Number : \n' + breakdown.dataNonReceived[index]['ewo_number'], style: TextStyle(fontSize: 13),),
              // cekReason(digiPM, i, context),
              SizedBox(height: 10,),
              getAListOfTechnicians("local", breakdown),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Cancel'),
          ),
          new FlatButton(
            onPressed: () {},
            child: new Text('Save'),
          ),
        ],
      ),
    ) ??
        false;
  }

  saveReceived(BuildContext context, BreakdownProvider breakdown, int index)async{
    Util.loader(context, "", "Saving...");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = {
      'ewo_id' : breakdown.dataNonReceived[index]['id'],
      'employee_id' : prefs.getString('id_user')
    };

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

        // var res = jsonDecode(val);

        if(val['code_status'] == 1) {
          await Util.alert(context, "Success", "You have saved Received", "receivedpm02");
          dataRefresher(breakdown);
        }

      });
    } catch (e){
      Util.alert(context, "error", "Internal error occured. Please contact developer").then((value) async {
        Navigator.pop(context);
      });
    }

  }



}
