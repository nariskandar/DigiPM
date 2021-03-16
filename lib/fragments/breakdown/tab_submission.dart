import 'package:flutter/material.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

// url
import 'package:digi_pm_skin/fragments/breakdown/list_submisson.dart' as submitted;
import 'package:digi_pm_skin/fragments/breakdown/list_approved.dart' as approved;
import 'package:digi_pm_skin/fragments/breakdown/list_correction.dart' as corrective;
import 'package:digi_pm_skin/fragments/breakdown/list_preventive.dart' as  preventive;

class BreakdownTab extends StatefulWidget {
  String tittle;
  BreakdownTab({Key key, @required this.tittle}) : super(key: key);

  @override
  _BreakdownTabState createState() => _BreakdownTabState();
}

class _BreakdownTabState extends State<BreakdownTab> with SingleTickerProviderStateMixin {
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
    return Consumer2<DigiPMProvider, BreakdownProvider>(builder: (context, digiPM, breakdown, __) {
      return WillPopScope(
        onWillPop: () => Future.value(true),
        child: StatefulWrapper(
          onInit: ()  {
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.tittle.toString()),
              bottom: TabBar(
                isScrollable: true,
                controller: controller,
                tabs: [
                  new Tab(
                    icon: new Icon(Icons.save, color: Colors.blue,),
                    text: "${breakdown.dataSubmitted.length} Submitted",
                  ),
                  new Tab(
                    icon: new Icon(Icons.playlist_add_check, color: Colors.lightGreen,),
                    text: "${breakdown.dataApproved.length} Approved",
                  ),
                  new Tab(
                    icon: new Icon(Icons.create, color: Colors.limeAccent,),
                    text: "${breakdown.dataBreakdownAction.length} Corrective",
                  ),
                  new Tab(
                    icon: new Icon(Icons.build, color: Colors.orangeAccent,),
                    text: "${breakdown.dataJustification.length} Preventive",
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
                new submitted.SubmittedBreakdown(),
                new approved.ApprovedBreakdown(),
                new corrective.ListCorrectiveBreakdown(),
                new preventive.ListPreventiveBreakdown(),
                new submitted.SubmittedBreakdown(),
              ],
            ),
          ),
        ),
      );
    });
  }

}
