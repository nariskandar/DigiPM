import 'dart:convert';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class EditAbnormalityForm extends StatefulWidget {
  String ewoId;

  EditAbnormalityForm({Key key, @required this.ewoId}) : super(key: key);
  @override
  _EditAbnormalityFormState createState() => _EditAbnormalityFormState();
}

class _EditAbnormalityFormState extends State<EditAbnormalityForm> {

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return WillPopScope(
        onWillPop: () {
          onDialogCancel(context, 'Confirmation', 'Do you want to go back to the previous page?', abnormality);
        },
        child: StatefulWrapper(
          onInit: ()async{
            await abnormality.getEWODetail('PM03', widget.ewoId);

            await abnormality.getAutoNumber();
            String numbLastEwo = abnormality.EWODetail['ewo_number'];
            var numbLast = numbLastEwo.substring(numbLastEwo.length - 7);
            abnormality.setDataAUTO_NUMBER(numbLast);
            abnormality.getLINE(abnormality.EWODetail['sbu']);
            abnormality.getMACHINE(abnormality.EWODetail['sbu'], abnormality.EWODetail['line']);
            abnormality.getUNIT(abnormality.EWODetail['sbu'], abnormality.EWODetail['line'], abnormality.EWODetail['machine']);
            abnormality.getSUB_UNIT(abnormality.EWODetail['sbu'], abnormality.EWODetail['line'], abnormality.EWODetail['machine'], abnormality.EWODetail['equipment']);
            abnormality.setValueSbu(abnormality.EWODetail['sbu']);
            abnormality.setValueLine(abnormality.EWODetail['line']);
            abnormality.setValueMachine(abnormality.EWODetail['machine']);
            abnormality.setValueUnit(abnormality.EWODetail['equipment']);
            abnormality.setValueSubUnit(abnormality.EWODetail['sub_unit']);
            abnormality.setValueKerusakan(abnormality.EWODetail['type_problem']);
            abnormality.setValuePerbaikan(abnormality.EWODetail['type_activity']);
            abnormality.setDataProblemDescription(abnormality.EWODetail['problem_description']);
            abnormality.getACTIVITY('PM03', abnormality.EWODetail['pm_activity_type']);
            abnormality.setDataPMAT_DESCRIPTION(abnormality.EWODetail['pm_activity_type']);
            abnormality.setDataPILLAR_PIC(abnormality.EWODetail['related_to']);
            abnormality.getEarlyQuestion(abnormality.EWODetail['id']);
            // for (int i = 0 ; i < abnormality.PhotoSubmission.length; i++){
            //   print(abnormality.PhotoSubmission[i]['photo_path']);
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
                title: Text('Edit EWO Abnormality Form'),
              ),
              body: Container(
                color: Colors.blueGrey,
                child: Card(
                  margin: EdgeInsets.all(7),
                  color: Colors.white,
                  elevation: 5,
                  child: ListView(
                    children: <Widget>[
                      // RaisedButton(
                      //   child: Text('print'),
                      //   onPressed: (){
                      //
                      //   },
                      // ),
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
                                        abnormality.valueSbu == null
                                            ? 'SKIN-'.toUpperCase()
                                            : abnormality.valueLine == null
                                            ? 'SKIN-${abnormality.valueSbu}-03'.toUpperCase()
                                            :  'SKIN-${abnormality.valueSbu}-03-${abnormality.valueLine}-${abnormality.valueAutoNumber}'
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ), // Container
                                ),
                                space20(),
                                DropdownSBU(context, digiPM, abnormality, 'SBU'),
                                space20(),
                                DropdownLINE(context, digiPM, abnormality, 'LINE'),
                                space20(),
                                DropdownMACHINE(context, digiPM, abnormality, 'MACHINE'),
                                space20(),
                                DropdownUNIT(context, digiPM, abnormality, 'UNIT'),
                                space20(),
                                DropdownSUB_UNIT(context, digiPM, abnormality, 'SUB UNIT'),
                                space20(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded( flex: 1,
                                      child: RadioButtonPROBLEM_TYPE(context, digiPM, abnormality,'PROBLEM TYPE'),
                                    ),
                                    Expanded(flex: 1, child: RadioButtonACTIVITY_TYPE(context, digiPM, abnormality,'ACTIVITY TYPE'))
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
                                            crossAxisCount: abnormality.submissionProperty['max_photo'],
                                            children: List.generate(
                                                abnormality.submissionProperty['max_photo'], (index) {

                                                    if (abnormality.PhotoSubmission.asMap().containsKey(index)) {

                                                      return Image.network(abnormality.PhotoSubmission[index] == null ? '' : Api.BASE_URL+abnormality.PhotoSubmission[index]['photo_path']);
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
                                            await getPhoto(context, abnormality);
                                          },
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                                space20(),
                                TextBoxDescription(context, digiPM, abnormality, 'PROBLEM DESCRIPTION'),
                                space20(),
                                DropdownEWO_RELATED_TO(context, digiPM, abnormality, 'EWO RELATED TO'),
                                space20(),
                                TextBoxPillar(context, digiPM, abnormality, 'PILLAR'),
                                space20(),
                                TextBoxQuestion(context, digiPM, abnormality, 'APA/WHAT', 'WHAT'),
                                space20(),
                                TextBoxQuestion(context, digiPM, abnormality, 'WHO/SIAPA', 'WHO'),
                                space20(),
                                TextBoxQuestion(context, digiPM, abnormality, 'DIMANA/WHERE', 'WHERE'),
                                space20(),
                                TextBoxQuestion(context, digiPM, abnormality, 'KAPAN/WHEN', 'WHEN'),
                                space20(),
                                TextBoxQuestion(context, digiPM, abnormality, 'KENAPA/WHY', 'WHY'),
                                space20(),
                                TextBoxQuestion(context, digiPM, abnormality, 'BAGAIMANA/HOW', 'HOW'),
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
                              onDialogDelete(context, 'Confirmation', 'are you sure you want to delete ' + abnormality.EWODetail['ewo_number'], abnormality);
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
                              onDialogCancel(context, 'Confirmation', 'Do you want to go back to the previous page?', abnormality);
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
            ),
          ),
        ),
      );
    });
  }

  // collapse function
  Future getPhoto(context, AbnormalityProvider abnormality) async {
    await abnormality.getPhoto();
    return Future.value(false);
  }

  Widget space10(){
    return SizedBox(height: 10,);
  }
  Widget space20(){
    return SizedBox(height: 20,);
  }

  Widget DropdownSBU(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                value: abnormality.valueSbu,
                items: abnormality.masterSbu.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['sbu']),
                    value: item['sbu'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    abnormality.setValueSbu(value);
                    abnormality.setValueLine(null);
                    abnormality.setValueMachine(null);
                    abnormality.setValueUnit(null);
                    abnormality.setValueSubUnit(null);
                  });
                  abnormality.getLINE(value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownLINE(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                value: abnormality.valueLine,
                items: abnormality.masterLine.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['line']}"),
                    value: item['line'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    abnormality.setSubmissionItem('line', value);
                    abnormality.setValueLine(value);
                    abnormality.setValueMachine(null);
                    abnormality.setValueUnit(null);
                    abnormality.setValueSubUnit(null);
                  });
                  abnormality.getMACHINE(abnormality.valueSbu, value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownMACHINE(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                value: abnormality.valueMachine,
                items: abnormality.masterMachine.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['machine']}"),
                    value: item['machine'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    abnormality.setSubmissionItem('machine', value);
                    abnormality.setValueMachine(value);
                    abnormality.setValueUnit(null);
                    abnormality.setValueSubUnit(null);
                  });
                  abnormality.getUNIT(abnormality.valueSbu, abnormality.valueLine, value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownUNIT(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                value: abnormality.valueUnit,
                items: abnormality.masterUnit.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['unit']}"),
                    value: item['unit'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    abnormality.setSubmissionItem('equipment', value);
                    abnormality.setValueUnit(value);
                    abnormality.setValueSubUnit(null);
                  });
                  abnormality.getSUB_UNIT(abnormality.valueSbu, abnormality.valueLine, abnormality.valueMachine, value);
                },
              ),
            ),
          ],
        ));
  }

  Widget DropdownSUB_UNIT(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                value: abnormality.valueSubUnit,
                items: abnormality.masterSubUnit.map((item) {
                  return DropdownMenuItem(
                    child: Text("${item['sub_equipment']}"),
                    value: item['sub_equipment'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    abnormality.setSubmissionItem('sub_unit', value);
                    abnormality.setValueSubUnit(value);
                  });
                },
              ),
            ),
          ],
        ));
  }

  Widget RadioButtonPROBLEM_TYPE(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                abnormality.setValueKerusakan(selected);
                abnormality.setSubmissionItem('type_problem', selected);
              }),
          labels: <String>[
            "ELECTRIC",
            "MECHANIC",
          ],
          picked: abnormality.valueKerusakan,
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

  Widget RadioButtonACTIVITY_TYPE(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                  abnormality.setValuePerbaikan(selected);
                  abnormality.setSubmissionItem('type_activity', selected);
                }),
            labels: <String>[
              "STOP",
              "RUNNING",
            ],
            picked: abnormality.valuePerbaikan,
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

  Widget TextBoxDescription(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                controller: abnormality.problemDescription,
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
                  abnormality.setSubmissionItem('problem_description', val);
                },
              ),
            )
          ],
        ));
  }

  Widget DropdownEWO_RELATED_TO(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                value: abnormality.valueActivity,
                items: abnormality.masterActivity.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['activity_type'] +
                        ' - ' +
                        item['pmat_description']),
                    value: item['id'],
                  );
                }).toList(),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    abnormality.setValueActivity(value);
                  });
                  abnormality.getPILLAR(value);
                },
              ),
            ),
          ],
        ));
  }

  Widget TextBoxPillar(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle){
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
                  abnormality.setSubmissionItem('related_to', abnormality.valuePillarPIC);
                },
                readOnly: true,
                decoration: InputDecoration(
                    hintText: abnormality.valuePillarPIC == null
                        ? ' - '
                        : abnormality.valuePillarPIC.toString(),
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

  Widget TextBoxQuestion(BuildContext context, DigiPMProvider digiPM, AbnormalityProvider abnormality, String tittle, String keywordAsk){
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
                controller: abnormality.setQuestionSubmission(keywordAsk),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(18, 37, 63, 1.0), width: 1.0),
                    ),
                    hintText: "Enter your text here"),
                onChanged: (val){
                  abnormality.setSubmissionItem(keywordAsk, val, 'question');
                },
              ),
            )
          ],
        ));
  }

  onValidateForm(BuildContext context, AbnormalityProvider abnormality) {
    if(abnormality.submissionProperty['sbu'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select SBU");
      return null;
    }
    if(abnormality.submissionProperty['line'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select LINE");
      return null;
    }
    if(abnormality.submissionProperty['machine'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select Machine");
      return null;
    }
    if(abnormality.submissionProperty['equipment'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select Unit");
      return null;
    }
    if(abnormality.submissionProperty['sub_unit'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select Sub Unit");
      return null;
    }
    if(abnormality.submissionProperty['type_problem'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select Type Problem");
      return null;
    }
    if(abnormality.submissionProperty['type_activity'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select type activity");
      return null;
    }
    // if(abnormality.submissionProperty['photo_submission'][0]['img_path'] == null){
    //   Util.alert(
    //       context,
    //       "Validation Error",
    //       "Please Upload Photo ");
    //   return null;
    // }
    if(abnormality.submissionProperty['problem_description'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill problem description");
      return null;
    }
    if(abnormality.submissionProperty['pm_activity_type'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Select pm activity type");
      return null;
    }
    if(abnormality.submissionProperty['question']['WHAT'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Column of What");
      return null;
    }
    if(abnormality.submissionProperty['question']['WHO'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Column of Who");
      return null;
    }
    if(abnormality.submissionProperty['question']['WHERE'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Column of Where");
      return null;
    }
    if(abnormality.submissionProperty['question']['WHEN'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Column of When");
      return null;
    }
    if(abnormality.submissionProperty['question']['WHY'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Column of Why");
      return null;
    }
    if(abnormality.submissionProperty['question']['HOW'] == ''){
      Util.alert(
          context,
          "Validation Error",
          "Please Fill Column of How");
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
    abnormality.setGenerateEWO('SKIN-${abnormality.valueSbu}-03-${abnormality.valueLine}-${abnormality.valueAutoNumber}'.toUpperCase());
    // Util.loader(context, "", "Saving...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {
      'photo' : abnormality.submissionProperty['photo_submission'],
      'payload' : {
        'id' : abnormality.EWODetail['id'],
        'pm_type' : abnormality.submissionProperty['pm_type'],
        'ewo_number' : abnormality.submissionProperty['ewo_number'],
        'sbu' : abnormality.submissionProperty['sbu'],
        'line' : abnormality.submissionProperty['line'],
        'machine' : abnormality.submissionProperty['machine'],
        'equipment' : abnormality.submissionProperty['equipment'],
        'sub_unit' : abnormality.submissionProperty['sub_unit'],

        'type_problem' : abnormality.submissionProperty['type_problem'],
        'type_activity' : abnormality.submissionProperty['type_activity'],
        'problem_description' : abnormality.submissionProperty['problem_description'],
        'pm_activity_type' : abnormality.submissionProperty['pm_activity_type'],

        'related_to': abnormality.submissionProperty['related_to'],

        'created_by' : prefs.getString('id_user'),
        'question' : abnormality.submissionProperty['question']
      }
    };

    print(data);


    try {
      abnormality.saveFormAbnormality(data).then((val) async {
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
          await Util.alert(context, "Success", "You have saved the Abnormality Form", 'submissionPM03');
          clearFormData(abnormality);

          // await Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) {
          //       return new AbnormalityTab();
          //     }), (Route<dynamic> route) => false);

        }

      });
    } catch (e){
      Util.alert(context, "error", "Internal error occured. Please contact developer").then((value) async {
        clearFormData(abnormality);
        Navigator.pop(context);
      });
    }
  }

  clearFormData(AbnormalityProvider abnormality) {
    abnormality.setSubmissionItem('ewo_number', null);
    abnormality.setValueSbu(null);
    abnormality.setValueLine(null);
    abnormality.setValueMachine(null);
    abnormality.setValueUnit(null);
    abnormality.setValueSubUnit(null);
    abnormality.setValueKerusakan(null);
    abnormality.setValuePerbaikan(null);

    abnormality.setDataLINE([]);
    abnormality.setDataMACHINE([]);
    abnormality.setDataUNIT([]);
    abnormality.setDataSUB_UNIT([]);

    abnormality.setValueActivity(null);
    abnormality.setDataPILLAR_PIC(null);
    abnormality.setDataPMAT_DESCRIPTION(null);

    abnormality.setDataProblemDescription('');

    abnormality.setSubmissionItem('photo_submission', [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ]);

    abnormality.setSubmissionItem('photo', []);
    abnormality.setSubmissionItem('photo_submission_counter', 0);
    abnormality.setDataAnswerWhat('');
    abnormality.setDataAnswerWho('');
    abnormality.setDataAnswerWhere('');
    abnormality.setDataAnswerWhen('');
    abnormality.setDataAnswerWhy('');
    abnormality.setDataAnswerHow('');
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
                  clearFormData(abnormality);
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
                  deketeForm(context, abnormality);
                }
            ),
          ],
        );
      },
    );
  }

  deketeForm(BuildContext context, AbnormalityProvider abnormality){
    print('ID NYA');
    print(abnormality.EWODetail['id']);
    abnormality.deleteFormAbnormality(abnormality.EWODetail['id']).then((val) async {
      if(val['code_status'] == 1) {
        Navigator.of(context);
        Navigator.of(context);
        await Util.alert(context, "Success", "You have deleted the Abnormality Form", 'submissionPM03');
        clearFormData(abnormality);
      }
    });
  }

}
