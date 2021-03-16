import 'dart:convert';

import 'package:digi_pm_skin/fragments/breakdown/form_exe_corrective.dart';
import 'package:digi_pm_skin/fragments/breakdown/summary_breakdown.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ExecutionCorrective extends StatefulWidget {
  Map<String, dynamic> data;

  ExecutionCorrective({Key key, @required this.data}) : super(key: key);

  @override
  _ExecutionCorrectiveState createState() => _ExecutionCorrectiveState(data);
}

class _ExecutionCorrectiveState extends State<ExecutionCorrective> {
  Map<String, dynamic> data;

  _ExecutionCorrectiveState(this.data);

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, BreakdownProvider>(
      builder: (context, digiPM, breakdown, _){
        return WillPopScope(
          onWillPop: _onWillPop,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Corrective Action'),
                bottom: TabBar(tabs: breakdown.tabExeCorrective,),
              ),
              body: TabBarView(
                children: <Widget>[
                  FormCorrectiveAction(ewoId: widget.data['id']),
                  SummaryBreakdown(data: widget.data,)
                ],
              ),
              floatingActionButton: setFloatingButton(digiPM, breakdown, context),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop(){
    var isStarting = true;

    if(isStarting == false) {
      Navigator.of(context).pop(false);
    } else {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('You are in Execution Mode'),
          content: new Text('Do you want to exit Execution mode?'),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
            ),
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes')
            )
          ],
        ),
      ) ?? false;
    }
    return Future.value(false);
  }

  Widget setFloatingButton(DigiPMProvider digiPM, BreakdownProvider breakdown, BuildContext context){
    if(breakdown.displayFloatingButtonCamera) {
      return FloatingActionButton(
        onPressed: () {
          getImage(context, digiPM, breakdown);
        },
      );
    }
  }

  Future getImage(context, DigiPMProvider digiPM, BreakdownProvider breakdown) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<dynamic> photo = digiPM.executionProperty['photo'];
    photo.add({'img_path' : image.path, 'img' : image});
    breakdown.setExecutionCorrectivePropertyItem("photo_evidence", photo);
  }

}
