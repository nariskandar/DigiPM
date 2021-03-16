import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Summary extends StatefulWidget {
  Map<String, dynamic> data;

  Summary({Key key, @required this.data}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState(data);
}

class _SummaryState extends State<Summary> {
  Map<String, dynamic> data;

  _SummaryState(this.data);

  String _valSbu, _valLine, _valMachine, _valUnit, _valSubUnit, _valKerusakan, _valPerbaikan, _valPillar, _autoNumber, _valEmployeeId, _valEmployeeName, _valPmaDesc, _valAllDate;
  String valScaleOne, valScaleTwo, valSeverityLevel, valDescription, valCurrentDate, valTimeline, valExeDate;
  String descriptionAnalysis;

  Map<String, dynamic> problemDesc;
  String dataPicture;

  Map<String, dynamic> allDataJustification;
  List dataJustification;
  String valLevel1,
      valLevel2,
      valSuggestion,
      valAssignedPillar,
      valManning,
      valStdDurasi,
      valExeDateJustification;
  List dataTindakan;

  List dataSparepart;
  String totalSparepart;
  String numbLast;

  final valwhat = TextEditingController();
  final valwhen = TextEditingController();
  final valwhere = TextEditingController();
  final valwhy = TextEditingController();
  final valwho = TextEditingController();
  final valhow = TextEditingController();

  final valChecklist1 = TextEditingController();
  final valChecklist2 = TextEditingController();
  final valChecklist3 = TextEditingController();
  final valChecklist4 = TextEditingController();
  final valChecklist5 = TextEditingController();
  final valChecklist6 = TextEditingController();

  final valTindakan1 = TextEditingController();
  final valTindakan2 = TextEditingController();
  final valTindakan3 = TextEditingController();
  final valTindakan4 = TextEditingController();
  final valTindakan5 = TextEditingController();
  final valTindakan6 = TextEditingController();
  final description = TextEditingController();

  List<dynamic> dataAnalysis;
  List<dynamic> _dataSbu = List(),
      _dataLine = List(),
      _dataMachine = List(),
      _dataUnit = List(),
      _dataSubUnit = List(),
      _dataActivity = List(),
      _dataPillar = List(),
      _dataAllDate = List();
  List<dynamic> dataAnswer = List();
  List<dynamic> dataSeverity = List();

  var user_login;

  void getActivity() async {
    var listDataActivity = await Api.getActivity('PM03');
    setState(() {
      _dataActivity = listDataActivity;
    });
  }

  void getAutoNumber() async {
    var autoNumber = await Api.getAutoNumber();
    setState(() {
      _autoNumber = autoNumber;
    });
  }



  void getViewSeverity(String severityId) async {
    var response = await Api.getViewSeverity(severityId);
    print(response);
    setState(() {
      dataSeverity = response;
      dataSeverity.forEach((element) {
        valScaleOne = element['scale_one'];
        valScaleTwo = element['scale_two'];
        valSeverityLevel = element['code'];
        valDescription = element['code_description'];
        valCurrentDate = element['current_date'];
        valTimeline = element['number_of_weeks'];
        valExeDate = element['execution_date'];
      });
    });
  }


  void getViewAnalysis(String ewoId) async {
    var response = await Api.getViewAnalysis(ewoId);
    setState(() {
      dataAnalysis = response;
      descriptionAnalysis = dataAnalysis[0]['description'];
      dataPicture = dataAnalysis[0]['picture'];
      valChecklist1.text = dataAnalysis[0]['problem_desc'];
      valChecklist2.text = dataAnalysis[1]['problem_desc'];
      valChecklist3.text = dataAnalysis[2]['problem_desc'];
      valChecklist4.text = dataAnalysis[3]['problem_desc'];
      valChecklist5.text = dataAnalysis[4]['problem_desc'];
      valChecklist6.text = dataAnalysis[5]['problem_desc'];
    });
  }

  void getViewJustification(String ewoId) async {
    var response = await Api.getViewJustification(ewoId);
    setState(() {
      allDataJustification = response;
      dataJustification = allDataJustification['data'];
      dataJustification.forEach((element) {
        valLevel1 = element['level_1'];
        valLevel2 = element['level_2'];
        valSuggestion = element['suggestion'];
        valAssignedPillar = element['assigned_pillar'];
        valManning = element['manning'];
        valStdDurasi = element['std_durasi'];
        valExeDateJustification = element['execution_date'];
      });
      dataTindakan = allDataJustification['tindakan'];

      valTindakan1.text = allDataJustification['tindakan'][0]['tindakan'];
      valTindakan2.text = allDataJustification['tindakan'][1]['tindakan'];
      valTindakan3.text = allDataJustification['tindakan'][2]['tindakan'];
      valTindakan4.text = allDataJustification['tindakan'][3]['tindakan'];
      valTindakan5.text = allDataJustification['tindakan'][4]['tindakan'];
      valTindakan6.text = allDataJustification['tindakan'][5]['tindakan'];
    });
  }

  void getViewSparepart(String ewoId) async {
    var response = await Api.getViewSparepart(ewoId);
    setState(() {
      dataSparepart = response['data'];
      totalSparepart = response['total']['jumlah'];
    });
  }

  void getEarlyQuestion(String ewoId) async {
    var dataEarlyQuestion = await Api.getEarlyQuestion(ewoId);
    setState(() {
      dataAnswer = dataEarlyQuestion;
      // for(var i )
      valwhat.text = dataAnswer[0]['answer'];
      valwho.text = dataAnswer[1]['answer'];
      valwhere.text = dataAnswer[2]['answer'];
      valwhen.text = dataAnswer[3]['answer'];
      valwhy.text = dataAnswer[4]['answer'];
      valhow.text = dataAnswer[5]['answer'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.data != null) {
      String numbLastEwo = widget.data['ewo_number'];
      numbLast = numbLastEwo.substring(numbLastEwo.length - 7);
      _valSbu = widget.data['sbu'].toString().toUpperCase();
      _valLine = widget.data['line'].toString();
      _valMachine = widget.data['machine'].toString();
      _valUnit = widget.data['equipment'].toString();
      _valSubUnit = widget.data['sub_unit'].toString();
      _valKerusakan = widget.data['type_problem'].toString();
      _valPerbaikan = widget.data['type_activity'].toString();
      description.text = widget.data['problem_description'];
      _valPmaDesc = widget.data['pm_activity_type'];
      _valPillar = widget.data['related_to'];

    }

    //function
    getEarlyQuestion(widget.data['id']);
    if(widget.data['SEVERITY'] != null){
      getViewSeverity(widget.data['SEVERITY']);
    }
    if(widget.data['ANALYSIS'] != null){
      getViewAnalysis(widget.data['id']);
    }
    if(widget.data['JUSTIFICATION'] != null){
      getViewJustification(widget.data['id']);
      getViewSparepart(widget.data['id']);
    }
    getAutoNumber();
    _setEmployeeId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return StatefulWrapper(
        onInit: (){
          abnormality.getEWODetail('PM03', widget.data['id']);
        },
        child: Scaffold(
          body: Container(
            child: Card(
              margin: EdgeInsets.all(7),
              color: Colors.white,
              elevation: 5,
              child: ListView(
                children: <Widget>[
                  //Submission
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // RaisedButton(
                        //   child: Text('print' ),
                        //   onPressed: (){
                        //     print(widget.data['SEVERITY']);
                        //   }
                        // ),
                        stepName('Submission'),
                        Container(
                          padding: EdgeInsets.all(13),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      QrImage(
                                        data: '${widget.data['ewo_number']}',
                                        version: QrVersions.auto,
                                        size: 150.0,
                                      ),
                                      Text('${widget.data['ewo_number']}')
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'SBU',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w700),
                                                  ),
                                                  Container(
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      child: Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 10),
                                                          child: Text(_valSbu
                                                              .toString()))),
                                                ],
                                              ),),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'LINE',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10),
                                                        child: Text(_valLine))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'MACHINE',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10),
                                                        child:
                                                        Text(_valMachine))),
                                              ],
                                            ),),
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Sub Unit',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10),
                                                        child:
                                                        Text(_valSubUnit))),
                                              ],
                                            ),),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Unit',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10),
                                                        child: Text(_valUnit))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),


                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Problem Type',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(_valKerusakan))),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Activity Type',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(_valPerbaikan))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        child: GridView.count(
                                          shrinkWrap: true,
                                          crossAxisCount: abnormality.submissionProperty['max_photo'],
                                          children: List.generate(
                                              abnormality.submissionProperty['max_photo'], (index) {

                                            if (abnormality.PhotoSubmission.asMap().containsKey(index)) {
                                              return Image.network(abnormality.PhotoSubmission[index] == null ? '' : Api.BASE_URL_PM03+abnormality.PhotoSubmission[index]['photo_path']);
                                            } else {
                                              return Container(
                                                margin: EdgeInsets.all(1),
                                                child: Center(
                                                ),
                                              );
                                            }


                                          }),

                                        )),



                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Problem Description',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Card(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextField(
                                              readOnly: true,
                                              controller: description,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                              ),
                                            ),
                                          ))
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'EWO Related to',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Text(
                                                  _valPillar + ' - ' + _valPmaDesc))),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              // Container(
                              //     child: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: <Widget>[
                              //     Text(
                              //       'Pillar Related to',
                              //       style: TextStyle(
                              //           fontSize: 15,
                              //           fontWeight: FontWeight.w700),
                              //     ),
                              //     Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //             padding: EdgeInsets.only(top: 10),
                              //             child: Text(
                              //                 _valPillar))),
                              //   ],
                              // )),
                              SizedBox(
                                height: 10,
                              ),
                              earlyQuestion('What / Apa', valwhat),
                              SizedBox(
                                height: 10,
                              ),
                              earlyQuestion('Who / Siapa', valwhat),
                              SizedBox(
                                height: 10,
                              ),
                              earlyQuestion('Where / Dimana', valwhere),
                              SizedBox(
                                height: 10,
                              ),
                              earlyQuestion('When / Kapan', valwhen),
                              SizedBox(
                                height: 10,
                              ),
                              earlyQuestion('Why / Kenapa', valwhy),
                              SizedBox(
                                height: 10,
                              ),
                              earlyQuestion('How / Bagaimana', valhow),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  widget.data['SEVERITY'] != null ?
                  //Severity
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        stepName('Severity'),
                        Container(
                          padding: EdgeInsets.all(13),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Effect Severity',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(
                                                            valScaleOne.toString()))),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Occurance Probability',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(
                                                            valScaleTwo.toString()))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Severity Level',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(valSeverityLevel
                                                            .toString()))),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Code Description',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(valDescription
                                                            .toString()))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Current Date',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(valCurrentDate
                                                            .toString()))),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Timeline (week)',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(
                                                            valTimeline.toString()))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Execution Date',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              child: Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child:
                                                  Text(valExeDate.toString()))),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )
                      : SizedBox.shrink(),

                  //Analysis
                  widget.data['ANALYSIS'] != null ?
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        stepName('Analysis'),
                        Container(
                          padding: EdgeInsets.all(13),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Deskripsi Analisis Awal',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              child: Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                      descriptionAnalysis.toString()))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              height:
                                              MediaQuery.of(context).size.height /
                                                  3,
                                              decoration: new BoxDecoration(
                                                  image: new DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(Api
                                                          .BASE_URL_PM03 +
                                                          dataPicture.toString())))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Checklist kemungkinan penyebab masalah',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              child: Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      checklist(valChecklist1),
                                                      checklist(valChecklist2),
                                                      checklist(valChecklist3),
                                                      checklist(valChecklist4),
                                                      checklist(valChecklist5),
                                                      checklist(valChecklist6),
                                                    ],
                                                  ))),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                      : SizedBox.shrink(),

                  //Root cause justification
                  widget.data['JUSTIFICATION'] != null ?
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        stepName('Root cause justification'),
                        Container(
                          padding: EdgeInsets.all(13),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Rootcause Level 1',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              child: Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(valLevel1.toString()))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Rootcause Level 2',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              child: Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(valLevel2.toString()))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Suggestion',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              child: Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                      valSuggestion.toString()))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Manning pillar',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(
                                                            valManning.toString()))),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Std Durasi (menit)',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10),
                                                        child: Text(valStdDurasi
                                                            .toString()))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      tindakanLanjutan(context, 'Tindakan lanjutan 1',
                                          valTindakan1),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      tindakanLanjutan(context, 'Tindakan lanjutan 2',
                                          valTindakan2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      tindakanLanjutan(context, 'Tindakan lanjutan 3',
                                          valTindakan3),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      tindakanLanjutan(context, 'Tindakan lanjutan 4',
                                          valTindakan3),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      tindakanLanjutan(context, 'Tindakan lanjutan 5',
                                          valTindakan5),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      tindakanLanjutan(context, 'Tindakan lanjutan 6',
                                          valTindakan6),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                      : SizedBox.shrink(),

                  // Sparepart
                  widget.data['IS_NEED_SPARE_PART'] != null ?

                      dataSparepart == null
                          ? Center(child: CircularProgressIndicator(),)
:
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        stepName('Sparepart Picklist'),
                        Container(
                          padding: EdgeInsets.all(13),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              color: Colors.white,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: DataTable(
                                                  columns: [
                                                    DataColumn(
                                                        label: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        )),
                                                    DataColumn(
                                                        label: Text(
                                                          'Part ID',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        )),
                                                    DataColumn(
                                                        label: Text(
                                                          'Description',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        )),
                                                    DataColumn(
                                                        label: Text(
                                                          'Quantity',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        )),
                                                    DataColumn(
                                                        label: Text(
                                                          'Price',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        )),
                                                    DataColumn(
                                                        label: Text(
                                                          'Total Price',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ))
                                                  ],
                                                  rows:

                                                  dataSparepart // Loops through dataColumnText, each iteration assigning the value to element
                                                      .map(
                                                    ((element) => DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                            element[
                                                            "id"])),
                                                        DataCell(Text(element[
                                                        "part_number"])),
                                                        DataCell(Text(element[
                                                        "material_desc"])),
                                                        DataCell(Text(element[
                                                        "req_qty"])), //Extracting from Map element the value
                                                        DataCell(Text(NumberFormat.currency(
                                                            locale:
                                                            'id',
                                                            symbol:
                                                            'Rp ',
                                                            decimalDigits:
                                                            0)
                                                            .format(int.parse(
                                                            element[
                                                            'price_per_pc'])))),
                                                        DataCell(Text(NumberFormat.currency(
                                                            locale:
                                                            'id',
                                                            symbol:
                                                            'Rp ',
                                                            decimalDigits:
                                                            0)
                                                            .format(int.parse(
                                                            element[
                                                            'total'])))),
                                                      ],
                                                    )),
                                                  ).toList()


                                                ),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Total Price',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              // DataCell(),
                                              Expanded(
                                                flex: 1,
                                                child: Text(NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0)
                                                    .format(int.parse(
                                                    totalSparepart.toString()))),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  )
                      : SizedBox.shrink(),



                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    var employeeName = prefs.getString("employee_name");
    setState(() {
      _valEmployeeId = employeeId;
      _valEmployeeName = employeeName;
    });
  }

  void reloadUser() {
    SharedPreferences.getInstance().then((prefs) {
      Api.getUserlogin(prefs.getString("id_user")).then((val) {
        setState(() {
          user_login = val;
        });
      });
    });
  }
}

Widget stepName(String tittle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          tittle,
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      Divider(
        height: 5.0,
        color: Colors.black,
      )
    ],
  );
}

Widget tindakanLanjutan(BuildContext context, String tittle, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        tittle,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      Card(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              readOnly: true,
              controller: controller,
              maxLines: 1,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ))
    ],
  );
}

Widget checklist(controller) {
  return Card(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          readOnly: true,
          controller: controller,
          maxLines: 1,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ));
}

Widget earlyQuestion(String tittle, controller) {
  return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tittle,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          Card(
            // color: Colors.black12.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  readOnly: true,
                  maxLines: 2,
                  controller: controller,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ))
        ],
      ));
}
