import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtifListLineManager extends StatefulWidget {
  @override
  _OtifListLineManagerState createState() => _OtifListLineManagerState();
}

class _OtifListLineManagerState extends State<OtifListLineManager> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      SharedPreferences.getInstance().then((prefs) {
        Api.getSpvOtif(prefs.getString("id_user"), digiPM.selectedWeek)
            .then((val) {
          //debugPrint(val.toString());
          digiPM.setOtifListLineManager(val);
          digiPM.setLoadingState(false);
        });
      });

      if (digiPM.isLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        if (digiPM.otifListManager == null ||
            digiPM.otifListManager.length == 0) {
          return Center(
              child: Text("No Otif Report for Week " + digiPM.selectedWeek,
                  style: TextStyle(fontSize: 14, color: Colors.grey)));
        } else {
          return generateOtifList(width, digiPM);
        }
      }
    });
  }

  Widget generateOtifList(width, DigiPMProvider digiPM) {
    return Container(
      color: Colors.blueGrey,
      child: new ListView.builder(
        itemCount: digiPM.otifListManager.length,
        itemBuilder: (context, int) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Card(
                child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              child: Icon(
                                Icons.assignment,
                                size: width < 480 ? 30 : 50,
                                color: Colors.orange,
                              ),
                              alignment: Alignment.centerLeft),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                          "Week : " +
                                              digiPM.otifListManager[int]
                                                  ['week'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "Supervisor : " +
                                          digiPM.otifListManager[int]
                                              ['employee_name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "OTIF : " +
                                          digiPM.otifListManager[int]['otif'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "Pending : " +
                                          digiPM.otifListManager[int]
                                              ['pending'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      )),
                                )
                              ],
                            ),
                          ),
                          flex: width > 960 ? 13 : 8,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    determineRating(digiPM.otifListManager[int], digiPM)
                  ],
                ),
              ),
            )),
          );
        },
      ),
    );
  }

  Widget determineRating(otifListManager, DigiPMProvider digiPM) {
    if (otifListManager['week_rating'] == null) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  FlatButton.icon(
                    color: Colors.green,
                    textColor: Colors.white,
                    icon: Icon(Icons.star),
                    label: Text('Rate'),
                    onPressed: () {
                      setRating(otifListManager, digiPM);
                    },
                  )
                ],
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(""),
            flex: 3,
          )
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Text("Rating : "),
          RatingBar(
            initialRating: double.parse(otifListManager['rating']),
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemSize: 20,
            ignoreGestures: true,
            itemCount: 5,
            tapOnlyMode: true,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          )
        ],
      );
    }
  }

  void setRating(otif, DigiPMProvider digiPM) {
    showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Supervisor Rating'),
            content: RatingBar(
              initialRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                otif['rating'] = rating.toString();
                //debugPrint("---x-x-x----x");
                //debugPrint(otif.toString());
              },
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Cancel'),
              ),
              new FlatButton(
                onPressed: () => saveRate(otif, digiPM),
                child: new Text('Set Rating'),
              ),
            ],
          ),
        ) ??
        false;
  }

  saveRate(otif, DigiPMProvider digiPM) async {
    var val = await Api.saveSupervisorRating(otif);
    //debugPrint(val.toString());
    digiPM.setLoadingState(true);
    if (val['code_status'] == 1) {
      Util.alert(context, "Success", "Rating has been saved").then((val) {
        Navigator.of(context).pop(false);
      });
    }
  }
}
