import 'dart:convert';
import 'dart:io';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class EditBreakdownForm extends StatefulWidget {
  String ewoId;

  EditBreakdownForm({Key key, @required this.ewoId}) : super(key: key);
  @override
  _EditBreakdownFormState createState() => _EditBreakdownFormState();
}

class _EditBreakdownFormState extends State<EditBreakdownForm> {



  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, BreakdownProvider>(builder: (context, digiPM, breakdown, __) {
      return WillPopScope(
        onWillPop: () {
          onDialogCancel(context, 'Confirmation', 'Do you want to go back to the previous page?', breakdown);
        },
        child: StatefulWrapper(
          onInit: ()async{
            await breakdown.getEWODetail('PM02', widget.ewoId);

            await breakdown.getAutoNumber();
            String numbLastEwo = breakdown.EWODetail['ewo_number'];
            var numbLast = numbLastEwo.substring(numbLastEwo.length - 7);
            breakdown.setDataAUTO_NUMBER(numbLast);
            breakdown.getLINE(breakdown.EWODetail['sbu']);
            breakdown.getMACHINE(breakdown.EWODetail['sbu'], breakdown.EWODetail['line']);
            breakdown.getUNIT(breakdown.EWODetail['sbu'], breakdown.EWODetail['line'], breakdown.EWODetail['machine']);
            breakdown.getSUB_UNIT(breakdown.EWODetail['sbu'], breakdown.EWODetail['line'], breakdown.EWODetail['machine'], breakdown.EWODetail['equipment']);
            breakdown.setValueSbu(breakdown.EWODetail['sbu']);
            breakdown.setValueLine(breakdown.EWODetail['line']);
            breakdown.setValueMachine(breakdown.EWODetail['machine']);
            breakdown.setValueUnit(breakdown.EWODetail['equipment']);
            breakdown.setValueSubUnit(breakdown.EWODetail['sub_unit']);
            breakdown.setValueKerusakan(breakdown.EWODetail['type_problem']);
            breakdown.setValuePerbaikan(breakdown.EWODetail['type_activity']);
            breakdown.setDataProblemDescription(breakdown.EWODetail['problem_description']);
            breakdown.setDataPMAT_DESCRIPTION(breakdown.EWODetail['pm_activity_type']);
            breakdown.setDataPILLAR_PIC(breakdown.EWODetail['related_to']);
            breakdown.getEarlyQuestion(breakdown.EWODetail['id']);

            // for (int i = 0 ; i < breakdown.PhotoSubmission.length; i++){
            //   print(breakdown.PhotoSubmission[i]['photo_path']);
            // }
          },
          child: GestureDetector(
            onTap: (){
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Edit Breakdown Form'),
              ),
              body: Container(
                color: Colors.blueGrey,
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
                                Material(
                                  color: Theme.of(context).primaryColor,
                                  shape: SuperellipseShape(
                                    borderRadius: BorderRadius.circular(28.0),
                                  ), // SuperellipseShape
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height/10,
                                    child: Center(
                                      child: Text(
                                        breakdown.valueSbu == null
                                            ? 'SKIN-'.toUpperCase()
                                            : breakdown.valueLine == null
                                            ? 'SKIN-${breakdown.valueSbu}-02'.toUpperCase()
                                            :  'SKIN-${breakdown.valueSbu}-02-${breakdown.valueLine}-${breakdown.valueAutoNumber}'
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ), // Container
                                ),
                                space20(),
                                DropdownSBU(context, digiPM, breakdown, 'SBU'),
                                space20(),
                                DropdownLINE(context, digiPM, breakdown, 'LINE'),
                                space20(),
                                DropdownMACHINE(context, digiPM, breakdown, 'MACHINE'),
                                space20(),
                                DropdownUNIT(context, digiPM, breakdown, 'UNIT'),
                                space20(),
                                DropdownSUB_UNIT(context, digiPM, breakdown, 'SUB UNIT'),
                                space20(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded( flex: 1,
                                      child: RadioButtonPROBLEM_TYPE(context, digiPM, breakdown,'PROBLEM TYPE'),
                                    ),
                                    Expanded(flex: 1, child: RadioButtonACTIVITY_TYPE(context, digiPM, breakdown,'ACTIVITY TYPE'))
                                  ],
                                ),
                                space20(),
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Container(
                                          child: GridView.count(
                                            shrinkWrap: true,
                                            crossAxisCount: breakdown.submissionProperty['max_photo'],
                                            children: List.generate(
                                                breakdown.submissionProperty['max_photo'], (index) {

                                              if (breakdown.PhotoSubmission.asMap().containsKey(index)) {
                                                return Image.network(breakdown.PhotoSubmission[index] == null ? '' : Api.BASE_URL+breakdown.PhotoSubmission[index]['photo_path']);
                                              } else {
                                                return Container(
                                                  margin: EdgeInsets.all(1),
                                                  child: Center(
                                                    child: Icon(Icons.camera_alt),
                                                  ),
                                                  color: Colors.grey,
                                                );
                                              }


                                            }),

                                          )),


                                      Center(
                                        child: FlatButton.icon(
                                          color: Theme.of(context).accentColor,
                                          textColor: Colors.white,
                                          icon: Icon(Icons.add_a_photo),
                                          label: Text('Upload Photo'),
                                          onPressed: () async {
                                            await getPhoto(context, breakdown);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                space20(),
                                TextBoxDescription(context, digiPM, breakdown, 'PROBLEM DESCRIPTION'),
                                space20(),
                                DropdownEWO_RELATED_TO(context, digiPM, breakdown, 'EWO RELATED TO'),
                                space20(),
                                TextBoxPillar(context, digiPM, breakdown, 'PILLAR'),
                                space20(),
                                TextBoxQuestion(context, digiPM, breakdown, 'APA/WHAT', 'WHAT'),
                                space20(),
                                TextBoxQuestion(context, digiPM, breakdown, 'WHO/SIAPA', 'WHO'),
                                space20(),
                                TextBoxQuestion(context, digiPM, breakdown, 'DIMANA/WHERE', 'WHERE'),
                                space20(),
                                TextBoxQuestion(context, digiPM, breakdown, 'KAPAN/WHEN', 'WHEN'),
                                space20(),
                                TextBoxQuestion(context, digiPM, breakdown, 'KENAPA/WHY', 'WHY'),
                                space20(),
                                TextBoxQuestion(context, digiPM, breakdown, 'BAGAIMANA/HOW', 'HOW'),
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
                              onDialogDelete(context, 'Confirmation', 'are you sure you want to delete ' + breakdown.EWODetail['ewo_number'], breakdown);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            label: Text('Delete',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                            icon: Icon(Icons.cancel, color:Colors.white,),
                            textColor: Colors.white,
                            splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                            color: Colors.red,),
                          RaisedButton.icon(
                            onPressed: (){
                              onDialogCancel(context, 'Confirmation', 'Do you want to go back to the previous page?', breakdown);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            label: Text('Cancel',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                            icon: Icon(Icons.cancel, color:Colors.white,),
                            textColor: Colors.white,
                            splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                            color: Colors.amber,),
                          RaisedButton.icon(
                            onPressed: (){
                              onValidateForm(context, breakdown);
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
            ),
          ),
        ),
      );
    });
  }

  // collapse function
  Future getPhoto(context, BreakdownProvider breakdown) async {
    await breakdown.getPhoto();
    return Future.value(false);
  }

  Widget space10(){
    return SizedBox(height: 10,);
  }
  Widget space20(){
    return SizedBox(height: 20,);
  }

  Widget DropdownSBU(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("-- SELECT --"),
                value: breakdown.valueSbu,
                items: breakdown.masterSbu.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['sbu']),
                    value: item['sbu'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    breakdown.setValueSbu(value);
                    breakdown.setValueLine(null);
                    breakdown.setValueMachine(null);
                    breakdown.setValueUnit(null);
                    breakdown.setValueSubUnit(null);
                  });
                  breakdown.getLINE(value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownLINE(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("-- SELECT --"),
                value: breakdown.valueLine,
                items: breakdown.masterLine.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['line']}"),
                    value: item['line'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    breakdown.setSubmissionItem('line', value);
                    breakdown.setValueLine(value);
                    breakdown.setValueMachine(null);
                    breakdown.setValueUnit(null);
                    breakdown.setValueSubUnit(null);
                  });
                  breakdown.getMACHINE(breakdown.valueSbu, value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownMACHINE(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("-- SELECT --"),
                value: breakdown.valueMachine,
                items: breakdown.masterMachine.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['machine']}"),
                    value: item['machine'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    breakdown.setSubmissionItem('machine', value);
                    breakdown.setValueMachine(value);
                    breakdown.setValueUnit(null);
                    breakdown.setValueSubUnit(null);
                  });
                  breakdown.getUNIT(breakdown.valueSbu, breakdown.valueLine, value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownUNIT(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("-- SELECT --"),
                value: breakdown.valueUnit,
                items: breakdown.masterUnit.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['unit']}"),
                    value: item['unit'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    breakdown.setSubmissionItem('equipment', value);
                    breakdown.setValueUnit(value);
                    breakdown.setValueSubUnit(null);
                  });
                  breakdown.getSUB_UNIT(breakdown.valueSbu, breakdown.valueLine, breakdown.valueMachine, value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownSUB_UNIT(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("-- SELECT --"),
                value: breakdown.valueSubUnit,
                items: breakdown.masterSubUnit.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['sub_equipment']}"),
                    value: item['sub_equipment'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    breakdown.setSubmissionItem('sub_unit', value);
                    breakdown.setValueSubUnit(value);
                  });
                },
              ),
            ),
          ],
        ));
  }

  Widget RadioButtonPROBLEM_TYPE(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        tittle.toString(),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700),
      ),
      Container(
        width:
        MediaQuery.of(context).size.width /
            2,
        child: RadioButtonGroup(
          orientation: GroupedButtonsOrientation
              .VERTICAL,
          margin:
          const EdgeInsets.only(left: 5.0),
          onSelected: (String selected) =>
              setState(() {
                breakdown.setValueKerusakan(selected);
                breakdown.setSubmissionItem('type_problem', selected);
              }),
          labels: <String>[
            "ELECTRIC",
            "MECHANIC",
          ],
          picked: breakdown.valueKerusakan,
          itemBuilder:
              (Radio rb, Text txt, int i) {
            return Row(
              children: <Widget>[
                rb,
                txt,
              ],
            );
          },
        ),
      )
    ],
    );
  }

  Widget RadioButtonACTIVITY_TYPE(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          tittle.toString(),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700),
        ),
        Container(
          width:
          MediaQuery.of(context).size.width /
              2,
          child: RadioButtonGroup(
            orientation: GroupedButtonsOrientation
                .VERTICAL,
            margin:
            const EdgeInsets.only(left: 5.0),
            onSelected: (String selected) =>
                setState(() {
                  breakdown.setValuePerbaikan(selected);
                  breakdown.setSubmissionItem('type_activity', selected);
                }),
            labels: <String>[
              "STOP",
              "RUNNING",
            ],
            picked: breakdown.valuePerbaikan,
            itemBuilder:
                (Radio rb, Text txt, int i) {
              return Row(
                children: <Widget>[
                  rb,
                  txt,
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget TextBoxDescription(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: breakdown.problemDescription,
                maxLines: 4,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                        Color.fromRGBO(18, 37, 63, 1.0),
                        width: 1.0),
                  ),
                  hintText: "Problem Description",
                ),
                onChanged: (val){
                  breakdown.setSubmissionItem('problem_description', val);
                },
              ),
            )
          ],
        ));
  }

  Widget DropdownEWO_RELATED_TO(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("-- SELECT --"),
                value: breakdown.valueActivity,
                items: breakdown.masterActivity.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['activity_type'] +
                        ' - ' +
                        item['pmat_description']),
                    value: item['id'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    breakdown.setValueActivity(value);
                  });
                  breakdown.getPILLAR(value);
                },
              ),
            ),
          ],
        ));
  }

  Widget TextBoxPillar(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Container(
              child: TextField(
                onChanged: (value){
                  breakdown.setSubmissionItem('related_to', breakdown.valuePillarPIC);
                },
                readOnly: true,
                decoration: InputDecoration(
                    hintText: breakdown.valuePillarPIC == null
                        ? ' - '
                        : breakdown.valuePillarPIC.toString(),
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    border: InputBorder.none,
                    filled: true),
              ),
            ),
          ],
        ));
  }

  Widget TextBoxQuestion(BuildContext context, DigiPMProvider digiPM, BreakdownProvider breakdown, String tittle, String keywordAsk){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tittle.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                maxLines: 2,
                controller: breakdown.setQuestionSubmission(keywordAsk),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                    ),
                    hintText: "Enter your text here"),
                onChanged: (val){
                  breakdown.setSubmissionItem(keywordAsk, val, 'question');
                },
              ),
            )
          ],
        ));
  }

  onValidateForm(BuildContext context, BreakdownProvider breakdown) {
    // if(breakdown.submissionProperty['sbu'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select SBU");
    //   return null;
    // }
    // if(breakdown.submissionProperty['line'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select LINE");
    //   return null;
    // }
    // if(breakdown.submissionProperty['machine'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select Machine");
    //   return null;
    // }
    // if(breakdown.submissionProperty['equipment'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select Unit");
    //   return null;
    // }
    // if(breakdown.submissionProperty['sub_unit'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select Sub Unit");
    //   return null;
    // }
    // if(breakdown.submissionProperty['type_problem'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select Type Problem");
    //   return null;
    // }
    // if(breakdown.submissionProperty['type_activity'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select type activity");
    //   return null;
    // }
    // if(breakdown.submissionProperty['photo_submission'][0]['img_path'] == null){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Upload Photo ");
    //   return null;
    // }
    // if(breakdown.submissionProperty['problem_description'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Fill problem description");
    //   return null;
    // }
    // if(breakdown.submissionProperty['pm_activity_type'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Select pm activity type");
    //   return null;
    // }
    // if(breakdown.submissionProperty['question']['WHAT'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Fill Column of What");
    //   return null;
    // }
    // if(breakdown.submissionProperty['question']['WHO'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Fill Column of Who");
    //   return null;
    // }
    // if(breakdown.submissionProperty['question']['WHERE'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Fill Column of Where");
    //   return null;
    // }
    // if(breakdown.submissionProperty['question']['WHEN'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Fill Column of When");
    //   return null;
    // }
    // if(breakdown.submissionProperty['question']['WHY'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Fill Column of Why");
    //   return null;
    // }
    // if(breakdown.submissionProperty['question']['HOW'] == ''){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Fill Column of How");
    //   return null;
    // }

    return onDialogSave(context, 'Confirmation', 'Do data have been filled in correctly?', breakdown);
  }

  onDialogSave(
      BuildContext context, String title, String content, BreakdownProvider breakdown) {
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
                }
            ),
          ],
        );
      },
    );
  }

  saveForm(BuildContext context, BreakdownProvider breakdown) async {
    breakdown.setGenerateEWO('SKIN-${breakdown.valueSbu}-03-${breakdown.valueLine}-${breakdown.valueAutoNumber}'.toUpperCase());
    Util.loader(context, "", "Saving...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {
      'photo' : breakdown.submissionProperty['photo_submission'],
      'payload' : {
        'id' : breakdown.submissionProperty['id'],
        'pm_type' : breakdown.submissionProperty['pm_type'],
        'ewo_number' : breakdown.submissionProperty['ewo_number'],
        'sbu' : breakdown.submissionProperty['sbu'],
        'line' : breakdown.submissionProperty['line'],
        'machine' : breakdown.submissionProperty['machine'],
        'equipment' : breakdown.submissionProperty['equipment'],
        'sub_unit' : breakdown.submissionProperty['sub_unit'],

        'type_problem' : breakdown.submissionProperty['type_problem'],
        'type_activity' : breakdown.submissionProperty['type_activity'],
        'problem_description' : breakdown.submissionProperty['problem_description'],
        'pm_activity_type' : breakdown.submissionProperty['pm_activity_type'],

        'related_to': breakdown.submissionProperty['related_to'],

        'created_by' : prefs.getString('id_user'),
        'question' : breakdown.submissionProperty['question']
      }
    };


    try {
      breakdown.saveFormBreakdown(data).then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(val);

        if(val == "timeout") {
          Util.alert(context, "Error", "Network error. please check your internet network").then((val)  {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        if (val == "offline") {
          Util.alert(context, "Error", "Network error. please check your internet network").then((val) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
        }

        var res = jsonDecode(val);

        if(res['code_status'] == 1){
          // print('oke');
          Navigator.of(context);
          Navigator.of(context);
          await Util.alert(context, "Success", "You have saved the breakdown Form", 'submissionPM02');
          clearFormData(breakdown);

          // await Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) {
          //       return new breakdownTab();
          //     }), (Route<dynamic> route) => false);

        }

      });
    } catch (e){
      Util.alert(context, "error", "Internal error occured. Please contact developer").then((value) async {
        clearFormData(breakdown);
        Navigator.pop(context);
      });
    }
  }

  clearFormData(BreakdownProvider breakdown) {
    breakdown.setSubmissionItem('ewo_number', null);
    breakdown.setValueSbu(null);
    breakdown.setValueLine(null);
    breakdown.setValueMachine(null);
    breakdown.setValueUnit(null);
    breakdown.setValueSubUnit(null);
    breakdown.setValueKerusakan(null);
    breakdown.setValuePerbaikan(null);

    breakdown.setDataLINE([]);
    breakdown.setDataMACHINE([]);
    breakdown.setDataUNIT([]);
    breakdown.setDataSUB_UNIT([]);

    breakdown.setValueActivity(null);
    breakdown.setDataPILLAR_PIC(null);
    breakdown.setDataPMAT_DESCRIPTION(null);

    breakdown.setDataProblemDescription('');

    breakdown.setSubmissionItem('photo_submission', [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ]);

    breakdown.setSubmissionItem('photo', []);
    breakdown.setSubmissionItem('photo_submission_counter', 0);
    breakdown.setDataAnswerWhat('');
    breakdown.setDataAnswerWho('');
    breakdown.setDataAnswerWhere('');
    breakdown.setDataAnswerWhen('');
    breakdown.setDataAnswerWhy('');
    breakdown.setDataAnswerHow('');
  }



  onDialogCancel(
      BuildContext context, String title, String content, BreakdownProvider breakdown) {
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
                  clearFormData(breakdown);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
            ),
          ],
        );
      },
    );
  }

  onDialogDelete(
      BuildContext context, String title, String content, BreakdownProvider breakdown) {
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
                  deleteForm(context, breakdown);
                }
            ),
          ],
        );
      },
    );
  }

  deleteForm(BuildContext context, BreakdownProvider breakdown){
    print('ID NYA');
    print(breakdown.EWODetail['id']);
    breakdown.deleteFormBreakdown(breakdown.EWODetail['id']).then((val) async {
      if(val['code_status'] == 1) {
        Navigator.of(context);
        Navigator.of(context);
        await Util.alert(context, "Success", "You have deleted the breakdown Form", 'submissionPM02');
        clearFormData(breakdown);
      }
    });
  }

}
