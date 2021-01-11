import 'dart:convert';

import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[setImage(user_login, digiPM)],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
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
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Center(
              child: Text("Name :"),
            ),
            Center(
                child: FutureBuilder(
              future: _setUserName(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return Text(snapshot.data.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ));
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
            )),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Center(
              child: Text("Role : "),
            ),
            Center(
                child: FutureBuilder(
              future: _setRole(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return Text(snapshot.data.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ));
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
            )),
          ],
        ),
      );
    });
  }

  Future<String> _setUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("employee_name");
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
          width: 300.0,
          height: 300.0,
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
            width: 300.0,
            height: 300.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(Api.BASE_URL_PIC_PROFILE +
                        '/' +
                        userLogin['pic_path']))));
      }

      return Container(
          width: 300.0,
          height: 300.0,
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
