import 'package:digi_pm_skin/fragments/abnormality/summary.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalysisForm extends StatefulWidget {
  Map<String, dynamic> data;

  AnalysisForm({Key key, @required this.data}) : super(key: key);

  @override
  _AnalysisFormState createState() => _AnalysisFormState(data);
}

class _AnalysisFormState extends State<AnalysisForm> {
  Map<String, dynamic> data;

  _AnalysisFormState(this.data);

  File _storedImage;
  TextEditingController description;

  final no1 = TextEditingController();
  final no2 = TextEditingController();
  final no3 = TextEditingController();
  final no4 = TextEditingController();
  final no5 = TextEditingController();
  final no6 = TextEditingController();

  @override
  void initState() {
    description = TextEditingController();
    description.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(
        builder: (context, digiPM, abnormality, __) {
      return WillPopScope(
        onWillPop: () {
          onDialogCancel(context, 'Confirmation',
              'Do you want to go back to the previous page?', abnormality);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Analysis Form'),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Deskripsi Analisis Awal',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                Card(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: description,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.greenAccent,
                                              width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  18, 37, 63, 1.0),
                                              width: 1.0),
                                        ),
                                        hintText: "Enter your text here"),
                                  ),
                                ))
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ButtonTheme(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: OutlineButton(
                                            onPressed: () async {
                                              await getImage();
                                            },
                                            child: _storedImage == null
                                                ? Column(
                                                    children: [
                                                      Icon(
                                                        Icons.photo,
                                                        size: 25,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text('Upload Photo'),
                                                    ],
                                                  )
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 10, 0, 10),
                                                    child: Image.file(
                                                      _storedImage,
                                                      fit: BoxFit.scaleDown,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3,
                                                    ),
                                                  ),
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  18, 37, 63, 1.0),
                                              style: BorderStyle.solid,
                                              width: 1,
                                            ),
                                          ),
                                        )))
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Checklist of possible causes of the problem',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                Card(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      textField('1', no1),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textField('2', no2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textField('3', no3),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textField('4', no4),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textField('5', no5),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textField('6', no6),
                                    ],
                                  ),
                                ))
                              ],
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: () {
                          onDialogCancel(
                              context,
                              'Confirmation',
                              'Do you want to go back to the previous page?',
                              abnormality);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        label: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        textColor: Colors.white,
                        splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                        color: Colors.red,
                      ),
                      RaisedButton.icon(
                        onPressed: () {
                          onValidateForm(context, abnormality);
                          // saveAnalysis(context, digiPM);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        label: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        textColor: Colors.white,
                        splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                        color: Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Util.showPopup(context, _popupBody(), 'Summary');
            },
            heroTag: "demoValue",
            tooltip: 'Severity Level',
            child: Icon(Icons.info),
          ),
        ),
      );
    });
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
                  // clearFormData(abnormality);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  dataRefresher(abnormality);
                }),
          ],
        );
      },
    );
  }

  onValidateForm(BuildContext context, AbnormalityProvider abnormality) {
    if (description.text == "") {
      Util.alert(context, 'Validation', 'Please fill description');
      return;
    }
    if (_storedImage == null) {
      Util.alert(context, 'Validation', 'Please upload photo');
      return;
    }

    if (no1.text == "") {
      Util.alert(context, 'Validation',
          'Please fill in at least 3 (three), for possible causes of the problem');
      return;
    }

    if (no2.text == "") {
      Util.alert(context, 'Validation',
          'Please fill in at least 3 (three), for possible causes of the problem');
      return;
    }

    if (no3.text == "") {
      Util.alert(context, 'Validation',
          'Please fill in at least 3 (three), for possible causes of the problem');
      return;
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
      'id': null,
      'description': description.text,
      'ewo_id': widget.data['id'],
      'created_by': valEmployeeId,
      'problem': {
        'no1': no1.text,
        'no2': no2.text,
        'no3': no3.text,
        'no4': no4.text,
        'no5': no5.text,
        'no6': no6.text
      }
    };


    try {
      abnormality.saveAnalysis(data, _storedImage).then((val) async {

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

        var res = jsonDecode(val);
        print(res['code_status']);

        if(res['code_status'] == 1){
          // print('oke');
          Navigator.of(context);
          Navigator.of(context);
          await Util.alert(context, "Success", "You have saved the Analysis Form", 'analysisPM03');
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

  // saveAnalysis(context, DigiPMProvider digiPM) {
  //
  //
  //   Api.saveAnalysis(data, _storedImage).then((value) {
  //     print(value);
  //     var res = json.decode(value);
  //     print(res['code_status']);
  //
  //     if (res['code_status'] == 1) {
  //       Util.alert(context, 'Success', 'Saved successfully', 'analysisPM03');
  //     }
  //   });
  // }

  Widget textField(String no, dynamic controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(padding: EdgeInsets.all(15), child: Text('$no. ')),
      ),
    );
  }

  Widget _popupBody() {
    return Container(
      child: Summary(data: widget.data),
    );
  }

  String valEmployeeId;
  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    var employeeName = prefs.getString("employee_name");
    setState(() {
      valEmployeeId = employeeId;
      // _valEmployeeName = employeeName;
    });
  }

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _storedImage = image;
    });
  }

  void dataRefresher(AbnormalityProvider abnormality) async {
    abnormality.setLoadingState(true);
    await abnormality.getEWO(context,'PM03');
    abnormality.setLoadingState(false);
  }

}
