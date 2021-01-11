import 'package:flutter/material.dart';

class TabClosed extends StatefulWidget {
  @override
  _TabClosedState createState() => _TabClosedState();
}

class _TabClosedState extends State<TabClosed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('tab closed'),
      ),
    );
  }
}
