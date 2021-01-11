import 'package:digi_pm_skin/pages/Splashscreen.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DigiPMProvider>.value(value: DigiPMProvider())
      ],
      child: MaterialApp(
          home: new DigiSplash(),
          theme: ThemeData(
              primaryColor: Color.fromRGBO(18, 37, 63, 1.0),
              accentColor: Color.fromRGBO(18, 37, 63, 1.0),
              appBarTheme:
                  AppBarTheme(color: Color.fromRGBO(18, 37, 63, 1.0)))),
    );
  }
}
