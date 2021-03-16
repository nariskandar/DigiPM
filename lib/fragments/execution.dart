import 'dart:async';

import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

class ExecutionAction extends StatelessWidget {
  final btnColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    dev.log('time rendered');
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            setExeTimer(digiPM),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            MaterialButton(
              onPressed: () {
                if (digiPM.executionProperty['hasExecuted']) {
                  return;
                }
                if (!digiPM.executionProperty['isStarting']) {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Do you want to start execution?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('YES'),
                            onPressed: () {
                              digiPM.setExeItem('secondExeCount', 0);
                              digiPM.setExeItem('startExe', DateTime.now());
                              digiPM.setExeItem(
                                  'secondExeCount',
                                  digiPM.executionProperty['secondExeCount'] +
                                      1);
                              digiPM.setExeItem('counterSecond', 0);
                              digiPM.setExeItem('isStarting', true);
                              digiPM.setExeItem('txtButton', "Done Execution");

                              Navigator.pop(context);

                              Timer.periodic(Duration(seconds: 1), (timer) {
                                if (!digiPM.executionProperty['hasExecuted']) {
                                  var now = DateTime.now();
                                  var remaining = now.difference(
                                      digiPM.executionProperty['startExe']);
                                  digiPM.setExeItem(
                                      'secondExeCount',
                                      digiPM.executionProperty[
                                              'secondExeCount'] +
                                          1);
                                  digiPM.setExeItem(
                                      'bannerExe', formatDuration(remaining));

                                  dev.log(digiPM
                                      .executionProperty['secondExeCount']
                                      .toString());
                                } else {
                                  timer.cancel();
                                }
                              });
                            },
                          ),

                          FlatButton(
                            child: Text('NO'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                        ],
                      );
                    },
                  );
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Do you want to finish execution?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('YES'),
                            onPressed: () {
                              digiPM.setExeItem('startExe', null);
                              digiPM.setExeItem(
                                  'secondExeCount',
                                  digiPM.executionProperty['secondExeCount'] +
                                      1);
                              digiPM.setExeItem('counterSecond',
                                  digiPM.executionProperty['secondExeCount']);
                              digiPM.setExeItem('isStarting', false);
                              digiPM.setExeItem('hasExecuted', true);
                              digiPM.setExeItem('btnColor', Colors.grey);
                              digiPM.setExeItem('txtButton', "Executed");

                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('NO'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(digiPM.executionProperty['txtButton']),
              padding:
                  EdgeInsets.only(right: 30, left: 30, top: 15, bottom: 15),
              color: determineButtonColor(digiPM, context),
              textColor: Colors.white,
            ),
          ],
        ),
      );
    });
  }

  String formatDuration(Duration d) {
    String f(int n) {
      return n.toString().padLeft(2, '0');
    }

    // We want to round up the remaining time to the nearest second
    d += Duration(microseconds: 999999);
    return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
  }

  Widget setExeTimer(DigiPMProvider digiPM) {
    if (digiPM.executionProperty['secondExeCount'] > 0) {
      return bannerText(digiPM.executionProperty['bannerExe']);
    }

    if (digiPM.executionProperty['startExe'] == null) {
      return bannerText("00:00");
    }

    return bannerText("00:00");
  }

  Widget bannerText(text) {
    return Text('$text', style: TextStyle(fontSize: 90));
  }

  Color determineButtonColor(DigiPMProvider digiPM, context) {
    if (digiPM.executionProperty['hasExecuted']) {
      return Colors.grey;
    }

    if (digiPM.executionProperty['isStarting']) {
      return btnColor;
    } else {
      return Theme.of(context).accentColor;
    }
  }

}