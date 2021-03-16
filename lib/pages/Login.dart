import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/pages/Home.dart';
import 'package:digi_pm_skin/util/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  final pinController = TextEditingController();
  final passwordController = TextEditingController();
  bool statusLogin = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    cekIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: Center(
          child: Stack(children: <Widget>[
            Positioned.fill(
              child:
                  Image.asset('assets/images/login_bg.png', fit: BoxFit.cover),
            ),
            Center(
              child: ListView(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 40,
                                right: 40,
                                top: width < 481 ? 125 : 30),
                            child: Card(
                              elevation: 2,
                              color: Colors.blueGrey.withOpacity(0.5),
                              child: Container(
                                padding: EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    width < 481
                                        ? Image.asset(
                                            'assets/icon/zara-maintenance2.png',
                                            width: 100,
                                            height: 100)
                                        : Image.asset(
                                            'assets/icon/zara-maintenance2.png'),
                                    Center(
                                      child: Text(
                                        "DIGI PM DEMO",
                                        style: TextStyle(
                                            fontSize: width < 481 ? 15 : 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: "ID PENGGUNA",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.cyan),
                                            ),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                            icon: Icon(Icons.account_circle,
                                                color: Colors.orange,
                                                size: width < 481 ? 25 : 40),
                                            hintText: "ID PENGGUNA"),
                                        controller: pinController,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      margin: EdgeInsets.only(top: 30),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: "PIN",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.cyan),
                                            ),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                            icon: Icon(Icons.lock,
                                                color: Colors.orange,
                                                size: width < 481 ? 25 : 40),
                                            hintText: "PIN"),
                                        style: TextStyle(color: Colors.white),
                                        controller: passwordController,
                                        obscureText: true,
                                      ),
                                      margin: EdgeInsets.only(
                                          top: width < 481 ? 10 : 40),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: MaterialButton(
                                            padding: EdgeInsets.only(
                                                right: 30,
                                                left: 30,
                                                top: 15,
                                                bottom: 15),
                                            color: Colors.purple,
                                            textColor: Colors.white,
                                            child: Text(
                                              "LOG IN",
                                              style: TextStyle(
                                                  fontSize:
                                                      width < 481 ? 15 : 20,
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              performLogin();
                                            },
                                          ),
                                          margin: EdgeInsets.only(
                                              top: width < 481 ? 10 : 40),
                                          padding: EdgeInsets.all(20),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                ],
              ),
            )
          ]),
        )));
  }

  bool cekForm() {
    if (pinController.text == '') {
      return false;
    } else if (passwordController.text == '') {
      return false;
    } else {
      return true;
    }
  }

  void performLogin() async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Center(child: CircularProgressIndicator());
        });

    statusLogin = cekForm();

    if (statusLogin == true) {
      var data = {
        'pin': passwordController.text,
        'idUser': pinController.text,
      };

      Api.login(data).then((response) {
        if (response == null) {
          Navigator.pop(context);
          Util.alert(context, "Login Failed", "User Not Found");
          return;
        }

        if (response['status'] == "failed") {
          Navigator.pop(context);
          Util.alert(context, "Login Failed", response['message']);
        } else {
          Future<SharedPreferences> prefs = SharedPreferences.getInstance();
          prefs.then((val) {
            if (response['is_line_manager'] == "1") {
              val.setBool("is_line_manager", true);
            } else {
              val.setBool("is_line_manager", false);
            }

            if (response['is_supervisor'] == "1") {
              val.setBool("is_supervisor", true);
            } else {
              val.setBool("is_supervisor", false);
            }

            val.setBool("login", true);
            val.setString("id_user", response['id']);
            val.setString("role", response['role']);
            val.setString("role_name", response['role_name']);
            val.setString("bussiness_title", response['bussiness_title']);
            val.setString("employee_id", response['employee_id']);
            val.setString("employee_name", response['employee_name']);
            val.setString("email", response['email']);
            val.setString("gender", response['gender']);
            val.setString("department", response['department']);
            val.setString("pic_path",
                Api.BASE_URL_PIC_PROFILE + '/' + response['pic_path']);
            val.setString("pic_path_raw", response['pic_path']);

          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => new Home()),
              (Route<dynamic> route) => false);
        }
      }).catchError((onError) {
        var error = onError.toString();
        if (onError.runtimeType.toString() == "SocketExceptions") {
          Navigator.pop(context);
          Util.alert(context, "Error Notification",
              "Network error. Please check your internet connection");
        } else {
          Navigator.pop(context);
          Util.alert(
              context,
              "Error Notification",
              "Error occured. please contact developer. "
                  "detail info : $error");
        }
      });
    } else {
      Navigator.pop(context);
      Util.alert(context, "Validation", "Please Fill blank form");
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void cekIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = (prefs.getBool('login') ?? false);
    });

    if (isLoggedIn == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => new Home()),
          (Route<dynamic> route) => false);
    }
  }
}
