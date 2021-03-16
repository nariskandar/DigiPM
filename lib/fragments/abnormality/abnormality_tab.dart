import 'package:digi_pm_skin/fragments/abnormality/submittedAbnormality.dart' as submitted;
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:provider/provider.dart';

import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/fragments/abnormality/approvedAbnormality.dart' as approved;
import 'package:digi_pm_skin/fragments/abnormality/creationAbnormality.dart' as creation;
import 'package:digi_pm_skin/fragments/abnormality/tab_execution.dart' as execution;
import 'package:digi_pm_skin/fragments/abnormality/tab_closed.dart' as closed;


class AbnormalityTab extends StatefulWidget {

  @override
  _AbnormalityTabState createState() => _AbnormalityTabState();
}

class _AbnormalityTabState extends State<AbnormalityTab> with SingleTickerProviderStateMixin {
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
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return WillPopScope(
        onWillPop: () => Future.value(true),
        child: StatefulWrapper(
          onInit: () async {
            await abnormality.getEWO(context, 'PM03');
            // await abnormality.getSBU();
            // await abnormality.getACTIVITY();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Abnormality Submission'),
              bottom: TabBar(
                isScrollable: true,
                controller: controller,
                tabs: [
                  new Tab(
                    icon: new Icon(Icons.save, color: Colors.blue,),
                    text: "${abnormality.dataSubmitted.length} Submitted",
                  ),
                  new Tab(
                    icon: new Icon(Icons.playlist_add_check, color: Colors.lightGreen,),
                    text: "${abnormality.dataApproved.length} Approved",
                  ),
                  new Tab(
                    icon: new Icon(Icons.create, color: Colors.limeAccent,),
                    text: "${abnormality.dataWOCreation.length} WO Creation",
                  ),
                  new Tab(
                    icon: new Icon(Icons.build, color: Colors.orangeAccent,),
                    text: "0 Execution",
                  ),
                  new Tab(
                    icon: new Icon(Icons.blur_circular, color: Colors.brown,),
                    text: "0 Closed",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: controller,
              children: <Widget>[
                submitted.Submitted(),
                approved.Approved(),
                creation.Creation(),
                execution.TabExcecution(),
                closed.TabClosed()
              ],
            ),
          ),
        ),
      );
    });
  }

}
