import 'dart:async';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'dart:developer' as dev;

class ExecutionActionCorrective extends StatelessWidget {
  final btnColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    dev.log('time rendered');
    return Consumer2<DigiPMProvider, BreakdownProvider>
      (builder: (context, digiPM, breakdown, _){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            setExeTimer(breakdown),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            MaterialButton(
              onPressed: (){
                if(breakdown.executionCorrectiveProperty['hasExecuted']){
                  return;
                }

                if(!breakdown.executionCorrectiveProperty['isStarting']){
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Do you want to start execution?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('YES'),
                            onPressed: (){
                              breakdown.setExecutionCorrectivePropertyItem('secondExeCount', 0);
                              breakdown.setExecutionCorrectivePropertyItem('startExe', DateTime.now());
                              breakdown.setExecutionCorrectivePropertyItem('secondExeCount', breakdown.executionCorrectiveProperty['secondExeCount'] + 1);
                              breakdown.setExecutionCorrectivePropertyItem('counterSecond', 0);
                              breakdown.setExecutionCorrectivePropertyItem('isStarting', true);
                              breakdown.setExecutionCorrectivePropertyItem('txtButton', 'Done Execution');
                              breakdown.setExecutionCorrectivePropertyItem('exec_date', DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()));

                              Navigator.pop(context);

                              Timer.periodic(Duration(seconds: 1), (timer) {
                                if(!breakdown.executionCorrectiveProperty['hasExecuted']){
                                  var now = DateTime.now();
                                  var remaining = now.difference(breakdown.executionCorrectiveProperty['startExe']);
                                  breakdown.setExecutionCorrectivePropertyItem('secondExeCount', breakdown.executionCorrectiveProperty['secondExeCount'] + 1);
                                  breakdown.setExecutionCorrectivePropertyItem('bannerExe', formatDuration(remaining));
                                  dev.log(breakdown.executionCorrectiveProperty['secondExeCount'].toString());

                                } else {
                                  timer.cancel();
                                }

                              });
                            },
                          ),

                          FlatButton(
                            child: Text('NO'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )

                        ],
                      );
                    },
                  );
                } else {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Do you want to finish execution?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('YES'),
                              onPressed: (){
                                breakdown.setExecutionCorrectivePropertyItem('startExe', null);
                                breakdown.setExecutionCorrectivePropertyItem('secondExeCount', breakdown.executionCorrectiveProperty['secondExeCount'] + 1);
                                breakdown.setExecutionCorrectivePropertyItem('counterSecond', breakdown.executionCorrectiveProperty['secondExeCount']);
                                breakdown.setExecutionCorrectivePropertyItem('isStarting', false);
                                breakdown.setExecutionCorrectivePropertyItem('hasExecuted', true);
                                breakdown.setExecutionCorrectivePropertyItem('btnColor', Colors.grey);
                                breakdown.setExecutionCorrectivePropertyItem('txtButton', 'Executed');
                                breakdown.setExecutionCorrectivePropertyItem('finish_date', DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()));

                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text('NO'),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      }
                  );
                }
              },
              child: Text(breakdown.executionCorrectiveProperty['txtButton']),
              padding: EdgeInsets.only(right: 30, left: 30, top: 15, bottom: 15),
              color: determineButtonColor(breakdown, context),
              textColor: Colors.white,
            )
          ],
        ),
      );
    });
  }

  String formatDuration(Duration d) {
    String f(int n){
      return n.toString().padLeft(2, '0');
    }

    d += Duration(microseconds: 999999);
    return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
  }

  Widget setExeTimer(BreakdownProvider breakdown){
    if(breakdown.executionCorrectiveProperty['secondExeCount'] > 0){
      return bannerText(breakdown.executionCorrectiveProperty['bannerExe']);
    }

    if(breakdown.executionCorrectiveProperty['startExe'] == null) {
      return bannerText("00:00");
    }

    return bannerText("00:00");
  }

  Widget bannerText(text){
    return Text('$text', style: TextStyle(fontSize: 90),);
  }

  Color determineButtonColor(BreakdownProvider breakdown, context){
    if (breakdown.executionCorrectiveProperty['hasExecuted']){
      return Colors.grey;
    }

    if(breakdown.executionCorrectiveProperty['isStarting']){
      return btnColor;
    } else {
      return Theme.of(context).accentColor;
    }
  }

}