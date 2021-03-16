import 'dart:io';
import 'package:intl/intl.dart';
import 'package:digi_pm_skin/api/webservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreakdownProvider extends ChangeNotifier {

  String get pm_type => 'PM02';

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
  bool _isNeedSparepart = false;

  double _valueScaleOne = 0;
  double _valueScaleTwo = 0;


  List<dynamic> _masterSbu = [];
  List<dynamic> _masterLine = [];
  List<dynamic> _masterMachine = [];
  List<dynamic> _masterUnit = [];
  List<dynamic> _masterSubUnit = [];
  List<dynamic> _masterActivity = [];

  List<dynamic> _allDataEWO;

  List<dynamic> _masterSparepart;
  List<dynamic> _selectedSparepart = [];

  List<dynamic> _lossTree;

  Map<String, dynamic> _EWODetail;
  List<dynamic> _PhotoSubmission = [null, null, null];
  Map<String, dynamic> _infoDataSeverityNONSHE;

  bool _displayFloatingButtonCamera = false;

  List<Map<String, dynamic>> _dataSubmitted = [];
  List<Map<String, dynamic>> _dataApproved = [];
  List<Map<String, dynamic>> _dataNonReceived = [];
  List<Map<String, dynamic>> _dataReceived = [];
  List<Map<String, dynamic>> _dataPickingSparepart = [];
  List<Map<String, dynamic>> _dataAnalysis = [];
  List<Map<String, dynamic>> _dataBreakdownAction = [];
  List<Map<String, dynamic>> _dataJustification = [];
  List<Map<String, dynamic>> _dataWOApproval = [];


  TextEditingController _problemDescription = TextEditingController();
  TextEditingController _what = TextEditingController();
  TextEditingController _who = TextEditingController();
  TextEditingController _where = TextEditingController();
  TextEditingController _when = TextEditingController();
  TextEditingController _why = TextEditingController();
  TextEditingController _how = TextEditingController();

  List<String> _listQtySparepart = [];

  TextEditingController _qtySparepart0 = TextEditingController();
  TextEditingController _qtySparepart1 = TextEditingController();
  TextEditingController _qtySparepart2 = TextEditingController();
  TextEditingController _qtySparepart3 = TextEditingController();
  TextEditingController _qtySparepart4 = TextEditingController();

  List<Tab> _tabExeCorrective = [
    Tab(text: "Form",),
    Tab(text: "Summary",)
  ];



  Map<String, dynamic> _submissionProperty = {
    'id': null,
    'pm_type': 'PM02',
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

  Map<String, dynamic> _sparepartProperty = {
    'sparepart_list_counter': 0,
    'sparepart_list' : [
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
      {'part_number': null, 'qty': null},
    ]
  };



  Map<String, dynamic> _severityNonSheProperty = {
    'id' : null,
    'ewo_id' : '',
    'severity_id': '',
    'current_date': '',
    'execution_date': '',
    'created_by' : '',
  };

  Map<String, dynamic> _executionCorrectiveProperty = {
    'startExe': null,
    'isStarting': false,
    'hasExecuted': false,
    'txtButton': "Start Execution",
    'counterSecond': 0,
    'secondExeCount': 0,
    'btnColor': Colors.green,
    'bannerResult': null,
    'bannerExe': "00:00",
    'exec_date' : null,
    'finish_date' : null,
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

  //getter
  List<dynamic> get masterSbu => _masterSbu;
  List<dynamic> get masterLine => _masterLine;
  List<dynamic> get masterMachine => _masterMachine;
  List<dynamic> get masterUnit => _masterUnit;
  List<dynamic> get masterSubUnit => _masterSubUnit;
  List<dynamic> get masterActivity => _masterActivity;

  List<dynamic> get masterSparepart => _masterSparepart;
  List<dynamic> get selectedSparepart => _selectedSparepart;

  TextEditingController get problemDescription => _problemDescription;
  TextEditingController get what => _what;
  TextEditingController get who => _who;
  TextEditingController get where => _where;
  TextEditingController get when => _when;
  TextEditingController get why => _why;
  TextEditingController get how => _how;

  List<String> get listQtySparepart => _listQtySparepart;
  TextEditingController get qtySparepart0 => _qtySparepart0;
  TextEditingController get qtySparepart1 => _qtySparepart1;
  TextEditingController get qtySparepart2 => _qtySparepart2;
  TextEditingController get qtySparepart3 => _qtySparepart3;
  TextEditingController get qtySparepart4 => _qtySparepart4;


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

  List<dynamic> get lossTree => _lossTree;
  String get executionDateSeverity => _executionDateSeverity;

  List<String> get namaMenu => _nameMenu;
  List<String> get urlImages => _urlImages;
  List<Color> get colorsCard => _colorCard;
  int get selectedNameMenu => _selectedNameMenu;

  List<dynamic> get allDataEWO => _allDataEWO;
  List<Map<String, dynamic>> get dataSubmitted => _dataSubmitted;
  List<Map<String, dynamic>> get dataApproved => _dataApproved;
  List<Map<String, dynamic>> get dataNonReceived => _dataNonReceived;
  List<Map<String, dynamic>> get dataReceived => _dataReceived;
  List<Map<String, dynamic>> get dataPickingSparepart => _dataPickingSparepart;
  List<Map<String, dynamic>> get dataAnalysis => _dataAnalysis;
  List<Map<String, dynamic>> get dataBreakdownAction => _dataBreakdownAction;
  List<Map<String, dynamic>> get dataJustification => _dataJustification;
  List<Map<String, dynamic>> get dataWOApproval => _dataWOApproval;

  String get valueAutoNumber => _valueAutoNumber;
  bool get isLoading => _isLoading;
  bool get isNeedSparepart => _isNeedSparepart;

  bool get displayFloatingButtonCamera => _displayFloatingButtonCamera;

  Map<String, dynamic> get infoDataSeverityNONSHE => _infoDataSeverityNONSHE;

  Map<String, dynamic> get EWODetail => _EWODetail;
  List<dynamic> get PhotoSubmission => _PhotoSubmission;

  // Map<String, dynamic> get masterSeverity => _masterSeverity;

  double get valueScaleOne => _valueScaleOne;
  double get valueScaleTwo => _valueScaleTwo;

  String get currentDate => _currentDate;

  // TAB
  List<Tab> get tabExeCorrective => _tabExeCorrective;

  //save
  Map<String, dynamic> get submissionProperty => _submissionProperty;
  Map<String, dynamic> get severityNonSheProperty => _severityNonSheProperty;
  Map<String, dynamic> get sparepartProperty => _sparepartProperty;
  Map<String, dynamic> get executionCorrectiveProperty => _executionCorrectiveProperty;


  List<String> _nameMenu = [
    "EWO Breakdown",
    "Technician Call Off",
    "Sparepart Picklist By EWO Number",
    "EWO Breakdown Action",
    "EWO Justification Root Cause",
    "Work Order Approval & Creation"
  ];

  List<String> _urlImages = [
    "assets/icon/submit.png",
    "assets/icon/fitter.png",
    "assets/icon/sparepart.png",
    "assets/icon/create.png",
    "assets/icon/justification.png",
    "assets/icon/approval.png"
  ];

  List<Color> _colorCard = [
    Colors.red.withOpacity(0.7),
    Colors.green.withOpacity(0.7),
    Colors.orange.withOpacity(0.7),
    Colors.deepPurple.withOpacity(0.7),
    Colors.blue.withOpacity(0.7),
    Colors.cyanAccent.withOpacity(0.7)
  ];

// technician assignment

  String _valueFitter;
  List<dynamic> _technicianList = [];
  List<dynamic> _technicianNameByEWO = [];
  List <Map<String, dynamic>> _mapListFitter = [];

  String _selectedPerson1;
  String _selectedPerson2;
  String _selectedPerson3;

  String _departmenPerson1 = "-";
  String _departmenPerson2 = "-";
  String _departmenPerson3 = "-";

  String get departmenPerson1 => _departmenPerson1;
  String get departmenPerson2 => _departmenPerson2;
  String get departmenPerson3 => _departmenPerson3;

  String get valueFitter => _valueFitter;
  String get selectedPerson1 => _selectedPerson1;
  String get selectedPerson2 => _selectedPerson2;
  String get selectedPerson3 => _selectedPerson3;



  List <dynamic> get technicianList => _technicianList;
  List <dynamic> get technicianNameByEWO => _technicianNameByEWO;
  List <Map<String, dynamic>> get mapListFitter => _mapListFitter;

  List<dynamic> _selectedTechnicianList = [];
  List<dynamic> get selectedTechnicianList => _selectedTechnicianList;

  setIsNeedSparepart(bool value){
    _isNeedSparepart = value;
    notifyListeners();
  }

  setSparepartItem(String prop, value, [dynamic question]) {
    _sparepartProperty[prop] = value;
    notifyListeners();
  }

  set resetExeCorrectiveProperty(dynamic reset){
    _executionCorrectiveProperty = reset;
  }

  setExecutionCorrectivePropertyItem(String prop, value) {
      _executionCorrectiveProperty[prop] = value;
    notifyListeners();
  }

  setListQtySparepart(String text){
    _listQtySparepart.add(text);
    notifyListeners();
  }

  setQtySparepart(dynamic value) {
    _qtySparepart1.text = value;
    notifyListeners();
  }

  setSelectedSparepart(dynamic part_number, dynamic qty) async{

    List<dynamic> newSparepart = [];
    List<dynamic> sparepart = sparepartProperty['sparepart_list'];
    int counter = sparepartProperty['sparepart_list_counter'];
    for (var i = 0; i < sparepart.length; i++) {
      if (i == counter && sparepart[i]['part_number'] == null) {
        newSparepart.add({'part_number': part_number, 'qty': qty});
      } else {
        newSparepart.add(sparepart[i]);
      }
    }

    setSparepartItem('sparepart_list_counter', counter + 1);
    setSparepartItem('sparepart_list', newSparepart);

    notifyListeners();
  }

  setSelectedTechnicianList(List<dynamic> list) {
    _selectedTechnicianList = list;
    notifyListeners();
  }

  set setVisibleFloatingButtonCamera(bool status){
    _displayFloatingButtonCamera = status;
    notifyListeners();
  }


  setTechnicianList(List<dynamic> list){
    _technicianList = list;
    notifyListeners();
  }

  List<String> _tes;

  List<String> get tes => _tes;

  setTechnicianByEWO(List<dynamic> list){
    _technicianNameByEWO = list;
    notifyListeners();
  }

  setValuePerson1(String value){
    _selectedPerson1 = value;
    notifyListeners();
  }

  setValuePerson2(String value){
    _selectedPerson2 = value;
    notifyListeners();
  }

  setValuePerson3(String value){
    _selectedPerson3 = value;
    notifyListeners();
  }
  setDepartmen1(String value) async {
    var response =  await Api.getDepartment(value);
    _departmenPerson1 = response[0]['department_name'];
    notifyListeners();
  }

  setDepartmen2(String value) async {
    var response =  await Api.getDepartment(value);
    _departmenPerson2 = response[0]['department_name'];
    notifyListeners();
  }

  setDepartmen3(String value) async {
    var response =  await Api.getDepartment(value);
    _departmenPerson3 = response[0]['department_name'];
    notifyListeners();
  }

  getTechnicianByDepartment(String sbu) async {
    var response = await Api.getFitterByDepartment(sbu);
    setTechnicianList(response);
  }

  getTechnicianAssignmentByEWO(String ewoId) async {
    var response = await Api.getTechnicianAssignmentByEWO(ewoId);
    setTechnicianByEWO(response);
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

      if (element['pm_type'] == 'PM02' && element['APPROVED_PM02'] == null && element['TECHNICIAN_ASSIGNMENT_PM02'] == null) {
        return _dataSubmitted.add(element);
      }

      if (element['pm_type'] == 'PM02' && element['TECHNICIAN_RECEIVED_PM02'] == null){
        _dataApproved.add(element);
        _dataNonReceived.add(element);
        return;
      }

      if (element['pm_type'] == 'PM02' && element['ANALYSIS_PM02'] == null) {
        return _dataReceived.add(element);
      }

      if (element['pm_type'] == 'PM02' && element['IS_NEED_SPARE_PART_PM02'] == '1' && element['BREAKDOWN_ACTION_PM02'] == null){
        _dataPickingSparepart.add(element);
        _dataBreakdownAction.add(element);
        return;
      }

      if (element['pm_type'] == 'PM02' && element['BREAKDOWN_ACTION_PM02'] == null) {
        _dataBreakdownAction.add(element);
        return;
      }

      if (element['pm_type'] == 'PM02' && element['BREAKDOWN_ACTION_PM02'] != null && element['JUSTIFICATION_PM02'] == null) {
        return _dataJustification.add(element);
      }

      if(element['pm_type'] == 'PM02' && element['JUSTIFICATION_PM02'] != null && element['WO_APPROVAL_PM02'] == null && element['IS_NEED_SPARE_PART_PM02'] != null) {
        return _dataWOApproval.add(element);
      }

    });
    notifyListeners();
  }


  setSparepart(List<dynamic> list){
    _masterSparepart = list;
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

  getACTIVITY() async {
    var response = await Api.getActivity('PM02');
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

  getImageBefore() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<dynamic> newPhoto = [];
    List<dynamic> photo = executionCorrectiveProperty['photo_evidence_before'];
    int counter = executionCorrectiveProperty['photo_before_counter'];
    for(var i = 0; i < photo.length; i++){
      if(i == counter && photo[i]['img_path'] == null){
        newPhoto.add({'img_path' : image.path, 'img' : image});
      } else {
        newPhoto.add(photo[i]);
      }
    }

    setExecutionCorrectivePropertyItem('photo_before_counter', counter + 1);
    setExecutionCorrectivePropertyItem('photo_evidence_before', newPhoto);
  }

  getImageAfter() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<dynamic> newPhoto = [];
    List<dynamic> photo = executionCorrectiveProperty['photo_evidence_after'];
    int counter = executionCorrectiveProperty['photo_after_counter'];

    for (var i= 0; i < photo.length; i++ ) {
      if(i == counter && photo[i]['img_path'] == null){
        newPhoto.add({'img_path' : image.path, 'img' : image});
      } else {
        newPhoto.add(photo[i]);
      }
    }

    setExecutionCorrectivePropertyItem('photo_after_counter', counter + 1);
    setExecutionCorrectivePropertyItem('photo_evidence_after', newPhoto);

  }

  //void for general
  getEWO(context, pm_type, [String ewoId]) async {
    if(_allDataEWO != null){
      _allDataEWO.clear();
      _dataSubmitted.clear();
      _dataApproved.clear();
      _dataNonReceived.clear();
      _dataReceived.clear();
      _dataPickingSparepart.clear();
      _dataAnalysis.clear();
      _dataBreakdownAction.clear();
      _dataJustification.clear();
      _dataWOApproval.clear();

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
                  },
                  child: new Text('Reload'))
            ],
          ))
          ?? false;
    }
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

  getMasterSparepart(String sbu, String line, String machine, String unit, String subUnit) async {
    var response = await Api.bangsatttt(sbu, line, machine, unit, subUnit);
    print(response);
    setSparepart(response);
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

  setLostTree(List<dynamic> list) {
    _lossTree = list;
    notifyListeners();
  }

//  SAVE
  saveFormBreakdown(data) async {
    return Api.saveSubmission(data);
  }

  deleteFormBreakdown(id) async {
    return Api.deleteSubmission(id);
  }


  saveApproved(data) async {
    return Api.saveBreakdownApproved(data);
  }

  saveReceived(data) async {
    return Api.saveReceivedBreakdown(data);
  }

  isAnalyst(ewoId, status) async {
    return Api.isAnalyst(ewoId, status);
  }

  saveConfirmation(data) async {
    return Api.saveConfirmationBreakdown(data);
  }

  saveAnalysis(data, _storedImage) async {
    return Api.saveAnalysisBreakdown(data, _storedImage);
  }

  saveExeCorrective(data) async {
    return Api.saveExeCorrective(data);
  }

  saveJustification(data) async {
    return Api.saveJustificationBreakdown(data);
  }

  saveWOApproval(data) async {
    return Api.saveWOApproval(data);
  }


}
