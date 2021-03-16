import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/popup.dart';
import 'package:digi_pm_skin/fragments/abnormality/popup_content.dart';
import 'package:digi_pm_skin/fragments/abnormality/spare_part.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'popup.dart';
import 'popup_content.dart';


class JustificationForm2 extends StatefulWidget {
  Map<String, dynamic> data;

  JustificationForm2({Key key, @required this.data}) : super(key : key);


  @override
  _JustificationForm2State createState() => _JustificationForm2State(data);
}

class _JustificationForm2State extends State<JustificationForm2> {
  Map<String, dynamic> data;

  _JustificationForm2State(this.data);

  final valTindakan1 = TextEditingController();
  final valTindakan2 = TextEditingController();
  final valTindakan3 = TextEditingController();
  final valTindakan4 = TextEditingController();
  final valTindakan5 = TextEditingController();
  final valTindakan6 = TextEditingController();

  double valTechnician = 0.0;
  final valDuration = TextEditingController();
  bool valSparePart = false;

  String valPart1, valPart2, valPart3, valPart4, valPart5;
  String valqty1, valqty2, valqty3, valqty4, valqty5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valTindakan1.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    valTindakan1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return WillPopScope(
        onWillPop: () {
          onDialogCancel(context, 'Confirmation',
              'Do you want to go back to the previous page?', abnormality);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Follow-up action"),
          ),
          body: Container(
            child: Card(
              shadowColor: Colors.grey,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            textField('1', valTindakan1),
                            SizedBox(height: 10,),
                            textField('2', valTindakan2),
                            SizedBox(height: 10,),
                            textField('3', valTindakan3),
                            SizedBox(height: 10,),
                            textField('4', valTindakan4),
                            SizedBox(height: 10,),
                            textField('5', valTindakan5),
                            SizedBox(height: 10,),
                            widget.data['pillar'] == "PM" ?
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text('Apakah perbaikan menggunakan sparepart ?'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Switch(
                                    value: valSparePart,
                                    onChanged: (value) {
                                      setState(() {
                                        valSparePart = value;
                                      });

                                      if(valSparePart == true || valSparePart == 1){
                                        showPopup(context, _withSparePart(), 'Picklist Sparepart');
                                      }else if (valSparePart == false || valSparePart == 0) {
                                        delPicklistSparepart();
                                      };

                                    },
                                    activeColor: Colors.deepOrange,
                                  ),
                                )
                              ],
                            ) : Row(),
                            // Text(valSparePart.toString()),
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
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
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
                          saveJustification(context, digiPM);
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
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
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
                      Navigator.pop(context);
                      setState(() {
                        valSparePart = false;

                      });//close the popup
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

  Widget _withSparePart() {
    return Container(
      child: SparePart(ewoId : widget.data['ewo_id']),
    );
  }


  Widget textField(String no, dynamic controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Follow-up Action $no',
        labelStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
      ),
    );
  }
  

  Future<String> getPicklistSparepart() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var part1 = prefs.getString('part1');
    var part2 = prefs.getString('part2');
    var part3 = prefs.getString('part3');
    var part4 = prefs.getString('part4');
    var part5 = prefs.getString('part5');

    var qty1 = prefs.getString('qty1');
    var qty2 = prefs.getString('qty2');
    var qty3 = prefs.getString('qty3');
    var qty4 = prefs.getString('qty4');
    var qty5 = prefs.getString('qty5');

    setState(() {
      valPart1 = part1;
      valPart2 = part2;
      valPart3 = part3;
      valPart4 = part4;
      valPart5 = part5;

      valqty1 = qty1;
      valqty2 = qty2;
      valqty3 = qty3;
      valqty4 = qty4;
      valqty5 = qty5;
    });

  }
  
  Future<String> delPicklistSparepart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var part1 = prefs.remove('part1');
    var part2 = prefs.remove('part2');
    var part3 = prefs.remove('part3');
    var part4 = prefs.remove('part4');
    var part5 = prefs.remove('part5');

    var qty1 = prefs.remove('qty1');
    var qty2 = prefs.remove('qty2');
    var qty3 = prefs.remove('qty3');
    var qty4 = prefs.remove('qty4');
    var qty5 = prefs.remove('qty5');
  }

  saveJustification(context, DigiPMProvider digiPM) async {

    if ( valTindakan1.text == "") {
      Util.alert(context, 'Validation', 'Please fill in at least 3 (three), for the follow-up action');
      return;
    }

    if ( valTindakan2.text == "") {
      Util.alert(context, 'Validation', 'Please fill in at least 3 (three), for the follow-up action');
      return;
    }

    if ( valTindakan3.text == "") {
      Util.alert(context, 'Validation', 'Please fill in at least 3 (three), for the follow-up action');
      return;
    }

    valSparePart == false ? 0 : 1;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var part1 = prefs.getString('part1');
    var part2 = prefs.getString('part2');
    var part3 = prefs.getString('part3');
    var part4 = prefs.getString('part4');
    var part5 = prefs.getString('part5');

    var qty1 = prefs.getString('qty1');
    var qty2 = prefs.getString('qty2');
    var qty3 = prefs.getString('qty3');
    var qty4 = prefs.getString('qty4');
    var qty5 = prefs.getString('qty5');


    final data = {
      'id' : null,
      'ewo_id' : widget.data['ewo_id'],
      'root_cause_id' : widget.data['root_cause_id'],
      'manning' : widget.data['manning'],
      'std_durasi' : widget.data['std_durasi'],
      'execution_date' : widget.data['execution_date'],
      'is_need_spare_part' : valSparePart == false ? 0 : 1,
      'created_by' : widget.data['created_by'],
      'action' : {
        'tindakan1' : valTindakan1.text,
        'tindakan2' : valTindakan2.text,
        'tindakan3' : valTindakan3.text,
        'tindakan4' : valTindakan4.text,
        'tindakan5' : valTindakan5.text
      },
      'sparepart' : [
        {"part_number": part1, "qty": qty1},
        {"part_number": part2, "qty": qty2},
        {"part_number": part3, "qty": qty3},
        {"part_number": part4, "qty": qty4},
        {"part_number": part5, "qty": qty5}
      ]

    };




    Api.saveJustification(data).then((value)  {
      setState(() {
        if(value['code_status'] == 1)  {
          alert(context, "Success", "Saved successfully");
        }
      });
    });


  }


  static Future<void> alert(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Justification()));;
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  onDialogCancel(BuildContext context, String title, String content,
      AbnormalityProvider abnormality) {
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  dataRefresher(abnormality);
                }),
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