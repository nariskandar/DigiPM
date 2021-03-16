import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/fragments/abnormality/TesView.dart';
import 'package:digi_pm_skin/fragments/abnormality/summary.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_switch/flutter_switch.dart';

// import 'analysis_form2.dart';

class AnalysisFormBreakdown extends StatefulWidget {
  String ewoId;

  AnalysisFormBreakdown({Key key, @required this.ewoId}) : super(key: key);

  @override
  _AnalysisFormBreakdownState createState() =>
      _AnalysisFormBreakdownState(ewoId);
}

class _AnalysisFormBreakdownState extends State<AnalysisFormBreakdown> {
  String ewoId;

  _AnalysisFormBreakdownState(this.ewoId);

  File _storedImage;
  TextEditingController description;

  final no1 = TextEditingController();
  final no2 = TextEditingController();
  final no3 = TextEditingController();
  final no4 = TextEditingController();
  final no5 = TextEditingController();
  final no6 = TextEditingController();

  List<TextEditingController> textFieldControllers = [];

  List<dynamic> _nameSparepart = [];
  List<dynamic> _qtySparepart = [];


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
    return Consumer2<DigiPMProvider, BreakdownProvider>(
        builder: (context, digiPM, breakdown, __) {
      return WillPopScope(
        onWillPop: () {
          onDialogCancel(context, 'Confirmation',
              'Do you want to go back to the previous page?', breakdown);
        },
        child: StatefulWrapper(
          onInit: () async {
            await breakdown.getEWODetail('PM02', widget.ewoId);
            await breakdown.getMasterSparepart(
               breakdown.EWODetail['sbu'],
              breakdown.EWODetail['line'],
              breakdown.EWODetail['machine'],
              breakdown.EWODetail['equipment'],
              breakdown.EWODetail['sub_unit'],
            );
          },
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
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
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                          height: MediaQuery.of(
                                                                      context)
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
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Is it repair using spare parts?',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Card(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: FlutterSwitch(
                                          activeText: "YES",
                                          inactiveText: "NO",
                                          value: breakdown.isNeedSparepart,
                                          valueFontSize: 14.0,
                                          width: 100,
                                          borderRadius: 30.0,
                                          showOnOff: true,
                                          onToggle: (value) async {
                                            setState(() {
                                              breakdown
                                                  .setIsNeedSparepart(value);
                                            });

                                            if (breakdown.isNeedSparepart ==
                                                true) {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.remove('sparepart');
                                              needSparepart(breakdown, context);
                                              // clearFormSparepart(breakdown);
                                            } else if (breakdown
                                                    .isNeedSparepart ==
                                                false) {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.remove('sparepart');
                                              // clearFormSparepart(breakdown);
                                            }
                                          },
                                        ),
                                      )),
                                    )
                                  ],
                                )),
                                SizedBox(
                                  height: 20,
                                ),
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
                                  breakdown);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            label: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
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
                              onValidateForm(context, breakdown);
                              // saveAnalysis(context, digiPM);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            label: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
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
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     // Util.showPopup(context, _popupBody(), 'Summary');
              //   },
              //   heroTag: "demoValue",
              //   tooltip: 'Severity Level',
              //   child: Icon(Icons.info),
              // ),
            ),
          ),
        ),
      );
    });
  }

  // String selectedValue;
  // final List<DropdownMenuItem> items = [];

  Widget needSparepart(BreakdownProvider breakdown, BuildContext context) {
    if (breakdown.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (breakdown.masterSparepart == null ||
          breakdown.masterSparepart == []) {
        return showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('EWO Sparepart List'),
                content: Container(
                    height: 250,
                    child: Center(
                      child: Text('No Data'),
                    )),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      breakdown.setIsNeedSparepart(false);
                    },
                    child: new Text('Oke'),
                  ),
                ],
              ),
            ) ??
            false;
      }
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('EWO Sparepart List'),
              content: Container(
                  height: 250,
                  child: ListView.builder(
                      itemCount: breakdown.masterSparepart.length,
                      itemBuilder: (context, int index) {
                        for (var i = 0; i < 5; i++) {
                          textFieldControllers.add(TextEditingController());
                        }
                        return Column(
                          children: [
                            // RaisedButton(child: Text('print'),
                            // onPressed: (){
                            //   print(breakdown.masterSparepart);
                            // },),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        child: SearchableDropdown.single(
                                          items: breakdown.masterSparepart
                                              .map((item) {
                                            return DropdownMenuItem(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    item['part_number'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    item['part'],
                                                  ),
                                                ],
                                              ),
                                              value: item['part_number'],
                                            );
                                          }).toList(),
                                          hint: "Select Sparepart",
                                          searchHint: "Select Sparepart",
                                          onChanged: (value) {
                                            setState(() {
                                              _nameSparepart.add(value);
                                              // breakdown.setSelectedSparepart(value, textFieldControllers[index].text);
                                            });
                                          },
                                        ),
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: textFieldControllers[index],
                                      onSubmitted: (text) {
                                        textFieldControllers[index].text;
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38),
                                          ),
                                          hintText: 'Qty',
                                          suffixStyle:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      })),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    Navigator.of(context).pop(false);
                    breakdown.setIsNeedSparepart(false);
                    await prefs.remove('sparepart');
                    // clearFormSparepart(breakdown);
                  },
                  child: new Text('Cancel'),
                ),
                new FlatButton(
                  onPressed: () {
                    saveSparepart(context, breakdown);
                    Navigator.pop(context);
                  },
                  child: new Text('Save'),
                )
              ],
            ),
          ) ??
          false;
    }
  }

  onDialogCancel(BuildContext context, String title, String content,
      BreakdownProvider breakdown) {
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
                  try {
                    breakdown.isAnalyst(ewoId, '0').then((val) async {
                      if (val['code_status'] == 1) {
                        clearFormSparepart(breakdown);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        dataRefresher(breakdown);
                      }
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                }),
          ],
        );
      },
    );
  }

  onValidateForm(BuildContext context, BreakdownProvider breakdown) {
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

    return onDialogSave(context, 'Confirmation',
        'Do data have been filled in correctly?', breakdown);
  }

  onDialogSave(BuildContext context, String title, String content,
      BreakdownProvider breakdown) {
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
                  saveForm(context, breakdown);
                }),
          ],
        );
      },
    );
  }

  clearFormSparepart(BreakdownProvider breakdown) {
    breakdown.setSparepartItem('sparepart_list', [
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
    ]);
  }

  saveSparepart(BuildContext context, BreakdownProvider breakdown) async {
    for (var i = 0; i < _nameSparepart.length; i++) {
      breakdown.setSelectedSparepart(
          _nameSparepart[i], textFieldControllers[i].text);
    }
    final data = {
      'sparepart_list': breakdown.sparepartProperty['sparepart_list']
    };
    if (data['sparepart_list'][0]['part_number'] == null) {
      Util.alert(context, 'Validation', 'spare parts have not been selected');
      return;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('sparepart', json.encode(data));
    }
  }

  saveForm(BuildContext context, BreakdownProvider breakdown) async {
    Util.loader(context, "", "Saving...");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List _sparepartList;
    if (breakdown.isNeedSparepart == true){
      var sparepart = jsonDecode(prefs.getString('sparepart'));
      _sparepartList = sparepart['sparepart_list'];
    }


    final data = {
      'id': null,
      'description': description.text,
      'ewo_id': breakdown.EWODetail['id'],
      'created_by': prefs.getString('id_user'),
      'problem': {
        'no1': no1.text,
        'no2': no2.text,
        'no3': no3.text,
        'no4': no4.text,
        'no5': no5.text,
        'no6': no6.text
      },
      'is_need_spare_part': breakdown.isNeedSparepart == true ? 1 : 0,
      'sparepart': _sparepartList
    };

    try {
      breakdown.saveAnalysis(data, _storedImage).then((val) async {
        if (val == "timeout") {
          Util.alert(context, "Error",
                  "Network error. please check your internet network")
              .then((val) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        if (val == "offline") {
          Util.alert(context, "Error",
                  "Network error. please check your internet network")
              .then((val) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        var res = jsonDecode(val);
        print(res['code_status']);

        if (res['code_status'] == 1) {
          print('oke');
          Navigator.of(context);
          Navigator.of(context);
          await Util.alert(context, "Success",
              "You have saved the Analysis Form", 'analysisPM03');
          dataRefresher(breakdown);
        }
      });
    } catch (e) {
      Util.alert(context, "error",
              "Internal error occured. Please contact developer")
          .then((value) async {
        Navigator.pop(context);
        dataRefresher(breakdown);
      });
    }
  }

  Widget textField(String no, dynamic controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(padding: EdgeInsets.all(15), child: Text('$no. ')),
      ),
    );
  }

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _storedImage = image;
    });
  }

  void dataRefresher(BreakdownProvider breakdown) async {
    breakdown.setLoadingState(true);
    await breakdown.getEWO(context, 'PM02');
    breakdown.setLoadingState(false);
  }
}
