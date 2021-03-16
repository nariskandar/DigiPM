import 'package:digi_pm_skin/fragments/abnormality/creation.dart';
import 'package:digi_pm_skin/fragments/abnormality/justification.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_tab.dart';
import 'package:digi_pm_skin/fragments/abnormality/severity.dart';
import 'package:digi_pm_skin/fragments/abnormality/analysis.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:provider/provider.dart';

class AbnormalityHome extends StatefulWidget {
  @override
  _AbnormalityHomeState createState() => _AbnormalityHomeState();
}

class _AbnormalityHomeState extends State<AbnormalityHome> {


  List<String> events = [
    "EWO Severity Ratings",
    "Abnormality Submissions",
    "EWO Root Cause Justification",
    "EWO Analysis",
    "WO Creation"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality,__) {
     return Scaffold(
       body: Container(
         decoration: BoxDecoration(
           image: DecorationImage(
               image: AssetImage("assets/images/background3.png"),
               fit: BoxFit.cover),
         ),
         child: Container(
           margin: const EdgeInsets.only(top: 10.0),
           child: Directionality(
             textDirection: TextDirection.rtl,
             child: GridView(
               physics: BouncingScrollPhysics(),
               gridDelegate:
               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
               children: events.map((title) {
                 return GestureDetector(
                   child: Card(
                     elevation: 10,
                     margin: const EdgeInsets.all(20.0),
                     color: (title == "EWO Severity Ratings")
                         ? Color.fromRGBO(245, 170, 66, 0.8)
                         : (title == "Abnormality Submissions")
                         ? Color.fromRGBO(255, 8, 8, 0.8)
                         : (title == "EWO Analysis")
                         ? Color.fromRGBO(156, 154, 152, 0.8)
                         : (title == "EWO Root Cause Justification")
                         ? Color.fromRGBO(156, 22, 152, 0.8)
                         : (title == "EWO Root Cause Justification")
                         ? Color.fromRGBO(126, 149, 252, 0.8)
                         : Color.fromRGBO(115, 230, 144, 0.8),
                     child: getCardByTitle(title),
                   ),
                   onTap: () {
                     if (title == "Abnormality Submissions") {
                       Navigator.push(context,
                           MaterialPageRoute(builder: (context) => AbnormalityTab()));
                     } else if (title == "EWO Severity Ratings") {
                       Navigator.push(context,
                           MaterialPageRoute(builder: (context) => Severity()));
                     } else if (title == "EWO Analysis") {
                       Navigator.push(context,
                           MaterialPageRoute(builder: (context) => Analysis()));
                     } else if (title == "EWO Root Cause Justification") {
                       Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => Justification()));
                     } else {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Creation()));
                     }
                   },
                 );
               }).toList(),
             ),
           ),
         ),
       ),
     );
    });
  }

  Column getCardByTitle(String title) {
    String img = "";
    if (title == "Abnormality Submissions")
      img = "assets/icon/submit.png";
    else if (title == "EWO Severity Ratings")
      img = "assets/icon/rate.png";
    else if (title == "EWO Analysis")
      img = "assets/icon/infographic.png";
    else if (title == "EWO Root Cause Justification")
      img = "assets/icon/justification.png";
    else if (title == "WO Creation") img = "assets/icon/create.png";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.all(20),
            child: new Stack(
              children: <Widget>[
                new Image.asset(
                  img,
                  width: 50.0,
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
