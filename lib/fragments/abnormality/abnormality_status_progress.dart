import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/fragments/abnormality/timeline.dart';

class StatusProgress extends StatefulWidget {
   String ewoId;

   StatusProgress({Key key, @required this.ewoId}) : super(key: key);

  @override
  _StatusProgressState createState() => _StatusProgressState(ewoId);
}

class _StatusProgressState extends State<StatusProgress>
    with TickerProviderStateMixin {

  String ewoId;
  _StatusProgressState(this. ewoId);  //constructor

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Status Progress'),
        ),
        body: Timeline(
          children: <Widget>[
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Submission Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                      Text('14 Desember 2020', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                      Text('Time : ', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                      Text('Operator ', style: TextStyle(fontSize: 12),),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.red, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Team Leader Approval Team', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                      Text('14 Desember 2020', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                      Text('Time : ', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                      Text('Team Leader B : ', style: TextStyle(fontSize: 12),),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Severity Level Justification by Pillar Leader', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Expert Analysis Start Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Expert Root Cause Justification', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Technician Sparepart Picking Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Technician Start Execution with sparepart', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Technician Finish Execution with sparepart', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 90, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Technician Start Execution without sparepart', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
            Container(height: 100, color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Technician Finish Execution without sparepart', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Date :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Username :', style: TextStyle(fontSize: 12),),
                      SizedBox(width: 5,),
                    ],
                  )
                ],
              ),
            ),),
          ],
          indicators: <Widget>[
            Icon(Icons.subdirectory_arrow_right),
            Icon(Icons.check_circle, color: Colors.red,),
            Icon(Icons.adjust),
            Icon(Icons.play_arrow),
            Icon(Icons.format_align_justify),
            Icon(Icons.compare),
            Icon(Icons.slideshow),
            Icon(Icons.access_alarm),
            Icon(Icons.access_alarm),
            Icon(Icons.access_alarm),
          ],
        ),
      );
    });
  }
}
