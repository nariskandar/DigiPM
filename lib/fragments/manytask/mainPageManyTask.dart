import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/provider/breakdownProvider.dart';

class MainPageManyTask extends StatefulWidget {
  @override
  _MainPageManyTaskState createState() => _MainPageManyTaskState();
}

class _MainPageManyTaskState extends State<MainPageManyTask> {

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
      builder: (context, digiPM, breakdown, _){
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
                  itemCount: digiPM.namaMenu.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: width / height
                  ),
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      child: Card(
                        elevation: 5,
                        color: digiPM.colorCard[index],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget> [
                            SizedBox(height: 20,),
                            Image.asset(digiPM.urlImages[index], height: 50, width: 50,),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: Text(digiPM.namaMenu[index], textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white),)),
                          ],
                        ),
                      ),
                      onTap: (){
                        switch (digiPM.namaMenu[index]){
                          case 'Sparepart Picklist By EWO Number' :
                            return print('1');
                          case 'Abnormality PM03 Tasklist' :
                            return print('2');
                          case 'Breakdown PM02 Tasklist' :
                            return print('3');
                          case 'Tasklist Validation' :
                            return print('4');
                            default:
                              return null;
                        }
                      },
                    );
                  }
              ),
            ),
          ),
        );
      }
    );
  }
    goToMenu(DigiPMProvider digiPM, context, menu) {
      Navigator.push(context, MaterialPageRoute( builder: (context) => menu));
    }
}
