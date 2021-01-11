import 'package:digi_pm_skin/pages/Home.dart';
import 'package:digi_pm_skin/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class DigiSplash extends StatefulWidget {
  @override
  _SplashScreenState  createState() => new _SplashScreenState ();
}

class _SplashScreenState extends State<DigiSplash> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    cekIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: Login(),
        title: new Text('DIGI PM SKIN',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: Image.asset('assets/icon/zara-maintenance2.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.purple
    );
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