import 'dart:convert';

import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/fragments/abnormality/detail_picture_screen.dart';
import 'package:digi_pm_skin/pages/Execution.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  var user_login;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      return Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: FutureBuilder(
                        future: _setEmployeeId(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data != null){
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context){
                                                  return DetailScreen(snapshot.data.toString());
                                                }
                                            ));
                                          },
                                          child: QrImage(
                                            data: snapshot.data.toString(),
                                            version: QrVersions.auto,
                                            size: 120.0,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('NIP : ', style: TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),),
                                            Text('${snapshot.data.toString()}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder(
                                          future: _setUserName(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data != null) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text("Name :", style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 20
                                                    ),),
                                                    Text(snapshot.data.toString(),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        )),
                                                  ],
                                                );
                                              } else {
                                                return Text("Loading...",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ));
                                              }
                                            } else {
                                              return Text("-");
                                            }
                                          },
                                        ),
                                        SizedBox(height: 15,),
                                        FutureBuilder(
                                          future: _setRole(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data != null) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text("Role : ",
                                                      style: TextStyle(fontWeight: FontWeight.w700,
                                                      fontSize: 20),),
                                                    Text(snapshot.data.toString(),
                                                        style: TextStyle(fontSize: 20,))
                                                  ],
                                                );
                                              } else {
                                                return Text("Loading...",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ));
                                              }
                                            } else {
                                              return Text("-");
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Center(child :CircularProgressIndicator(),);
                            }
                          } else {
                            return Text('-');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 20),
            // ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[setImage(user_login, digiPM)],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            icon: Icon(Icons.add_a_photo),
                            label: Text('Change Photo Profile'),
                            onPressed: () {
                              getImage(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<String> _setUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("employee_name");
  }

  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('employee_id');
  }

  Future<String> _setRole() async {
    var role = "-";
    var supervisor = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("is_supervisor")) {
      supervisor = "(Supervisor)";
    }

    role = prefs.getString("role_name");

    return role + " " + supervisor;
  }

  Future getImage(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = await Api.asyncFileUpload(prefs.getString("id_user"), image);
    var status = json.decode(data);

    if (status['code_status'] == 1) {
      Util.alert(context, "berhasil", "oke").then((vsl) {
        setState(() {
          reloadUser();
        });
      });
    }
  }

  Widget setImage(userLogin, DigiPMProvider digiPM) {
    if (userLogin == null) {
      return Container(
          width: 200.0,
          height: 200.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/icon/zara-maintenance2.png'),
              )));
    } else {
      if (userLogin['pic_path'] != null) {
        SharedPreferences.getInstance().then((prefs) {
          setState(() {
            prefs.setString("pic_path",
                Api.BASE_URL_PIC_PROFILE + '/' + userLogin['pic_path']);
          });
        });

        return Container(
            width: 200.0,
            height: 200.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(Api.BASE_URL_PIC_PROFILE +
                        '/' +
                        userLogin['pic_path']))));
      }

      return Container(
          width: 200.0,
          height: 200.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icon/zara-maintenance2.png'),
              )));
    }
  }

  void reloadUser() {
    SharedPreferences.getInstance().then((prefs) {
      Api.getUserlogin(prefs.getString("id_user")).then((val) {
        setState(() {
          user_login = val;
        });
      });
    });
  }
}
