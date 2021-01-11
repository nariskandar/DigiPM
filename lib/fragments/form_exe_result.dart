import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormExeResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Execution result"),
        ),
        body: Container(
          child: Center(
            child: ListView(
              padding: EdgeInsets.all(12),
              children: <Widget>[
                Text(
                  "Status : ",
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  digiPM.selectedExeTasklist['loss_type'].toString(),
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  'Recommendation Text :',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  digiPM.selectedExeTasklist['recommendation_text'].toString(),
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  'Execution Date',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  digiPM.selectedExeTasklist['exec_date'].toString(),
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  'Execution Time',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  digiPM.selectedExeTasklist['exec_time'].toString(),
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  "Picture Before 1",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Container(
                    height: 400,
                    color: Colors.grey,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 400,
                              child:
                                  digiPM.selectedExeTasklist['pict_before'] ==
                                          null
                                      ? Text('')
                                      : Image.network(
                                          Api.BASE_URL_PIC_EXE +
                                              digiPM.selectedExeTasklist[
                                                  'pict_before'],
                                          fit: BoxFit.fitHeight),
                            ))
                          ],
                        ),
                      ],
                    )),
                Text(
                  "Picture Before 2",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Container(
                    height: 400,
                    color: Colors.grey,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 400,
                              child:
                                  digiPM.selectedExeTasklist['pict_before2'] ==
                                          null
                                      ? Text('')
                                      : Image.network(
                                          Api.BASE_URL_PIC_EXE +
                                              digiPM.selectedExeTasklist[
                                                  'pict_before2'],
                                          fit: BoxFit.fitHeight),
                            ))
                          ],
                        ),
                      ],
                    )),
                Text(
                  "Picture Before 3",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Container(
                    height: 400,
                    color: Colors.grey,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 400,
                              child:
                                  digiPM.selectedExeTasklist['pict_before3'] ==
                                          null
                                      ? Text('')
                                      : Image.network(
                                          Api.BASE_URL_PIC_EXE +
                                              digiPM.selectedExeTasklist[
                                                  'pict_before3'],
                                          fit: BoxFit.fitHeight),
                            ))
                          ],
                        ),
                      ],
                    )),
                Text(
                  "Picture After 1",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Container(
                    height: 400,
                    color: Colors.grey,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 400,
                              child: digiPM.selectedExeTasklist['pict_after'] ==
                                      null
                                  ? Text('')
                                  : Image.network(
                                      Api.BASE_URL_PIC_EXE +
                                          digiPM.selectedExeTasklist[
                                              'pict_after'],
                                      fit: BoxFit.fitHeight),
                            ))
                          ],
                        ),
                      ],
                    )),
                Text(
                  "Picture After 2",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Container(
                    height: 400,
                    color: Colors.grey,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 400,
                              child:
                                  digiPM.selectedExeTasklist['pict_after2'] ==
                                          null
                                      ? Text('')
                                      : Image.network(
                                          Api.BASE_URL_PIC_EXE +
                                              digiPM.selectedExeTasklist[
                                                  'pict_after2'],
                                          fit: BoxFit.fitHeight),
                            ))
                          ],
                        ),
                      ],
                    )),
                Text(
                  "Picture After 3",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                ),
                Container(
                    height: 400,
                    color: Colors.grey,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 400,
                              child:
                                  digiPM.selectedExeTasklist['pict_after3'] ==
                                          null
                                      ? Text('')
                                      : Image.network(
                                          Api.BASE_URL_PIC_EXE +
                                              digiPM.selectedExeTasklist[
                                                  'pict_after3'],
                                          fit: BoxFit.fitHeight),
                            ))
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
