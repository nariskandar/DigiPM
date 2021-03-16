import 'package:digi_pm_skin/fragments/abnormality/summary.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreationForm extends StatefulWidget {
  Map<String, dynamic> data;

  CreationForm({Key key, @required this.data}) : super(key : key);
  @override
  _CreationFormState createState() => _CreationFormState(data);
}

class _CreationFormState extends State<CreationForm> {
  Map<String, dynamic> data;

  _CreationFormState(this.data);
  String numbLast;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String numbLastEwo = widget.data['ewo_number'];
    numbLast = numbLastEwo.substring(numbLastEwo.length - 7);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __){
      return Scaffold(
        appBar: AppBar(title: Text('Summary'),),
        body: Summary(data: widget.data,),
          floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  label: Text('REJECT'),
                  icon :  Icon(
                      Icons.clear
                  ),
                  heroTag: "reject",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    rejectedWoCreation(context);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  label: Text('APPROVED'),
                  icon: Icon(Icons.check),
                  heroTag: "approved",
                  backgroundColor: Colors.green,
                  onPressed: () {
                    saveWoCreation(context);
                  },
                )
              ]
          )
      );
    });
  }

  void saveWoCreation(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = {
      'id' : null,
      'ewoId' : widget.data['id'],
      'woNumber' : 'WO${numbLast}',
      'approve_by' : prefs.getString("id_user")
    };
    print(data);

    await Api.saveWoCreation(data).then((value) {

      if(value['status'] == 'sukses'){
        alert(context, 'Success', 'WO Number :WO${numbLast} successfully created in accordance with EWO Number ${widget.data['ewo_number']} and passed on to the website digipm, to do the process of assignment by admin');
      }

    });
  }

  void rejectedWoCreation(BuildContext context) async {

    print(widget.data);

    final data = {
      'ewoId': widget.data['id'],
      'IS_NEED_SPARE_PART' : widget.data['IS_NEED_SPARE_PART']
    };

    await Api.rejectWoCreation(data).then((value) {

      if(value['status'] == 'sukses'){
        alert(context, 'Success', 'EWO Number ${widget.data['ewo_number']} has been rejected');
      }

    });


  }

  static Future<void> alert(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content', style: TextStyle(fontSize: 13),),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }





}
