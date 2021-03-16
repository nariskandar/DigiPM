import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatefulWidget {
  String ewoId;
  String pm_type;

  Timeline({Key key, @required this.ewoId, this.pm_type}) : super(key: key);
  @override
  _TimelineState createState() => _TimelineState(ewoId, pm_type);
}

class _TimelineState extends State<Timeline>{
  String ewoId;
  String pm_type;

  _TimelineState(this.ewoId, this.pm_type);


  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM , __){
      return StatefulWrapper(
        onInit: ()async{
          await digiPM.getTimeline(widget.ewoId, widget.pm_type);
        }, child: Scaffold(
        appBar: AppBar(title: Text('Historical Submission'),),
        body: buildTimeline(digiPM, context),
      ),
      );
    },);
  }

}

Widget buildTimeline(DigiPMProvider digiPM, context){
  if(digiPM.isLoading){
    return Center(child: CircularProgressIndicator(),);
  } else {
    if(digiPM.dataTimeline == null || digiPM.EWONumber == null){
      return Center(child: CircularProgressIndicator(),);
    } else {
      return Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border(
                bottom: BorderSide(
                  color: Colors.red,
                  width: 3,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'EWO NUMBER :',
                          style: TextStyle(
                            color: Color.fromRGBO(18, 37, 63, 1.0),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          digiPM.EWONumber.toString(),
                          style: TextStyle(
                            color: Color.fromRGBO(18, 37, 63, 1.0),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: digiPM.dataTimeline?.length ?? 0,
                  itemBuilder: (context, index){
                    return TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      isFirst: true,
                      indicatorStyle: const IndicatorStyle(
                        width: 25,
                        color: Color.fromRGBO(18, 37, 63, 1.0),
                        padding: EdgeInsets.all(6),
                      ),
                      endChild: _RightChild(
                        asset: 'assets/icon/zara-maintenance2.png',
                        title: digiPM.dataTimeline[index],
                        date: digiPM.dataTimeline[index],
                        user: digiPM.dataTimeline[index],
                      ),
                      beforeLineStyle: const LineStyle(
                        thickness: 6,
                        color: Color.fromRGBO(18, 37, 63, 1.0),
                      ),
                    );
                  }),
            ),
          )
        ],
      );
    }
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    this.asset,
    this.title,
    this.date,
    this.user,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final dynamic title;
  final dynamic date;
  final dynamic user;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title['step_name'],
                style: TextStyle(
                  color: disabled
                      ?  Color(0xFFBABABA)
                      :  Color(0xFF636564),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text(
                    'Date : ' ,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: disabled
                          ? const Color(0xFFD5D5D5)
                          : const Color(0xFF636564),
                      fontSize: 12,
                    ),
                  ),
                  Text(date['created_at'] == null ? ' - ' : date['created_at'],
                    style: TextStyle(
                      color: disabled
                          ? const Color(0xFFD5D5D5)
                          : const Color(0xFF636564),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text(
                    'Username : ' ,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: disabled
                          ? const Color(0xFFD5D5D5)
                          : const Color(0xFF636564),
                      fontSize: 12,
                    ),
                  ),
                  Text(user['employee_name'] == null ? ' - ' : user['employee_name'],
                    style: TextStyle(
                      color: disabled
                          ? const Color(0xFFD5D5D5)
                          : const Color(0xFF636564),
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);