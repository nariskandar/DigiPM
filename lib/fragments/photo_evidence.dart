import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoEvidence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(
        builder: (context, digiPM, __) {
          if (digiPM.executionProperty['photo_evidence'].length == 0) {
            return Container(
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("No Photo Evidence"),
                    ],
                  )),
            );
          } else {
            return new ListView.builder(
                itemCount: digiPM.executionProperty['photo_evidence'].length,
                itemBuilder: (context, int) {
                  return Container(
                      height: 500,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                      height: 500,
                                      child: Image.file(
                                          digiPM
                                              .executionProperty['photo_evidence']
                                          [int]['img'])))
                            ],
                          ),
                        ],
                      ));
                });
          }
        });
  }
}
