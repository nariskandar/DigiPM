import 'package:digi_pm_skin/fragments/abnormality/summary.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'popup.dart';
import 'popup_content.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FormNonShe extends StatefulWidget {
  Map<String, dynamic> data;

  FormNonShe({Key key, @required this.data}) : super(key: key);

  @override
  _FormNonSheState createState() => _FormNonSheState(data);
}

class _FormNonSheState extends State<FormNonShe> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  Map<String, dynamic> data;
  Map<String, dynamic> dataSeverity;

  _FormNonSheState(this.data);

  double _effectSeverity = 0;
  double _occuranceProbability = 0;

  String pillar;

  void cekPillar(){
    if(data['pillar_to'] == "SHE"){
      setState(() {
        var she = pillar;
      });
    }else{
      setState(() {
        var she = pillar;
      });
    }
  }


  void getDataSeverity(dynamic scale_one, dynamic scale_two, String type) async {
    var data = await Api.getDataSeverity(scale_one, scale_two, type);
    setState(() {
      listSeverity = data;
      listSeverity.forEach((element) {
        dataSeverity = element;
        getExecuteDate(dataSeverity['days']);
      });
    });
  }

  String currentDate;
  String executionDate;

  void getExecuteDate (dynamic days) {
    final now = new DateTime.now();

    var day = int.parse(days);
    var execute = new DateTime(now.year, now.month, now.day + day);
    setState(() {
      executionDate = DateFormat('yyyy-MM-dd').format(execute);
    });
  }



  List listSeverity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dataSeverity;
      // dd-MM-yyyy
      final now = new DateTime.now();
      currentDate = DateFormat('yyyy-MM-dd').format(now);
    });

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return WillPopScope(
        onWillPop: (){
          onDialogCancel(context, 'Confirmation', 'Do you want to go back to the previous page?', abnormality);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Form Severity - ' + widget.data['related_to']),
          ),
          body: Container(
            child: Card(
              margin: EdgeInsets.all(7),
              color: Colors.white,
              elevation: 5,
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(13),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Effect Severity',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w700),
                                    ),
                                    Card(
                                      // color: Colors.black12.withOpacity(0.1),
                                        child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Slider(
                                              value: _effectSeverity,
                                              min: 0,
                                              max: 10,
                                              divisions: 10,
                                              label: _effectSeverity.round().toString(),
                                              onChanged: (double value) {
                                                setState(() {
                                                  _effectSeverity = value;
                                                });
                                                getDataSeverity(_occuranceProbability, _effectSeverity, 'NON SHE');
                                              },
                                            )
                                        ))
                                  ],
                                )),
                            SizedBox(height: 10,),
                            Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Occurance Probability',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w700),
                                    ),
                                    Card(
                                        child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Slider(
                                              value: _occuranceProbability,
                                              min: 0,
                                              max: 10,
                                              divisions: 10,
                                              label: _occuranceProbability.round().toString(),
                                              onChanged: (double value) {
                                                setState(() {
                                                  _occuranceProbability = value;
                                                });
                                                getDataSeverity(_occuranceProbability, _effectSeverity, 'NON SHE');
                                              },
                                            )
                                        ))
                                  ],
                                )),
                            SizedBox(height: 10,),
                            card(Colors.orangeAccent, dataSeverity ==  null ? " Severity Level : " : "Severity Level : " + dataSeverity['code'] ),
                            SizedBox(height: 10,),
                            card(dataSeverity == null ? Colors.green : dataSeverity['code_description'] == "No action needed" ? Colors.green : Colors.red, dataSeverity == null ? "-" : dataSeverity['code_description']),
                            SizedBox(height: 30,),
                            tittle('Current Date'),
                            card(Colors.grey, '$currentDate', Icon(Icons.timer)),
                            SizedBox(height: 10,),
                            tittle('Timeline (week)'),
                            card(Colors.grey, dataSeverity == null ? "-" : dataSeverity['number_of_weeks'] + ' Weeks'),
                            SizedBox(height: 10,),
                            tittle('Execution Date'),
                            card(Colors.grey, executionDate == null ? "-" : executionDate, Icon(Icons.timer)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: (){
                          onDialogCancel(context, 'Confirmation', 'Do you want to go back to the previous page?', abnormality);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        label: Text('Cancel',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                        icon: Icon(Icons.cancel, color:Colors.white,),
                        textColor: Colors.white,
                        splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                        color: Colors.red,),
                      RaisedButton.icon(
                        onPressed: (){
                          onValidateForm(context, abnormality);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        label: Text('Save',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                        icon: Icon(Icons.save, color:Colors.white,),
                        textColor: Colors.white,
                        splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                        color: Colors.green,),
                    ],
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showPopup(context, _popupBody(), 'Summary');
            },
            heroTag: "demoValue",
            tooltip: 'Severity Level',
            child: Icon(Icons.info),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      );
    });
  }

  onValidateForm(BuildContext context, AbnormalityProvider abnormality) {
    if(_effectSeverity == 0){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Effect Severity");
      return null;
    }
    if(_occuranceProbability == 0){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Occurance Probability");
      return null;
    }

    return onDialogSave(context, 'Confirmation', 'Do data have been filled in correctly?', abnormality);
  }

  onDialogSave(
      BuildContext context, String title, String content, AbnormalityProvider abnormality) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
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
                  saveForm(context, abnormality);
                }
            ),
          ],
        );
      },
    );
  }

  saveForm(BuildContext context, AbnormalityProvider abnormality) async {
    Util.loader(context, "", "Saving...");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = {
      "id" : null,
      "ewo_id" : widget.data['id'],
      "severity_id": dataSeverity['id'],
      "current_date": currentDate,
      "execution_date": executionDate,
      "created_by": prefs.getString('id_user'),
    };
    print(data);


    try {
      abnormality.saveSeverity(data).then((val) async {

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        print(val);

        // if(val == "timeout") {
        //   Util.alert(context, "Error", "Network error. please check your internet network").then((val)  {
        //     Navigator.of(context).pop(true);
        //     Navigator.of(context).pop(true);
        //   });
        // }
        //
        // if (val == "offline") {
        //   Util.alert(context, "Error", "Network error. please check your internet network").then((val) {
        //     Navigator.of(context).pop(true);
        //     Navigator.of(context).pop(true);
        //   });
        // }

        // var res = jsonDecode(val);
        // print(res['code_status']);
        if(val['code_status'] == 1){
          // print('oke');
          Navigator.of(context);
          Navigator.of(context);
          await Util.alert(context, "Success", "You have saved the Severity Form", 'submissionPM03');
          dataRefresher(abnormality);

        }

      });
    } catch (e){
      Util.alert(context, "error", "Internal error occured. Please contact developer").then((value) async {
        Navigator.pop(context);
        dataRefresher(abnormality);
      });
    }
  }

  Widget tittle (String text){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text('$text', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
    );
  }

  Widget card (Color color1, String text1, [Icon icon1]) {
    return  Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon1 == null ?  Text('') : Icon(Icons.timer, color: Colors.white,),
              SizedBox(width: 10,),
              Text('$text1 ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),)
            ],
          )
        ],
      ),
    );
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext AbnormalityFormView1}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBody() {
    return Container(
      child: Summary(data: widget.data,),
    );
  }

  onDialogCancel(
      BuildContext context, String title, String content, AbnormalityProvider abnormality) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  // clearFormData(abnormality);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  dataRefresher(abnormality);
                }
            ),
          ],
        );
      },
    );
  }

  void dataRefresher(AbnormalityProvider abnormality) async {
    abnormality.setLoadingState(true);
    await abnormality.getEWO(context,'PM03');
    abnormality.setLoadingState(false);
  }



}
