import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:digi_pm_skin/fragments/abnormality/tab_action.dart' as action;
import 'package:digi_pm_skin/fragments/abnormality/tab_analysis.dart' as analysis;
import 'package:digi_pm_skin/fragments/abnormality/tab_saverity.dart' as saverity;
import 'package:digi_pm_skin/fragments/abnormality/tab_submitted.dart' as submitted;
import 'package:digi_pm_skin/fragments/abnormality/tab_closed.dart' as closed;

class Submissions extends StatefulWidget {
  @override
  _SubmissionsState createState() => _SubmissionsState();
}

class _SubmissionsState extends State<Submissions> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
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
              ),
              new Tab(
                icon: new Icon(Icons.spellcheck, color: Colors.limeAccent,),
                text: "Corrective",
              ),
              new Tab(
                icon: new Icon(Icons.pan_tool, color: Colors.orangeAccent,),
                text: "Preventive",
              ),
              new Tab(
                icon: new Icon(Icons.blur_circular, color: Colors.brown,),
                text: "Closed",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            new submitted.TabSubmitted(),
            new analysis.TabAnalysis(),
            new saverity.TabSaverity(),
            new action.TabAction(),
            new closed.TabClosed()
          ],
        ),
      );
    });
  }
}
