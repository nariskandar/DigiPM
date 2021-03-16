import 'dart:io';
import 'package:intl/intl.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbnormalityProvider extends ChangeNotifier {

  //type_data
  int _selectedNameMenu;
  dynamic _valueSbu,
      _valueLine,
      _valueMachine,
      _valueUnit,
      _valueSubUnit,
      _valueActivity,
      _valuePillarPIC,
      _valuePMATDescription,
      _valueKerusakan,
      _valuePerbaikan;
  String _generateEWO;
  String _valueAutoNumber;
  String _executionDateSeverity;
  String _currentDate;
  bool _isLoading = false;

  double _valueScaleOne = 0;
  double _valueScaleTwo = 0;


  List<dynamic> _masterSbu = [];
  List<dynamic> _masterLine = [];
  List<dynamic> _masterMachine = [];
  List<dynamic> _masterUnit = [];
  List<dynamic> _masterSubUnit = [];
  List<dynamic> _masterActivity = [];

  List<dynamic> _allDataEWO;

  Map<String, dynamic> _EWODetail;
  List<dynamic> _PhotoSubmission = [null, null, null];
  Map<String, dynamic> _infoDataSeverityNONSHE;

  List<Map<String, dynamic>> _dataSubmitted = [];
  List<Map<String, dynamic>> _dataApproved = [];
  List<Map<String, dynamic>> _dataSeverity = [];
  List<Map<String, dynamic>> _dataAnalysis = [];
  List<Map<String, dynamic>> _dataJustification = [];
  List<Map<String, dynamic>> _dataWOCreation = [];

  TextEditingController _problemDescription = TextEditingController();
  TextEditingController _what = TextEditingController();
  TextEditingController _who = TextEditingController();
  TextEditingController _where = TextEditingController();
  TextEditingController _when = TextEditingController();
  TextEditingController _why = TextEditingController();
  TextEditingController _how = TextEditingController();

  Map<String, dynamic> _submissionProperty = {
    'id': 'null',
    'pm_type': 'PM03',
    'ewo_number': '',
    'sbu': '',
    'line': '',
    'machine': '',
    'equipment': '',
    'sub_unit': '',
    'type_problem': '',
    'type_activity': '',
    'problem_description': '',
    'pm_activity_type': '',
    'related_to': '',
    'created_by': '',
    'approve_by': '',
    'approve_at': '',
    'receive_by': '',
    'receive_at': '',
    'max_photo': 3,
    'photo': [],
    'photo_submission': [
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null},
      {'img_path': null, 'img': null}
    ],
    'photo_submission_counter': 0,
    'question': {
      'WHAT': '',
      'WHO': '',
      'WHERE': '',
      'WHEN': '',
      'WHY': '',
      'HOW': ''
    }
  };

  Map<String, dynamic> _severityNonSheProperty = {
    'id' : null,
    'ewo_id' : '',
    'severity_id': '',
    'current_date': '',
    'execution_date': '',
    'created_by' : '',
  };

  //getter
  List<dynamic> get masterSbu => _masterSbu;
  List<dynamic> get masterLine => _masterLine;
  List<dynamic> get masterMachine => _masterMachine;
  List<dynamic> get masterUnit => _masterUnit;
  List<dynamic> get masterSubUnit => _masterSubUnit;
  List<dynamic> get masterActivity => _masterActivity;

  TextEditingController get problemDescription => _problemDescription;
  TextEditingController get what => _what;
  TextEditingController get who => _who;
  TextEditingController get where => _where;
  TextEditingController get when => _when;
  TextEditingController get why => _why;
  TextEditingController get how => _how;

  String get valueSbu => _valueSbu;
  String get valueLine => _valueLine;
  String get valueMachine => _valueMachine;
  String get valueUnit => _valueUnit;
  String get valueSubUnit => _valueSubUnit;
  String get valueKerusakan => _valueKerusakan;
  String get valuePerbaikan => _valuePerbaikan;
  String get valueActivity => _valueActivity;
  String get valuePillarPIC => _valuePillarPIC;
  String get valuePMATDescription => _valuePMATDescription;
  String get executionDateSeverity => _executionDateSeverity;

  List<String> get namaMenu => _nameMenu;
  List<String> get urlImages => _urlImages;
  List<Color> get colorsCard => _colorCard;
  int get selectedNameMenu => _selectedNameMenu;
  List<dynamic> get allDataEWO => _allDataEWO;
  List<Map<String, dynamic>> get dataSubmitted => _dataSubmitted;
  List<Map<String, dynamic>> get dataApproved => _dataApproved;
  List<Map<String, dynamic>> get dataSeverity => _dataSeverity;
  List<Map<String, dynamic>> get dataAnalysis => _dataAnalysis;
  List<Map<String, dynamic>> get dataJustification => _dataJustification;
  List<Map<String, dynamic>> get dataWOCreation => _dataWOCreation;
  String get valueAutoNumber => _valueAutoNumber;
  bool get isLoading => _isLoading;

  Map<String, dynamic> get infoDataSeverityNONSHE => _infoDataSeverityNONSHE;

  Map<String, dynamic> get EWODetail => _EWODetail;
  List<dynamic> get PhotoSubmission => _PhotoSubmission;

  bool _isEditPhoto = false;
  bool get isEditPhoto => _isEditPhoto;

  // Map<String, dynamic> get masterSeverity => _masterSeverity;

  double get valueScaleOne => _valueScaleOne;
  double get valueScaleTwo => _valueScaleTwo;

  String get currentDate => _currentDate;

  //save
  Map<String, dynamic> get submissionProperty => _submissionProperty;
  Map<String, dynamic> get severityNonSheProperty => _severityNonSheProperty;

  //menu
  List<String> _nameMenu = [
    "Abnormality Submissions",
    "EWO Severity Ratings",
    "EWO Analysis",
    "EWO Root Cause Justification",
    "WO Creation"
  ];

  List<String> _urlImages = [
    "assets/icon/submit.png",
    "assets/icon/rate.png",
    "assets/icon/justification.png",
    "assets/icon/infographic.png",
    "assets/icon/create.png"
  ];

  List<Color> _colorCard = [
    Colors.red.withOpacity(0.7),
    Colors.green.withOpacity(0.7),
    Colors.orange.withOpacity(0.7),
    Colors.deepPurple.withOpacity(0.7),
    Colors.blue.withOpacity(0.7)
  ];

  set nameMenuIndex(int index) {
    _selectedNameMenu = index;
    notifyListeners();
  }

  setSubmissionItem(String prop, value, [dynamic question]) {
    if (question != null) {
      _submissionProperty[question][prop] = value;
    } else {
      _submissionProperty[prop] = value;
    }
    notifyListeners();
  }

  setLoadingState(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  //setter for submission
  setDataSBU(List<dynamic> list) {
    _masterSbu = list;
    notifyListeners();
  }

  setDataLINE(List<dynamic> list) {
    _masterLine = list;
    notifyListeners();
  }

  setDataMACHINE(List<dynamic> list) {
    _masterMachine = list;
    notifyListeners();
  }

  setDataUNIT(List<dynamic> list) {
    _masterUnit = list;
    notifyListeners();
  }

  setDataSUB_UNIT(List<dynamic> list) {
    _masterSubUnit = list;
    notifyListeners();
  }

  setDataACTIVITY(List<dynamic> list) {
    _masterActivity = list;
    notifyListeners();
  }

  setDataAUTO_NUMBER(String value) {
    _valueAutoNumber = value;
    notifyListeners();
  }

  setValueSbu(dynamic value) {
    setSubmissionItem('sbu', value);
    _valueSbu = value;
    notifyListeners();
  }

  setValueLine(dynamic value) {
    setSubmissionItem('line', value);
    _valueLine = value;
    notifyListeners();
  }

  setValueMachine(dynamic value) {
    setSubmissionItem('machine', value);
    _valueMachine = value;
    notifyListeners();
  }

  setValueUnit(dynamic value) {
    setSubmissionItem('equipment', value);
    _valueUnit = value;
    notifyListeners();
  }

  setValueSubUnit(dynamic value) {
    setSubmissionItem('sub_unit', value);
    _valueSubUnit = value;
    notifyListeners();
  }

  setValueKerusakan(dynamic value) {
    setSubmissionItem('type_problem', value);
    _valueKerusakan = value;
    notifyListeners();
  }

  setValuePerbaikan(dynamic value) {
    setSubmissionItem('type_activity', value);
    _valuePerbaikan = value;
    notifyListeners();
  }

  setValueActivity(dynamic value) {
    _valueActivity = value;
    notifyListeners();
  }

  setDataPILLAR_PIC(dynamic value) {
    setSubmissionItem('related_to', value);
    _valuePillarPIC = value;
    notifyListeners();
  }

  setDataPMAT_DESCRIPTION(dynamic value) {
    setSubmissionItem('pm_activity_type', value);
    _valuePMATDescription = value;
    notifyListeners();
  }

  setDataProblemDescription(dynamic value) {
    setSubmissionItem('problem_description', value);
    _problemDescription.text = value;
    notifyListeners();
  }

  setDataAnswerWhat(dynamic value) {
    setSubmissionItem('WHAT', '', 'question');
    what.text = value;
    notifyListeners();
  }

  setDataAnswerWho(dynamic value) {
    setSubmissionItem('WHO', '', 'question');
    who.text = value;
    notifyListeners();
  }

  setDataAnswerWhere(dynamic value) {
    setSubmissionItem('WHERE', '', 'question');
    where.text = value;
    notifyListeners();
  }

  setDataAnswerWhen(dynamic value) {
    setSubmissionItem('WHEN', '', 'question');
    when.text = value;
    notifyListeners();
  }

  setDataAnswerWhy(dynamic value) {
    setSubmissionItem('WHY', '', 'question');
    why.text = value;
    notifyListeners();
  }

  setDataAnswerHow(dynamic value) {
    setSubmissionItem('HOW', '', 'question');
    how.text = value;
    notifyListeners();
  }

  setValueScaleOne(dynamic value) {
    // setSubmissionItem('sbu', value);
    _valueScaleOne = value;
    notifyListeners();
  }

  setValueScaleTwo(dynamic value){
    _valueScaleTwo = value;
    notifyListeners();
  }

  setInfoDataSeverityNONSHE(Map<String, dynamic> list) {
    _infoDataSeverityNONSHE = list;

    setExecuteSeverityDate(_infoDataSeverityNONSHE['days']);
    notifyListeners();
  }

  setExecuteSeverityDate (dynamic days){
    final now = new DateTime.now();
    var day = int.parse(days);
    var execute = new DateTime(now.year, now.month, now.day + day);

    _executionDateSeverity = DateFormat('yyyy-MM-dd').format(execute);
  }

  setCurrentDate(){
    final now = new DateTime.now();
    _currentDate = DateFormat('yyyy-MM-dd').format(now);
  }


      setQuestionSubmission(String value) {
    switch (value) {
      case 'WHAT':
        setSubmissionItem('WHAT', _what.text, 'question');
        return _what;
      case 'WHO':
        setSubmissionItem('WHO', _who.text, 'question');
        return _who;
      case 'WHERE':
        setSubmissionItem('WHERE', _where.text, 'question');
        return _where;
      case 'WHEN':
        setSubmissionItem('WHEN', _when.text, 'question');
        return _when;
      case 'WHY':
        setSubmissionItem('WHY', _why.text, 'question');
        return _why;
      case 'HOW':
        setSubmissionItem('HOW', _how.text, 'question');
        return _how;
      default:
        return null;
    }
  }

  setValueWhat(String value) {
    _valueSbu = value;
    notifyListeners();
  }

  setEWODetail(Map<String, dynamic> list) {
    _EWODetail = list;
    notifyListeners();
  }

  setPhotoSubmission(List<dynamic> list){

    _PhotoSubmission = list;
    notifyListeners();
  }

  setEWOStep(List<dynamic> list) {
    _allDataEWO = list;
    _allDataEWO.forEach((element) {
      if (element['pm_type'] == 'PM03' && element['APPROVED_PM03'] == null) {
        return _dataSubmitted.add(element);
      }

      //approved
      if (element['pm_type'] == 'PM03' && element['SEVERITY_PM03'] == null) {
       _dataApproved.add(element);
       _dataSeverity.add(element);
        return;
      }

      //analysis
      if (element['pm_type'] == 'PM03' && element['ANALYSIS_PM03'] == null) {
        return _dataAnalysis.add(element);
      }

      //justification
      if (element['pm_type'] == 'PM03' && element['JUSTIFICATION_PM03'] == null) {

        return _dataJustification.add(element);
      }

      //creation
      if (element['pm_type'] == 'PM03'  && element['WO_CREATION_PM03'] != null) {
        return _dataWOCreation.add(element);
      }

    });
    notifyListeners();
  }

  setGenerateEWO(String generateEWO) {
    setSubmissionItem('ewo_number', generateEWO);
    _generateEWO = generateEWO;
    notifyListeners();
  }

  //void for submission
  getSBU() async {
    var response = await Api.getSbu();
    setDataSBU(response);
  }

  getLINE(String sbu) async {
    var response = await Api.getLine(sbu);
    setDataLINE(response);
  }

  getMACHINE(String sbu, String line) async {
    var response = await Api.getMachine(sbu, line);
    setDataMACHINE(response);
  }

  getUNIT(String sbu, String line, String machine) async {
    var response = await Api.getUnit(sbu, line, machine);
    setDataUNIT(response);
  }

  getSUB_UNIT(String sbu, String line, String machine, String unit) async {
    var response = await Api.getSubUnit(sbu, line, machine, unit);
    setDataSUB_UNIT(response);
  }

  getACTIVITY(order_type, [pmat_description]) async {
    var response = await Api.getActivity(order_type, pmat_description);
    if(pmat_description != null){
      setValueActivity(response[0]['id']);
    }
    setDataACTIVITY(response);
  }

  getPILLAR(String id) async {
    var response = await Api.getPillar(id);

    setDataPILLAR_PIC(response[0]['pillar_pic']);
    setDataPMAT_DESCRIPTION(response[0]['pmat_description']);
  }


  getDataSeverity(dynamic scale_one, dynamic scale_two, String type) async {
    var response = await Api.getDataSeverity(scale_one, scale_two, type);
    setInfoDataSeverityNONSHE(response[0]);
  }


  getAutoNumber() async {
    var response = await Api.getAutoNumber();
    setDataAUTO_NUMBER(response);
  }

  //void for general
  getEWO(context, pm_type, [String ewoId]) async {
    if(_allDataEWO != null){
      _allDataEWO.clear();
      _dataSubmitted.clear();
      _dataApproved.clear();
      _dataSeverity.clear();
      _dataAnalysis.clear();
      _dataJustification.clear();
      _dataWOCreation.clear();
      notifyListeners();
    }
    setLoadingState(true);
    try {
      var allDataEWO = await Api.getDataEwoList(pm_type);
      setEWOStep(allDataEWO);
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
                    // getUserTasklist(data, context);
                  },
                  child: new Text('Reload'))
            ],
          ))
          ?? false;
    }
    // var response = await Api.getDataEwoList(pm_type, ewoId);
    // setEWOUser(response);
  }

  getEarlyQuestion(String ewoId) async {
    var response = await Api.getEarlyQuestion(ewoId);
    setDataAnswerWhat(response[0]['answer']);
    setDataAnswerWho(response[1]['answer']);
    setDataAnswerWhere(response[2]['answer']);
    setDataAnswerWhen(response[3]['answer']);
    setDataAnswerWhy(response[4]['answer']);
    setDataAnswerHow(response[5]['answer']);
  }


  getEWODetail(pm_type, String ewoId) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Api.getDataEwoList(pm_type, ewoId);
    setEWODetail(response['data'][0]);
    setPhotoSubmission(response['photo']);
  }


  getPhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<dynamic> newPhoto = [];
    List<dynamic> photo = submissionProperty['photo_submission'];
    int counter = submissionProperty['photo_submission_counter'];
    for (var i = 0; i < photo.length; i++) {
      if (i == counter && photo[i]['img_path'] == null) {
        newPhoto.add({'img_path': image.path, 'img': image});
      } else {
        newPhoto.add(photo[i]);
      }
    }

    setSubmissionItem('photo_submission_counter', counter + 1);
    setSubmissionItem('photo_submission', newPhoto);
  }



//  SAVE
  saveFormAbnormality(data) async {
    return Api.saveSubmission(data);
  }

  deleteFormAbnormality(id) async {
    return Api.deleteSubmission(id);
  }

  saveSeverity(data) async {
    return Api.saveSeverity(data);
  }

  saveAnalysis(data, _storedImage) async{
    return Api.saveAnalysisAbnormality(data, _storedImage);
  }


  saveApproved(data) async {
    return Api.saveAbnormalityApproved(data);
  }

  saveSeverityNonShe(data) async {
    return Api.saveSeverity(data);
  }
}
