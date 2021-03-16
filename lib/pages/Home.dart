import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/drawer.dart';
import 'package:digi_pm_skin/components/statefulWapper.dart';
import 'package:digi_pm_skin/fragments/abnormality/mainPageAbnormality.dart';
import 'package:digi_pm_skin/fragments/assignment.dart';
import 'package:digi_pm_skin/fragments/abnormality/abnormality_home.dart';
import 'package:digi_pm_skin/fragments/breakdown/mainPageBreakdown.dart';
import 'package:digi_pm_skin/fragments/manytask/mainPageManyTask.dart';
import 'package:digi_pm_skin/fragments/otif_line_manager.dart';
import 'package:digi_pm_skin/fragments/spv_assignment.dart';
import 'package:digi_pm_skin/fragments/user_management.dart';
import 'package:digi_pm_skin/provider/abnormalityProvider.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'Login.dart';


class Home extends StatelessWidget {
  final roleStatus;
  final backFrom;
  Home({Key key, this.roleStatus, this.backFrom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("home rendered");
    return Consumer2<DigiPMProvider, AbnormalityProvider>(builder: (context, digiPM, abnormality, __) {
      return WillPopScope(
          onWillPop: () {
            return _onWillPop(context);
          },
          child: StatefulWrapper(
              onInit: () async {
                SharedPreferences.getInstance().then((prefs) {
                  if (prefs.getBool("is_supervisor")) {
                    if (backFrom == "team") {
                      digiPM.drawerIndex = 11;
                      digiPM.setTaskbar = "DIGI PM - Team Tasklist";
                    } else if (backFrom == "indiv") {
                      digiPM.drawerIndex = 10;
                      digiPM.setTaskbar = "DIGI PM - Individual Tasklist";
                    } else {
                      digiPM.drawerIndex = 10;
                      digiPM.setTaskbar = "DIGI PM - Individual Tasklist";
                    }

                    digiPM.currentRole = "supervisor";
                    digiPM.visibleReloadIndicator = true;
                    var data = {};
                    data['id_supervisor'] = prefs.getString("id_user");
                    digiPM.getSupervisorTechnician(data);
                  } else if (prefs.getBool("is_line_manager")) {
                    digiPM.currentRole = 'line_manager';
                    digiPM.drawerIndex = 1;
                    digiPM.visibleCalendar = false;
                    digiPM.visibleWeek = true;
                    digiPM.setTaskbar = "DIGI PM - Otif Supervisor";
                  } else {
                    digiPM.drawerIndex = 0;
                    digiPM.visibleCalendar = true;
                    digiPM.visibleReloadIndicator = true;
                    digiPM.setTaskbar = "DIGI PM - Tasklist Assignment";
                    digiPM.getUserTasklist({
                      'id_user': prefs.getString("id_user"),
                      'date':
                      DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
                    }, context);
                  }
                });
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(digiPM.selectedTaskbar),
                  actions: <Widget>[
                    setCalendarDisplay(context, digiPM),
                    setDropdownWeek(context, digiPM),
                    setRefreshIndicator(context, digiPM)
                  ],
                ),
                drawer: Drawer(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new UserAccountsDrawerHeader(
                          currentAccountPicture: FutureBuilder(
                            future: _setProfilePic(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  if (snapshot.data.toString() == "null") {
                                    return CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/icon/zara-maintenance2.png'),
                                      backgroundColor: Colors.white,
                                    );
                                  }
                                  return CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        Api.BASE_URL_PIC_PROFILE +
                                            '/' +
                                            snapshot.data.toString()),
                                    backgroundColor: Colors.white,
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/icon/zara-maintenance2.png'),
                                    backgroundColor: Colors.white,
                                  );
                                }
                              } else {
                                return CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/icon/zara-maintenance2.png'),
                                  backgroundColor: Colors.white,
                                );
                              }
                            },
                          ),
                          accountName: FutureBuilder(
                            future: _setUserName(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  return Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(snapshot.data.toString()),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 3),
                                                    ),
                                                    setStart(digiPM),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 3),
                                                    ),
                                                    setRatingText(digiPM),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 10),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                )))
                                      ],
                                    ),
                                  );
                                } else {
                                  return Text("Loading...");
                                }
                              } else {
                                return Text("-");
                              }
                            },
                          ),
                          accountEmail: FutureBuilder(
                            future: _setRole(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  return Text(snapshot.data.toString());
                                } else {
                                  return Text("Loading...");
                                }
                              } else {
                                return Text("-");
                              }
                            },
                          ),
                        ),
                        FutureBuilder<dynamic>(
                          future: _setDrawerMenu(digiPM, context),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                return new Column(
                                  children: snapshot.data,
                                );
                              } else {
                                return new Column(
                                  children: <Widget>[Text("Loading...")],
                                );
                              }
                            } else {
                              return new Column(
                                children: <Widget>[Text("Loading...")],
                              );
                            }
                          },
                        ),
                        FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                return new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        child: Text(
                                            "Versi Aplikasi (Demo Version)")),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        child: Text(snapshot.data.version)),
                                  ],
                                );
                              } else {
                                return new Column(
                                  children: <Widget>[
                                    Container(child: Text("Loading..."))
                                  ],
                                );
                              }
                            } else {
                              return new Column(
                                children: <Widget>[
                                  Container(child: Text("Loading..."))
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                body: _getDrawerItemWidget(digiPM),
              )));
    });
  }

  _getDrawerItemWidget(DigiPMProvider digiPM) {
    log("route : " + digiPM.selectedDrawerIndex.toString());
    if (digiPM.currentRole == "line_manager") {
      switch (digiPM.selectedDrawerIndex) {
        case 1:
          return new OtifListLineManager();
        case 4:
          return new UserManagement();
        default:
          return null;
      }
    } else {
      switch (digiPM.selectedDrawerIndex) {
        case 0:
          return new Assignment();
        case 10:
          return new SpvAssignment(caller: "indiv");
        case 11:
          return new SpvAssignment(caller: "team");
        case 15:
          return new SpvAssignment(caller: "pending");
        case 2:
          return new SpvAssignment(caller: "trline");
        case 3:
          return new SpvAssignment(caller: "ucf_exe");
        case 4:
          return new UserManagement();
        case 5:
          return new MainPageAbnormality(caller: "tes");
        case 6:
          return new MainPageBreakdown();
        // case 7:
        //   return new AutonomousPage();
        case 8:
          return new MainPageManyTask();
        default:
          return null;
      }
    }
  }

  _onSelectItem(int index, DrawerItem drawerItem, DigiPMProvider digiPM,
      String selectedUid, context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    digiPM.drawerIndex = index;

    if (prefs.getBool("is_line_manager")) {
      if (index == 1) {
        digiPM.setTaskbar = "DIGI PM - Otif Supervisor";
        digiPM.visibleWeek = true;
      } else {
        digiPM.visibleWeek = false;
      }

      if (index == 4) digiPM.setTaskbar = "DIGI PM - User Management";

      // if (index == 5) digiPM.setTaskbar = "DIGI PM - Abnormality EWO(PM03)";

      if (index == 6) digiPM.setTaskbar = "DIGI PM - Breakdown EWO(PM02)";
      if (index == 7) digiPM.setTaskbar = "DIGI PM - Autonomous Maintenance";
      if (index == 8) digiPM.setTaskbar = "DIGI PM - PM/AM/FI/QM/SHE TASK";


      if (index == 9) {
        _logoutConfirmation(context);
      } else {
        digiPM.drawerIndex = index;
        Navigator.of(context).pop(); // close the drawer
      }



    } else {
      if (selectedUid != null) digiPM.selectedDrawer = selectedUid;

      if (drawerItem.uid == "dsb") digiPM.setTaskbar = "DIGI PM - Dashboard";

      if (drawerItem.uid == "taskl") {
        if (index == 0) {
          Navigator.of(context).pop(false);
          digiPM.setTaskbar = "DIGI PM - Tasklist Assignment";
          digiPM.visibleReloadIndicator = true;
          digiPM.visibleCalendar = true;
          await digiPM.getUserTasklist({
            'id_user': prefs.getString("id_user"),
            'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
          }, context);
        }

        if (index == 10) {
          Navigator.of(context).pop(false);
          digiPM.setTaskbar = "DIGI PM - Individual Tasklist";
          digiPM.setLoadingState(true);
          digiPM.visibleCalendar = false;
          digiPM.visibleReloadIndicator = true;
          var data = {};
          data['man_power'] = "1";
          data['status'] = "1";
          data['id_supervisor'] = prefs.getString("id_user");
          await digiPM.getDailySupervisor(data);
          await digiPM.getWeeklySupervisor(data);
          await digiPM.getSupervisorTechnician(data);
          digiPM.setLoadingState(false);
        }

        if (index == 11) {
          Navigator.of(context).pop(false);
          digiPM.visibleReloadIndicator = true;
          digiPM.setLoadingState(true);
          digiPM.setTaskbar = "DIGI PM - Team Tasklist";
          digiPM.visibleCalendar = false;
          var data = {};
          data['man_power'] = "2";
          data['status'] = "1";
          data['id_supervisor'] = prefs.getString("id_user");
          await digiPM.getDailySupervisor(data);
          await digiPM.getWeeklySupervisor(data);
          await digiPM.getSupervisorTechnician(data);
          digiPM.setLoadingState(false);
        }

        if (index == 15) {
          Navigator.of(context).pop(false);
          digiPM.visibleReloadIndicator = true;
          digiPM.setLoadingState(true);
          digiPM.setTaskbar = "DIGI PM - Pending Tasklist";
          digiPM.visibleCalendar = false;
          digiPM.selectedDrawer = "pending";
          var data = {};
          data['man_power'] = "0";
          data['status'] = "4";
          data['id_supervisor'] = prefs.getString("id_user");
          await digiPM.getDailySupervisor(data);
          await digiPM.getWeeklySupervisor(data);
          await digiPM.getSupervisorTechnician(data);
          digiPM.setLoadingState(false);
        }
      } else {
        digiPM.visibleCalendar = false;
      }

      if (index == 2) {
        Navigator.of(context).pop(false);
        digiPM.setLoadingState(true);
        digiPM.visibleReloadIndicator = true;
        digiPM.setTaskbar = "DIGI PM - Trial PM Tasklist";
        digiPM.visibleCalendar = false;
        var data = {};
        data['man_power'] = "0";
        data['status'] = "2";
        data['is_ready_rating'] = "1";
        data['id_supervisor'] = prefs.getString("id_user");
        await digiPM.getDailySupervisor(data);
        await digiPM.getWeeklySupervisor(data);
        digiPM.setLoadingState(false);
      }

      if (index == 3) {
        Navigator.of(context).pop(false);
        digiPM.setLoadingState(true);
        digiPM.visibleReloadIndicator = true;
        digiPM.setTaskbar = "DIGI PM - Unconfirmed Tasklist";
        var data = {};
        data['man_power'] = "0";
        data['status'] = "2";
        data['is_ready_rating'] = "0";
        data['reason'] = "1";
        data['id_supervisor'] = prefs.getString("id_user");
        await digiPM.getDailySupervisor(data);
        await digiPM.getWeeklySupervisor(data);
        digiPM.setLoadingState(false);
      }

      if (index == 4) {
        digiPM.visibleReloadIndicator = false;
        digiPM.setTaskbar = "DIGI PM - User Management";
        Navigator.of(context).pop(false);
      }

      if (index == 5) {
        digiPM.visibleReloadIndicator = false;
        digiPM.setTaskbar = "Abnormality EWO(PM03)";
        Navigator.of(context).pop(false);
      }

      if (index == 6) {
        digiPM.visibleReloadIndicator = false;
        digiPM.setTaskbar = "Breakdown EWO(PM02)";
        Navigator.of(context).pop(false);
      }

      if (index == 7) {
        digiPM.visibleReloadIndicator = false;
        digiPM.setTaskbar = "Autonomous Maintenance";
        Navigator.of(context).pop(false);
      }

      if (index == 8) {
        digiPM.visibleReloadIndicator = false;
        digiPM.setTaskbar = "PM/AM/FI/QM/SHE TASK";
        Navigator.of(context).pop(false);
      }

      if (index == 9) {
        _logoutConfirmation(context);
      }


    }
  }

  Future<bool> _logoutConfirmation(context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirmation'),
        content: new Text('Do you want to logout?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => logout(context),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<bool> _onWillPop(context) {
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
            onPressed: () {
              SystemNavigator.pop();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<String> _setUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("employee_name");
  }

  Future<String> _setProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("pic_path_raw");
  }

  Future<String> _setRole() async {
    var role = "-";
    var txtRole = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("is_supervisor")) {
      txtRole = "(Supervisor)";
    } else if (prefs.getBool("is_line_manager")) {
      txtRole = "(Line Manager)";
    }

    role = prefs.getString("role_name");

    return role + " " + txtRole;
  }

  logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear().then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => new Login()),
              (Route<dynamic> route) => false);
    });
  }

  Widget setCalendarDisplay(context, DigiPMProvider digiPM) {
    if (digiPM.visibleCalendar == true) {
      return IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            digiPM.selectDate(context);
          });
    } else {
      return Text('');
    }
  }

  Widget setDropdownWeek(context, DigiPMProvider digiPM) {
    if (digiPM.visbleWeek == true) {
      return IconButton(
          icon: Icon(Icons.calendar_view_day),
          onPressed: () {
            _selectWeek(context, digiPM);
          });
    } else {
      return Text('');
    }
  }

  _setDrawerMenu(DigiPMProvider digiPM, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var drawerOptions = <Widget>[];

    // supervisor
    if (prefs.getBool("is_supervisor")) {
      for (var i = 0; i < digiPM.drawer.length; i++) {
        var d = digiPM.drawer[i];

        if (d.uid != "otif_spv") {
          if (d.uid == "taskl") {
            drawerOptions.add(ExpansionTile(
              leading: new Icon(d.icon),
              title: Text("Tasklist Assignment"),
              initiallyExpanded: true,
              children: <Widget>[
                new ListTile(
                    leading: new Icon(d.icon),
                    title: new Text("Individual Task"),
                    selected: digiPM.selectedDrawer == "indv",
                    onTap: () async {
                      _onSelectItem(i + 10, d, digiPM, "indv", context);
                    }),
                new ListTile(
                    leading: new Icon(d.icon),
                    title: new Text("Team Task"),
                    selected: digiPM.selectedDrawer == "team",
                    onTap: () async {
                      _onSelectItem(i + 11, d, digiPM, "team", context);
                    }),
                new ListTile(
                    leading: new Icon(d.icon),
                    title: new Text("Pending Task"),
                    selected: digiPM.selectedDrawer == "pending",
                    onTap: () async {
                      _onSelectItem(i + 15, d, digiPM, "team", context);
                    })
              ],
            ));
          } else {
            if (d.uid == "ufd_exe" ||
                d.uid == "usermgmt" ||
                d.uid == "line_tr" ||
                d.uid == "abnormal" ||
                d.uid == "breakdown" ||
                d.uid == "autonomous" ||
                d.uid == "manyTask" ||
                d.uid == "logout") {
              drawerOptions.add(new ListTile(
                leading: new Icon(d.icon),
                title: new Text(d.drawerTitle),
                selected: i == digiPM.selectedDrawerIndex,
                onTap: () async {
                  _onSelectItem(i, d, digiPM, d.uid, context);
                  print(d.uid);
                  // print(_onSelectItem(i, d, digiPM, d.uid, context));
                } ,
              ));
            }
          }
        }
      }
    } else if (prefs.getBool("is_line_manager")) {
      // line manager
      for (var i = 0; i < digiPM.drawer.length; i++) {
        var d = digiPM.drawer[i];

        if (d.uid == "otif_spv") {
          drawerOptions.add(new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.drawerTitle),
            selected: i == digiPM.selectedDrawerIndex,
            onTap: () async => _onSelectItem(i, d, digiPM, null, context),
          ));
        }

        if (d.uid == "logout") {
          drawerOptions.add(new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.drawerTitle),
            selected: i == digiPM.selectedDrawerIndex,
            onTap: () async => _onSelectItem(i, d, digiPM, null, context),
          ));
        }

        if (d.uid == "usermgmt") {
          drawerOptions.add(new ListTile(
              leading: new Icon(d.icon),
              title: new Text(d.drawerTitle),
              selected: i == digiPM.selectedDrawerIndex,
              onTap: () async => _onSelectItem(i, d, digiPM, null, context)));
        }
      }
    } else {
      // for technician
      for (var i = 0; i < digiPM.drawer.length; i++) {
        var d = digiPM.drawer[i];

        if (d.uid != "otif_spv" && d.uid != "ufd_exe" && d.uid != "line_tr") {
          drawerOptions.add(new ListTile(
              leading: new Icon(d.icon),
              title: new Text(d.drawerTitle),
              selected: i == digiPM.selectedDrawerIndex,
              onTap: () async => _onSelectItem(i, d, digiPM, null, context)));
        }
      }
    }

    return drawerOptions;
  }

  Widget setAvatarImg(DigiPMProvider digiPM) {
    if (digiPM.activePicUrl == null) {
      return CircleAvatar(
        backgroundImage: AssetImage('assets/icon/zara-maintenance2.png'),
        backgroundColor: Colors.white,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(digiPM.activePicUrl),
        backgroundColor: Colors.white,
      );
    }
  }

  void _selectWeek(context, DigiPMProvider digiPM) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Please Select Week'),
        content: generateWeekList(digiPM, context),
        actions: <Widget>[],
      ),
    );
  }

  Widget generateWeekList(DigiPMProvider digiPM, context) {
    var listTreeDropdown = new List<DropdownMenuItem<dynamic>>();

    listTreeDropdown.add(DropdownMenuItem(
      child: Text("SELECT REASON PENDING"),
      value: "",
    ));

    for (var i = 1; i <= 52; i++) {
      listTreeDropdown.add(DropdownMenuItem(
        child: Text("Week $i"),
        value: i.toString(),
      ));
    }

    debugPrint(listTreeDropdown.toString());

    return FormBuilderDropdown(
      isExpanded: false,
      attribute: "Select Week",
      decoration: InputDecoration(labelText: "List Week"),
      initialValue: digiPM.selectedWeek,
      hint: Text('Select Week'),
      onChanged: (val) {
        digiPM.selectedWeek = val;
        Navigator.of(context).pop(false);
      },
      validators: [FormBuilderValidators.required()],
      items: listTreeDropdown,
    );
  }

  Widget setStart(DigiPMProvider digiPM) {
    if (digiPM.currentRole != 'line_manager') {
      return Icon(
        Icons.star,
        color: Colors.orange,
        size: 15,
      );
    }
    return Text("");
  }

  Widget setRatingText(DigiPMProvider digiPM) {
    if (digiPM.currentRole != 'line_manager') {
      return Text("5");
    }
    return Text("");
  }

  Widget setRefreshIndicator(context, DigiPMProvider digiPM) {
    if (digiPM.visibleReloadIndicator == true) {
      return IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            var data = {};
            SharedPreferences.getInstance().then((prefs) async {
              digiPM.setLoadingState(true);
              if (prefs.getBool("is_supervisor")) {
                if (digiPM.selectedDrawerIndex == 11) {
                  data['man_power'] = "2";
                  data['status'] = "1";
                } else if (digiPM.selectedDrawerIndex == 2) {
                  data['man_power'] = "0";
                  data['status'] = "2";
                  data['is_ready_rating'] = "1";
                } else if (digiPM.selectedDrawerIndex == 3) {
                  data['man_power'] = "0";
                  data['status'] = "2";
                  data['reason'] = "1";
                  data['is_ready_rating'] = "0";
                } else if (digiPM.selectedDrawerIndex == 15) {
                  data['man_power'] = "0";
                  data['status'] = "4";
                }
                if (digiPM.selectedDrawerIndex == 10) {
                  data['man_power'] = "1";
                  data['status'] = "1";
                }
                data['id_supervisor'] = prefs.getString("id_user");
                await digiPM.getDailySupervisor(data);
                await digiPM.getWeeklySupervisor(data);
              } else if (prefs.getBool("is_supervisor")) {
              } else {
                if (digiPM.selectedDrawerIndex == 0) {
                  await digiPM.getUserTasklist({
                    'id_user': prefs.getString("id_user"),
                    'date': DateFormat("yyyy-MM-dd").format(digiPM.selectedDate)
                  }, context);
                }
              }

              digiPM.setLoadingState(false);
            });
          });
    } else {
      return Text("");
    }
  }
}
