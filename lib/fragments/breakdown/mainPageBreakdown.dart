import 'package:digi_pm_skin/fragments/breakdown/list_action.dart';
import 'package:digi_pm_skin/fragments/breakdown/list_justification.dart';
import 'package:digi_pm_skin/fragments/breakdown/list_picking_sparepart.dart';
import 'package:digi_pm_skin/fragments/breakdown/list_wo.dart';
import 'package:digi_pm_skin/fragments/breakdown/tab_technician_call_off.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';
import 'tab_submission.dart';

class MainPageBreakdown extends StatefulWidget {
  @override
  _MainPageBreakdownState createState() => _MainPageBreakdownState();
}

class _MainPageBreakdownState extends State<MainPageBreakdown> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height/1.8;

    return Consumer2<DigiPMProvider, BreakdownProvider>(
        builder: (context, digiPM, breakdown, __) {
          return StatefulWrapper(
              onInit: () async {
                await breakdown.getEWO(context, 'PM02');
                await breakdown.getSBU();
                await breakdown.getACTIVITY();
              },
              child: Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(8),
                  child: GridView.builder(
                    itemCount: breakdown.namaMenu.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: width / height ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                          elevation: 2,
                          color: breakdown.colorsCard[index],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20,),
                              Image.asset(breakdown.urlImages[index], height: 50, width: 50,),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  child: Text(breakdown.namaMenu[index], textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white),)),
                            ],
                          ),
                        ),
                        onTap: (){
                          switch (breakdown.namaMenu[index]) {
                            case 'EWO Breakdown':
                              return goToMenu(breakdown, context, BreakdownTab(tittle: breakdown.namaMenu[index],));
                            case 'Technician Call Off':
                              return goToMenu(breakdown, context, TechnicianCallOff(tittle: breakdown.namaMenu[index],));
                            case 'Sparepart Picklist By EWO Number':
                              return goToMenu(breakdown, context, PickingListSparepart(tittle: breakdown.namaMenu[index],));
                            case 'EWO Breakdown Action':
                              return goToMenu(breakdown, context, BreakdownListAction(tittle: breakdown.namaMenu[index],));
                            case 'EWO Justification Root Cause':
                              return goToMenu(breakdown, context, JustificationList(tittle: breakdown.namaMenu[index],));
                            case 'Work Order Approval & Creation':
                              return goToMenu(breakdown, context, ListWO(tittle: breakdown.namaMenu[index],));
                            default:
                              return null;
                          }
                        },
                      );
                    },
                  ),
                ),
              ));
        });
  }

  goToMenu(BreakdownProvider breakdown, context, menu) {
    Navigator.push(context, MaterialPageRoute( builder: (context) => menu));
  }

}
