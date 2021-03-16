import 'package:digi_pm_skin/fragments/breakdown/summary_ewo_sparepart.dart';
import 'package:digi_pm_skin/fragments/timeline.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';


class PickingListSparepart extends StatefulWidget {
  String tittle;
  PickingListSparepart({Key key, @required this.tittle}) : super(key: key);

  @override
  _PickingListSparepartState createState() => _PickingListSparepartState();
}

class _PickingListSparepartState extends State<PickingListSparepart> {

  String selectDelegate;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer2<DigiPMProvider, BreakdownProvider>(builder: (context, digiPM, breakdown, __) {
      return StatefulWrapper(
          onInit: () {},
          child: Scaffold(
            appBar: AppBar(title: Text(widget.tittle.toString()) ,),
            body: buildList(width, digiPM, breakdown, context), )
      );
    });
  }

  //  buildList
  Widget buildList(width, DigiPMProvider digiPM, BreakdownProvider breakdown, context) {
    if (breakdown.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      print(breakdown.dataPickingSparepart);
      if (breakdown.dataPickingSparepart.length == 0) {
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
        return generatePickingListSparepart(context, width, breakdown);
      }
    }
  }

  Widget generatePickingListSparepart(context, width, BreakdownProvider breakdown){
    return Container(
      color: Colors.blueGrey,
      child: RefreshIndicator(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: breakdown.dataPickingSparepart.length,
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
                                          text: breakdown.dataPickingSparepart[int]
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
                                                    text: breakdown.dataPickingSparepart[int]
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
                                                    breakdown.dataPickingSparepart[
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
                                                    breakdown.dataPickingSparepart[
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
                                            padding: EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: <Widget>[
                                                buttonCardHistory(context, breakdown, Colors.blueGrey, 'History', int),
                                                sizeWidth5(),
                                                buttonCardPickup(context, breakdown, Colors.green, 'Pickup', int),
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

  Widget buttonCardPickup (context, BreakdownProvider breakdown, Color colorCard, String text, int index)  {
    return RaisedButton(
      onPressed: () async {
        Util.loader(context, '', 'Please wait ..');
        await breakdown.getEWODetail('PM02', breakdown.dataPickingSparepart[index]['id']);
        onPickupPM02(context, 'Confitmation', 'Do you will take spare part with EWO number: \n${breakdown.dataPickingSparepart[index]['ewo_number']} ?', breakdown);
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

  Widget buttonCardHistory (context, BreakdownProvider breakdown, Color colorCard, String text, int)  {
    return RaisedButton(
      onPressed: () {

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Timeline(
                ewoId: breakdown.dataPickingSparepart[int]['id'],
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
        breakdown.getTechnicianByDepartment(breakdown.dataPickingSparepart[index]['sbu']);
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

  onPickupPM02(
      BuildContext context, String title, String content, BreakdownProvider breakdown) {
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
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailEwoSparepart(data: breakdown.EWODetail,)));
                }
            ),
          ],
        );
      },
    );
  }

}
