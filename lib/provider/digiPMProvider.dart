import 'dart:io';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/components/drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigiPMProvider extends ChangeNotifier {
  List<DrawerItem> _drawerItems = [
    new DrawerItem("DIGI PM - Tasklist Assignment", Icons.assignment,
        "Tasklist Assignment", "taskl"),
    new DrawerItem(
        "Otif Supervisor", Icons.assignment, "Otif Supervisor", "otif_spv"),
    new DrawerItem("DIGI PM - Line Trial PM", Icons.assignment, "Line Trial PM",
        "line_tr"),
    new DrawerItem("DIGI PM - Unconfirmed Execution", Icons.assignment,
        "Unconfirmed Execution", "ufd_e../xe"),
    new DrawerItem("DIGI PM - User Management", Icons.account_circle,
        "User Management", "usermgmt"),
    // new DrawerItem("DIGI PM - Confirmed Execution", Icons.assignment,
    //     "Confirmed Execution", "ufd_exe"),
    new DrawerItem("DIGI PM - Abnormality EWO (PM03)", Icons.assignment,
        "Abnormality EWO", "abnormal"),
    new DrawerItem("DIGI PM - Breakdown EWO (PM02)", Icons.assignment,
        "Breakdown EWO", "breakdown"),
    new DrawerItem("DIGI PM - Autonomous Maintenance", Icons.assignment,
        "Autonomous Maintenance", "autonomous"),
    new DrawerItem("DIGI PM - PM/AM/FI/QM/SHE TASK", Icons.assignment,
        "PM/AM/FI/QM/SHE TASK", "manyTask"),
    new DrawerItem("Logout", Icons.power_settings_new, "Logout", "logout"),
  ];

  bool _isFormHome = true;

  String _activePicUrl;
  String _currentRole;
  String _currentMenu;
  int _selectedDrawerIndex;
  bool _visibleCalendar = false;
  bool _visibleWeekList = false;
  bool _visibleReloadIndicator = false;

  double _ratingSelectedTasklist;
  String _selectedUserDelegation;

  String _selectedWeek = Jiffy().week.toString();

  List<Tab> _tabExe = [Tab(text: "SOP"), Tab(text: "Form")];

  List<Tab> _tabSpvAssignment = [Tab(text: "Daily"), Tab(text: "Weekly")];

  String _selectedUidDrawer = "";

  String _activeTaskbar = "DIGI PM - Dashboard";

  String _spvWeekSelected = '';

  List<dynamic> _lossTree;
  List<dynamic> _tasklistUser;
  List<dynamic> _tasklistUserSpvDaily;
  List<dynamic> _tasklistUserSpvWeekly;
  List<dynamic> _userList;

  Map<String, dynamic> _selectedTasklist;
  Map<String, dynamic> _selectedExeTasklist;


  Map<String, dynamic> _executionProperty = {
    'startExe': null,
    'isStarting': false,
    'hasExecuted': false,
    'txtButton': "Start Execution",
    'counterSecond': 0,
    'secondExeCount': 0,
    'btnColor': Colors.green,
    'bannerResult': null,
    'bannerExe': "00:00",
    'max_photo': 3,
    'photo_evidence': [],
    'photo_evidence_before': [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ],
    'photo_before_counter': 0,
    'photo_evidence_after': [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ],
    'photo_after_counter': 0,
    'execution_status': null,
    'pending_reason_status': 0,
    'other_reason_text': '',
    'recommendation_text': '',
    'updateFromRating': false
  };

  Map<String, dynamic> _executionPropertyOrigin = {
    'startExe': null,
    'isStarting': false,
    'hasExecuted': false,
    'txtButton': "Start Execution",
    'counterSecond': 0,
    'secondExeCount': 0,
    'btnColor': Colors.green,
    'bannerResult': null,
    'bannerExe': "00:00",
    'max_photo': 3,
    'photo_evidence': [],
    'photo_evidence_before': [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ],
    'photo_before_counter': 0,
    'photo_evidence_after': [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ],
    'photo_after_counter': 0,
    'execution_status': null,
    'pending_reason_status': 0,
    'other_reason_text': '',
    'recommendation_text': '',
    'updateFromRating': false
  };

  List<String> _nameMenu = [
    "Sparepart Picklist By EWO Number",
    "Abnormality PM03 Tasklist",
    "Breakdown PM02 Tasklist",
    "Tasklist Validation"
  ];


  List<String> _urlImages = [
    "assets/icon/sparepart.png",
    "assets/icon/mobile.png",
    "assets/icon/mobile.png",
    "assets/icon/approval.png"
  ];

  List<Color> _colorCard = [
    Colors.red.withOpacity(0.7),
    Colors.green.withOpacity(0.7),
    Colors.orange.withOpacity(0.7),
    Colors.deepPurple.withOpacity(0.7),
  ];

  List<String> get namaMenu => _nameMenu;
  List<String> get urlImages => _urlImages;
  List<Color> get colorCard => _colorCard;

  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  bool _displayFloatingButtonCamera = false;

  List _OtifListLineManager;

  bool get navigatorPage => _isFormHome;

  List<DrawerItem> get drawer => _drawerItems;

  DateTime get selectedDate => _selectedDate;
  String get selectedDrawer => _selectedUidDrawer;
  String get selectedWeek => _selectedWeek;
  String get selectedTaskbar => _activeTaskbar;
  Map<String, dynamic> get executionPropertyOrigin => _executionPropertyOrigin;
  String get activePicUrl => _activePicUrl;

  String get spvWeekSelected => _spvWeekSelected;
  int get selectedDrawerIndex => _selectedDrawerIndex;
  String get currentRole => _currentRole;
  bool get visbleWeek => _visibleWeekList;
  bool get visibleCalendar => _visibleCalendar;
  bool get visibleReloadIndicator => _visibleReloadIndicator;

  double get ratingSelectedTasklist => _ratingSelectedTasklist;
  String get selectedUserDelegation => _selectedUserDelegation;

  List<dynamic> get tasklistUser => _tasklistUser;
  List<dynamic> get tasklistUserSpvDaily => _tasklistUserSpvDaily;
  List<dynamic> get tasklistUserSpvWeekly => _tasklistUserSpvWeekly;
  List<dynamic> get userList => _userList;
  List<dynamic> get otifListManager => _OtifListLineManager;

  List<dynamic> get lossTree => _lossTree;

  Map<String, dynamic> get executionProperty => _executionProperty;
  Map<String, dynamic> get selectedTasklist => _selectedTasklist;
  Map<String, dynamic> get selectedExeTasklist => _selectedExeTasklist;


  List<Tab> get tabExe => _tabExe;
  List<Tab> get tabSpvAssignment => _tabSpvAssignment;

  bool get isLoading => _isLoading;

  bool get displayFloatingButtonCamera => _displayFloatingButtonCamera;

  set FormHome(bool home){
    _isFormHome = home;
    notifyListeners();
  }


  set ratingSelectedTasklist(double rating) {
    _ratingSelectedTasklist = rating;
    notifyListeners();
  }

  set selectedUserDelegation(String user) {
    _selectedUserDelegation = user;
    notifyListeners();
  }

  set drawerIndex(int index) {
    _selectedDrawerIndex = index;
    notifyListeners();
  }

  set currentRole(String role) {
    _currentRole = role;
    notifyListeners();
  }

  set visibleWeek(bool status) {
    _visibleWeekList = status;
    notifyListeners();
  }

  set visibleCalendar(bool status) {
    _visibleCalendar = status;
    notifyListeners();
  }

  set visibleReloadIndicator(bool status) {
    _visibleReloadIndicator = status;
    notifyListeners();
  }

  set setTaskbar(String taskbar) {
    _activeTaskbar = taskbar;
    notifyListeners();
  }

  set activePicUrl(String url) {
    _activePicUrl = url;
    notifyListeners();
  }

  set resetExecProperty(dynamic reset) {
    _executionProperty = reset;
    notifyListeners();
  }

  set setVisibelFloatingButtonCamera(bool status) {
    _displayFloatingButtonCamera = status;
    notifyListeners();
  }

  set selectedDrawer(String uid) {
    _selectedUidDrawer = uid;
    notifyListeners();
  }

  set selectedWeek(String week) {
    _selectedWeek = week;
    notifyListeners();
  }

  set spvWeekSelected(String uid) {
    _spvWeekSelected = uid;
    notifyListeners();
  }

  addDrawerItems(DrawerItem item) {
    _drawerItems.add(item);
    notifyListeners();
  }

  setTasklistUser(List<dynamic> list) {
    _tasklistUser = list;
    notifyListeners();
  }

  setOtifListLineManager(List<dynamic> list) {
    _OtifListLineManager = list;
    notifyListeners();
  }


  setTasklistUserSpvDaily(List<dynamic> list) {
    if (_tasklistUserSpvDaily != null) {
      _tasklistUserSpvDaily.clear();
    }
    _tasklistUserSpvDaily = list;
    notifyListeners();
  }

  setlistUser(List<dynamic> list) {
    _userList = list;
    notifyListeners();
  }

  setTasklistUserSpvWeekly(List<dynamic> list) {
    if (_tasklistUserSpvWeekly != null) {
      _tasklistUserSpvWeekly.clear();
    }
    _tasklistUserSpvWeekly = list;
    notifyListeners();
  }

  setLostTree(List<dynamic> list) {
    _lossTree = list;
    notifyListeners();
  }

  setExeItem(String prop, value) {
    _executionProperty[prop] = value;
    notifyListeners();
  }


  setLoadingState(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  setSelectedTasklistUser(Map<String, dynamic> tasklist) {
    _selectedTasklist = tasklist;
    notifyListeners();
  }

  setSelectedExeTasklistUser(Map<String, dynamic> tasklist) {
    _selectedExeTasklist = tasklist;
    notifyListeners();
  }

  setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  getUserTasklist(data, context) async {
    if (_tasklistUser != null) {
      _tasklistUser.clear();
      notifyListeners();
    }
    setLoadingState(true);
    try {
      var tasklist = await Api.getUserTasklist(data);
      setTasklistUser(tasklist);
      setLoadingState(false);
    } on SocketException catch (e) {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Network Problem'),
          content: new Text(
              'Can not connect to the internet network . Error : ' +
                  e.toString()),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                getUserTasklist(data, context);
              },
              child: new Text('Reload'),
            )
          ],
        ),
      ) ??
          false;
    }
  }



  saveRating(data) async {
    var response = await Api.saveRating(data);
    return response;
  }

  getDailySupervisor(data) async {
    var response = await Api.getDailySupervisor(data);
    setTasklistUserSpvDaily(response);
  }

  getWeeklySupervisor(data) async {
    var response = await Api.getWeeklySupervisor(data);
    setTasklistUserSpvWeekly(response);
  }


  getSupervisorTechnician(data) async {
    var response = await Api.getSupervisorTechnician(data);
    setlistUser(response);
  }


  getImageBefore() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<dynamic> newPhoto = [];
    List<dynamic> photo = executionProperty['photo_evidence_before'];
    int counter = executionProperty['photo_before_counter'];
    for (var i = 0; i < photo.length; i++) {
      if (i == counter && photo[i]['img_path'] == null) {
        newPhoto.add({'img_path': image.path, 'img': image});
        // print ({'img_path': image.path, 'img': image});
      } else {
        newPhoto.add(photo[i]);
      }
    }
    setExeItem('photo_before_counter', counter + 1);
    setExeItem('photo_evidence_before', newPhoto);
  }

  getImageAfter() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<dynamic> newPhoto = [];
    List<dynamic> photo = executionProperty['photo_evidence_after'];
    int counter = executionProperty['photo_after_counter'];

    for (var i = 0; i < photo.length; i++) {
      if (i == counter && photo[i]['img_path'] == null) {
        newPhoto.add({'img_path': image.path, 'img': image});
      } else {
        newPhoto.add(photo[i]);
      }
    }

    setExeItem('photo_after_counter', counter + 1);
    setExeItem('photo_evidence_after', newPhoto);
  }

  saveExecution(data) async {
    var prefs = await SharedPreferences.getInstance();
    data['payload']['id_person'] = prefs.getString("id_user");
    print(data['payload']);

    return Api.saveExecution(data);
  }

  Future<Null> selectDate(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    DateTime firstDay(DateTime dateTime) {
      return dateTime.subtract(Duration(days: dateTime.weekday - 1));
    }

    DateTime lastDay(DateTime dateTime) {
      return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    }

    var ear = firstDay(now);
    var end = lastDay(now);
    
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: ear,
      lastDate: end,
      initialDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      setSelectedDate(picked);
      getUserTasklist({
        'id_user': prefs.getString("id_user"),
        'date': DateFormat("yyyy-MM-dd").format(selectedDate)
      }, context);
    }
  }

  //value
  List<dynamic> _dataTimeline;
  String _EWONumber;
  //getter
  List<dynamic> get dataTimeline => _dataTimeline;
  String get EWONumber => _EWONumber;
  //setter
  setTimeline(List<dynamic> list){
    _dataTimeline = list;
    notifyListeners();
  }
  setEWONumber(String value){
    _EWONumber = value;
    notifyListeners();
  }

  getTimeline(dynamic ewoId, String pm_type) async {
    var request = await Api.getTimeline(ewoId, pm_type);
    print(request['data']);
    print(request['0']['ewo_number']);
    
    setTimeline(request['data']);
    setEWONumber(request['0']['ewo_number']);
  }


}