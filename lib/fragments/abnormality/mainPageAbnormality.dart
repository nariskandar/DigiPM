import 'package:digi_pm_skin/fragments/abnormality/creation.dart';
import 'package:digi_pm_skin/fragments/abnormality/justification.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/fragments/abnormality/severityAbnormality.dart';
import 'package:digi_pm_skin/fragments/abnormality/analysis.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';

class MainPageAbnormality extends StatefulWidget {
  final String caller;
  const MainPageAbnormality({Key key, this.caller}) : super(key: key);
  @override
  _MainPageAbnormalityState createState() => _MainPageAbnormalityState();
}

class _MainPageAbnormalityState extends State<MainPageAbnormality> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height/1.8;

    return Consumer2<DigiPMProvider, AbnormalityProvider>(
        builder: (context, digiPM, abnormality, __) {
      return StatefulWrapper(
          onInit: () async {
            await abnormality.getEWO(context, 'PM03');
            await abnormality.getSBU();
            await abnormality.getACTIVITY('PM03');
            await abnormality.setCurrentDate();
          },
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                itemCount: abnormality.namaMenu.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: width / height ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Card(
                      elevation: 2,
                      color: abnormality.colorsCard[index],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20,),
                          Image.asset(abnormality.urlImages[index], height: 50, width: 50,),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Text(abnormality.namaMenu[index], textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white),)),
                        ],
                      ),
                    ),
                    onTap: (){
                      switch (abnormality.namaMenu[index]) {
                        case 'Abnormality Submissions':
                          return goToMenu(abnormality, context, AbnormalityTab());
                        case 'EWO Severity Ratings':
                          return goToMenu(abnormality, context, Severity());
                        case 'EWO Root Cause Justification':
                          return goToMenu(abnormality, context, Justification());
                        case 'EWO Analysis':
                          return goToMenu(abnormality, context, Analysis());
                        case 'WO Creation':
                          return goToMenu(abnormality, context, Creation());
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

  goToMenu(AbnormalityProvider abnormality, context, menu) {
    Navigator.push(context, MaterialPageRoute( builder: (context) => menu));
  }

}
