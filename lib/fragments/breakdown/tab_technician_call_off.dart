import 'package:flutter/material.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';

// url
import 'package:digi_pm_skin/fragments/breakdown/list_submisson.dart' as submitted;
import 'package:digi_pm_skin/fragments/breakdown/list_nonreceived.dart' as nonreceived;
import 'package:digi_pm_skin/fragments/breakdown/list_received.dart' as received;
import 'package:digi_pm_skin/fragments/breakdown/list_received.dart';

class TechnicianCallOff extends StatefulWidget {
  String tittle;

  TechnicianCallOff({Key key, @required this.tittle}) : super(key: key);
  @override
  _TechnicianCallOffState createState() => _TechnicianCallOffState();
}

class _TechnicianCallOffState extends State<TechnicianCallOff> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 2, vsync: this);
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
          onInit: ()  {},
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.tittle.toString()),
              bottom: TabBar(
                isScrollable: false,
                controller: controller,
                tabs: [
                  new Tab(
                    icon: new Icon(Icons.check_box_outline_blank, color: Colors.blue,),
                    text: "${breakdown.dataNonReceived.length} Non Received",
                  ),
                  new Tab(
                    icon: new Icon(Icons.check_box, color: Colors.lightGreen,),
                    text: "${breakdown.dataReceived.length} Received",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: controller,
              children: <Widget>[
                new nonreceived.NonReceived(),
                new received.Received(),
              ],
            ),
          ),
        ),
      );
    });
  }

  void dataRefresher(BreakdownProvider breakdown) async {
    breakdown.setLoadingState(true);
    await breakdown.getEWO(context, 'PM02');
    breakdown.setLoadingState(false);
  }

}
