import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'popup.dart';
import 'popup_content.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SparePart extends StatefulWidget {
  String ewoId;
  bool valSparepart;
  // Map<String, dynamic> data;

  SparePart({Key key, @required this.ewoId, this.valSparepart}) : super(key: key);

  @override
  _SparePartState createState() => _SparePartState(ewoId, valSparepart);
}

class _SparePartState extends State<SparePart> {
  String ewoId;
  bool valSparepart;

  _SparePartState(this.ewoId, this.valSparepart);

  // _SparePartState(this.data);

  TextEditingController qty1, qty2, qty3, qty4, qty5;

  String _valSbu,
      _valLine,
      _valMachine,
      _valUnit,
      _valSubUnit,
      _valKerusakan,
      _valPerbaikan,
      _valActivity,
      _valPillar,
      _autoNumber,
      _valEmployeeId,
      _valEmployeeName,
      _valPmaDesc,
      _valAllDate;
  String valPart1;
  String valPart2;
  String valPart3;
  String valPart4;
  String valPart5;

  List<dynamic> dataEwo = List();

  List<dynamic> _dataSbu = List();
  List<dynamic> dataSparepart = List();
  List<dynamic> dataAnswer = List();

  var user_login;

  void getSbu() async {
    var listDataSbu = await Api.getSbu();
    setState(() {
      _dataSbu = listDataSbu;
    });
  }

  String sbu, line, machine, unit, subUnit;

  void getEwoList(String ewoId) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var listDataEwo = await Api.getDataEwoList('PM03', ewoId);
    print(listDataEwo);
    setState(() {
      dataEwo = listDataEwo['data'];
      dataEwo.forEach((element) {
        sbu = element['sbu'];
        line = element['line'];
        machine = element['machine'];
        unit = element['equipment'];
        subUnit = element['sub_unit'];
        getSparepart(element['sbu'], element['line'], element['machine'], element['equipment'], element['sub_unit']);
      });
    });
  }

  void getSparepart(dynamic sbu, dynamic line, dynamic machine, dynamic unit,
      String subUnit) async {
    // var listDataSparepart = await Api.getSparepart(sbu, line, machine, unit, subUnit);
    setState(() {
      // dataSparepart = listDataSparepart;
      print(dataSparepart);
    });
  }

  void getIdActivity(String pmat_description) async {
    var listDataActivity = await Api.getActivity(pmat_description);
    setState(() {
      _valActivity = listDataActivity[0]['id'];
    });
  }

  @override
  void initState() {
    qty1 = TextEditingController();
    qty2 = TextEditingController();
    qty3 = TextEditingController();
    qty4 = TextEditingController();
    qty5 = TextEditingController();
    qty1.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
    getEwoList(widget.ewoId);
    getSbu();
    _setEmployeeId();
  }

  @override
  void dispose() {
    qty1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return StatefulWrapper(
        onInit: (){

        },
        child: Scaffold(
          body: Container(
            child: Card(
              margin: EdgeInsets.all(7),
              color: Colors.white,
              elevation: 5,
              child: ListView(
                children: <Widget>[
                  RaisedButton(
                    child: Text('print'),
                    onPressed: (){
                      getEwoList('513');
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(13),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Sparepart 1',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text("-- SELECT --"),
                                          value: valPart1,
                                          items: dataSparepart.map((item) {
                                            return DropdownMenuItem(
                                              child: Text("${item['part_number']} - ${item['part']}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              value: item['part_number'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              setState(() {
                                                valPart1 = value;
                                                print(valPart1);
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: qty1,
                                        decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: ' ____',
                                            suffixStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          color: Colors.deepOrange,
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            'Pcs',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Sparepart 2',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text("-- SELECT --"),
                                          value: valPart2,
                                          items: dataSparepart.map((item) {
                                            return DropdownMenuItem(
                                              child: Text("${item['part_number']} - ${item['part']}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              value: item['part_number'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              setState(() {
                                                valPart2 = value;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: qty2,
                                        decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: ' ____',
                                            suffixStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          color: Colors.deepOrange,
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            'Pcs',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Sparepart 3',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text("-- SELECT --"),
                                          value: valPart3,
                                          items: dataSparepart.map((item) {
                                            return DropdownMenuItem(
                                              child: Text("${item['part_number']} - ${item['part']}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              value: item['part_number'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              setState(() {
                                                valPart3 = value;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: qty3,
                                        decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: ' ____',
                                            suffixStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          color: Colors.deepOrange,
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            'Pcs',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Sparepart 4',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text("-- SELECT --"),
                                          value: valPart4,
                                          items: dataSparepart.map((item) {
                                            return DropdownMenuItem(
                                              child: Text("${item['part_number']} - ${item['part']}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              value: item['part_number'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              setState(() {
                                                valPart4 = value;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: qty4,
                                        decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: ' ____',
                                            suffixStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          color: Colors.deepOrange,
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            'Pcs',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Sparepart 5',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text("-- SELECT --"),
                                          value: valPart5,
                                          items: dataSparepart.map((item) {
                                            return DropdownMenuItem(
                                              child: Text("${item['part_number']} - ${item['part']}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              value: item['part_number'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              setState(() {
                                                valPart5 = value;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: qty5,
                                        decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: ' ____',
                                            suffixStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          color: Colors.deepOrange,
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            'Pcs',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            // RaisedButton(
                            //   child: Text('print'),
                            //   onPressed: () async{
                            //     setPart();
                            //   },
                            // ),
                            // RaisedButton(
                            //   child: Text('print delete'),
                            //   onPressed: () async {
                            //     await delPart();
                            //   },
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: RaisedButton.icon(
                                    onPressed: (){
                                      saveSparepart(context);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(3.0))),
                                    label: Text('Save',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                                    icon: Icon(Icons.save, color:Colors.white,),
                                    textColor: Colors.white,
                                    splashColor: Color.fromRGBO(18, 37, 63, 1.0),
                                    color: Colors.green,),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  //978
  void saveSparepart(context) async {

    final data = {
      'part1' : valPart1 == null ? null : valPart1,
      'part2' : valPart2 == null ? null : valPart2,
      'part3' : valPart3 == null ? null : valPart3,
      'part4' : valPart4 == null ? null : valPart4,
      'part5' : valPart5 == null ? null : valPart5,
      'qty1' : qty1 == null ? null : qty1.text,
      'qty2' : qty2 == null ? null : qty2.text,
      'qty3' : qty3 == null ? null : qty3.text,
      'qty4' : qty4 == null ? null : qty4.text,
      'qty5' : qty5 == null ? null : qty5.text,
    };

    print(data);

    // if (valPart3 == null ){
    //   Util.alert(context, 'Validation', 'Sparepart belum di isi');
    //   return;
    // }
    // if (qty3 == null ){
    //   Util.alert(context, 'Validation', 'Sparepart belum di isi');
    //   return;
    // }

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('part1', valPart1);
    await pref.setString('part2', valPart2);
    await pref.setString('part3', valPart3);
    await pref.setString('part4', valPart4);
    await pref.setString('part5', valPart5);

    await pref.setString('qty1', qty1 == null ? null : qty1.text);
    await pref.setString('qty2', qty2 == null ? null : qty2.text);
    await pref.setString('qty3', qty3 == null ? null : qty3.text);
    await pref.setString('qty4', qty4 == null ? null : qty4.text);
    await pref.setString('qty5', qty5 == null ? null : qty5.text);

    Navigator.pop(context);

  }

  String setPart1;

  Future<String> delPart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('part1');
  }




  Future<String> _setEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeeId = prefs.getString("id_user");
    var employeeName = prefs.getString("employee_name");
    setState(() {
      _valEmployeeId = employeeId;
      _valEmployeeName = employeeName;
    });
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

  Widget part(BuildContext context, String title, dynamic qty, valpart) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text("-- SELECT --"),
                  value: valpart,
                  items: dataSparepart.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item['part'],
                        style: TextStyle(fontSize: 13),
                      ),
                      value: item['part'],
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      valpart = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: qty,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: ' ____',
                    suffixStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  color: Colors.deepOrange,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    'Pcs',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  )),
            )
          ],
        ),
      ],
    ));
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext AbnormalityFormView1}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.dark,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }
}
