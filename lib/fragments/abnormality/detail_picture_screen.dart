import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailScreen extends StatelessWidget {

  DetailScreen(this.url);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20,0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.5,
                child: Hero(
                  tag: 'imageHero',
                  child: Container(
                    child: QrImage(
                      data: url,
                      version: QrVersions.auto,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                child: Text('NIP : ${url.toString()}', style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25
                ),),
              ),
            )

          ],
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}