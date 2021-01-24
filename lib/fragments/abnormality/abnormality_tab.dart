import 'package:digi_pm_skin/fragments/abnormality/abnormality_home.dart';
import 'package:digi_pm_skin/fragments/test.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/api/webservice.dart';

import 'package:digi_pm_skin/fragments/abnormality/tab_submitted.dart' as submitted;
import 'package:digi_pm_skin/fragments/abnormality/tab_approved.dart' as approved;
import 'package:digi_pm_skin/fragments/abnormality/tab_creation.dart' as creation;
import 'package:digi_pm_skin/fragments/abnormality/tab_execution.dart' as execution;
import 'package:digi_pm_skin/fragments/abnormality/tab_closed.dart' as closed;
import 'package:digi_pm_skin/util/util.dart';
import 'package:digi_pm_skin/pages/Home.dart';

class AbnormalityTab extends StatefulWidget {
  @override
  _AbnormalityTabState createState() => _AbnormalityTabState();
}

class _AbnormalityTabState extends State<AbnormalityTab> with SingleTickerProviderStateMixin {
  TabController controller;

  List _dataEwo;

  @override
  void initState() {
    getEwo();
    _dataEwo;
    controller = new TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getEwo() async {
    var listDataLine = await Api.getEwoList();
    setState(() {
      _dataEwo = listDataLine;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return WillPopScope(
        onWillPop: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AbnormalityHome() )),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Abnormality Submission'),
            bottom: TabBar(
              isScrollable: true,
              controller: controller,
              tabs: [
                new Tab(
                  icon: new Icon(Icons.save, color: Colors.blue,),
                  text: "Submitted",
                ),
                new Tab(
                  icon: new Icon(Icons.playlist_add_check, color: Colors.lightGreen,),
                  text: "Approved",
                  // child: Text('2'),
                ),
                new Tab(
                  icon: new Icon(Icons.create, color: Colors.limeAccent,),
                  text: "WO Creation",
                  // child: Text('3'),
                ),
                new Tab(
                  icon: new Icon(Icons.build, color: Colors.orangeAccent,),
                  text: "Execution",
                  // child: Text('4'),
                ),
                new Tab(
                  icon: new Icon(Icons.blur_circular, color: Colors.brown,),
                  text: "Closed",
                  // child: Text('5'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: <Widget>[
              new submitted.TabSubmitted(),
              new approved.TabApproved(),
              new creation.TabCreation(),
              new execution.TabExcecution(),
              new closed.TabClosed()
            ],
          ),
        ),
      );
    });
  }

}
