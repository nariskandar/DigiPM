import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:digi_pm_skin/api/endpoint.dart';
import 'package:http/http.dart' as http;

class Api {
  static const BASE_URL = Endpoint.BASE_URL_LOCAL;
  static const BASE_URL_PIC_PROFILE =
      Endpoint.BASE_URL_LOCAL + "/assets/img/profile_pic";
  static const BASE_URL_PIC_EXE =
      Endpoint.BASE_URL_LOCAL + "/assets/img/img_execution/";
  static const BASE_URL_PM03 = Endpoint.BASE_URL_LOCAL + "/assets/img/abnormality/";
  static const BASE_URL_RAW = Endpoint.BASE_URL_LOCAL;
  // static const BASE_URL_PIC_PM03 = Endpoint.BASE_URL_LOCAL + "assets/img//"
  static const PORT = Endpoint.BASE_URL_MULTI_PORT;
  static const ENV = "dev";
  static const SERVER = "localhost";

  static Future<List<dynamic>> getUserTasklist(data) async {
    final response =
    await http.post("$BASE_URL/assignment/get_user_assignment", body: data);
    return json.decode(response.body);
  }

  static Future<dynamic> setConfirmTasklist(idAssignment, idExecution) async {
    try {
      final response = await http
          .post(
          "$BASE_URL/assignment/set_confirm_assignment/$idAssignment/$idExecution")
          .timeout(new Duration(seconds: 240));
      return json.decode(response.body);
    } on TimeoutException catch (_) {
      return "timeout";
    } on SocketException catch (_) {
      return "offline";
    } on FormatException catch (_) {
      return "offline";
    } on Exception catch (_) {
      return "offline";
    }
  }

  static Future<dynamic> setUnConfirmTasklist(idAssignment) async {
    final response = await http
        .post("$BASE_URL/assignment/set_unconfirm_assignment/$idAssignment");
    return json.decode(response.body);
  }

  static Future<List<dynamic>> getTasklistExe(idAssignment) async {
    final response =
    await http.post("$BASE_URL/assignment/get_single_exec/$idAssignment");
    return json.decode(response.body);
  }

  static Future<dynamic> asyncFileUpload(String id, File file) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(BASE_URL + "/api/upload_profile_pic"));
    var pic = await http.MultipartFile.fromPath("pic", file.path);
    request.files.add(pic);
    request.fields["id_user"] = id;
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return responseString;
  }


  static Future<dynamic> saveExecutionOld(data) async {
    final response = await http.post("$BASE_URL/api/save_execution",
        body: {'payload': json.encode(data)});
    return json.decode(response.body);
  }

  static Future<dynamic> saveExecution(data) async {
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("$BASE_URL/api/save_execution_with_foto"));

      if (data['before'][0]['img_path'] != null) {
        var picBefore0 = await http.MultipartFile.fromPath(
            "pic_before0", data['before'][0]['img_path'].toString());

        request.files.add(picBefore0);
      }

      if (data['before'][1]['img_path'] != null) {
        var picBefore1 = await http.MultipartFile.fromPath(
            "pic_before1", data['before'][1]['img_path'].toString());

        request.files.add(picBefore1);
      }

      if (data['before'][2]['img_path'] != null) {
        var picBefore2 = await http.MultipartFile.fromPath(
            "pic_before2", data['before'][2]['img_path'].toString());

        request.files.add(picBefore2);
      }

      if (data['after'][0]['img_path'] != null) {
        var picAfter0 = await http.MultipartFile.fromPath(
            "pic_after0", data['after'][0]['img_path'].toString());

        request.files.add(picAfter0);
      }

      if (data['after'][1]['img_path'] != null) {
        var picAfter1 = await http.MultipartFile.fromPath(
            "pic_after1", data['after'][1]['img_path'].toString());

        request.files.add(picAfter1);
      }

      if (data['after'][2]['img_path'] != null) {
        var picAfter2 = await http.MultipartFile.fromPath(
            "pic_after2", data['after'][2]['img_path'].toString());

        request.files.add(picAfter2);
      }

      request.fields["payload"] = json.encode(data['payload']);
      var response = await request.send().timeout(new Duration(seconds: 240));
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      //debugPrint(responseString);
      return responseString;

    } on TimeoutException catch (_) {
      return "timeout";
    } on SocketException catch (_) {
      return "offline";
    } on FormatException catch (_) {
      return "offline";
    } on Exception catch (_) {
      return "offline";
    }
  }

  static Future<dynamic> saveAnalysisAbnormality(data, [File file]) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("$BASE_URL/abnormality/save_analysis"));

    if(file != null ){
      var picture = await http.MultipartFile.fromPath("picture", file.path);
      request.files.add(picture);
    }

    request.fields["payload"] = json.encode(data);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return responseString;
  }

  static Future<dynamic> isAnalyst(ewoId, status) async {
    var response = await http.post("$BASE_URL/breakdown/isAnalyst?ewoId=$ewoId&status=$status");
    return json.decode(response.body);
  }

  static Future<dynamic> saveAnalysisBreakdown(data, [File file]) async {
    var request = http.MultipartRequest("POST", Uri.parse("$BASE_URL/breakdown/save_analysis"));

    if(file != null){
      var picture = await http.MultipartFile.fromPath("picture", file.path);
      request.files.add(picture);
    }

    request.fields["payload"] = json.encode(data);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return responseString;
  }
  
  static Future<dynamic> saveSeverity(data) async{
    var request = await http.post("$BASE_URL/abnormality/save_severity",
        body: {'payload' : json.encode(data)});
    return json.decode(request.body);
  }

  static Future<dynamic> saveWoCreation(data) async {
    var request = await http.post("$BASE_URL/abnormality/save_wo_creation",
        body: {'payload' : json.encode(data)});
    return json.decode(request.body);
  }

  static Future<dynamic> rejectWoCreation(data) async {
    var request = await http.post("$BASE_URL/abnormality/rejected_wo_creation",
        body: {'payload' : json.encode(data)});
    return json.decode(request.body);
  }

  static Future<dynamic> saveJustification(data) async {
    var request = await http.post("$BASE_URL/abnormality/save_justification",
        body: {'payload' : json.encode(data)});
    return json.decode(request.body);
  }


  static Future<dynamic> saveBreakdownAnalysis(data) async {
    final response = await http.post("$BASE_URL/breakdown/save_analysis",
    body: {'payload' : json.decode(data)});
    return json.decode(response.body);
  }

  static Future<dynamic> getUserlogin(id) async {
    final response = await http.post("$BASE_URL/user/get_single_user/$id");
    print(response);
    return json.decode(response.body);
  }

  static Future<dynamic> getFitterByDepartment(String sbu) async {
    final response = await http.get("$BASE_URL/Breakdown/getFitterByDepartment?sbu=$sbu");
    return json.decode(response.body);
  }

  static Future<dynamic> getDepartment(String id_user) async {
    final response = await http.get("$BASE_URL/Breakdown/getDepartment?id_user=$id_user");
    return json.decode(response.body);
  }

  static Future<dynamic> getViewSeverity(severityId) async {
    final response = await http.get("$BASE_URL/abnormality/getViewSeverity?severityId=$severityId");
    return json.decode(response.body);
  }

  static Future<dynamic> getViewAnalysis(ewoId) async {
    final response = await http.get("$BASE_URL/abnormality/getViewAnalysis?ewoId=$ewoId");
    return json.decode(response.body);
  }

  static Future<dynamic> getViewJustification(ewoId) async {
    final response = await http.get("$BASE_URL/abnormality/getViewJustification?ewoId=$ewoId");
    return json.decode(response.body);
  }

  static Future<dynamic> getViewSparepart(ewoId) async {
    final response = await http.get("$BASE_URL/abnormality/getViewSparepart?ewoId=$ewoId");
    return json.decode(response.body);
  }

  static Future<dynamic> getViewSparepartPM02(ewoId) async {
    final response = await http.get("$BASE_URL/data/getViewSparepartPM02?ewoId=$ewoId");
    return json.decode(response.body);
  }

  static Future<dynamic> getViewCorrectiveAction(ewoId) async {
    final response = await http.get("$BASE_URL/breakdown/getViewCorrectiveAction?ewoId=$ewoId");
    return json.decode(response.body);
  }





  static Future<dynamic> getJustification([String level1, String level2, String suggestion]) async {

    if (level1 != null && level2 == null && suggestion == null) {
      final response = await http.get("$BASE_URL/abnormality/get_justification?level_1=$level1");
      return json.decode(response.body);
    }
    if (level1 != null && level2 != null && suggestion == null) {
      final response = await http.get("$BASE_URL/abnormality/get_justification?level_1=$level1&level_2=$level2");
      return json.decode(response.body);
    }

    if(level1 != null && level2 != null && suggestion != null){
      final response = await http.get("$BASE_URL/abnormality/get_justification?level_1=$level1&level_2=$level2&suggestion=$suggestion");
      return json.decode(response.body);
    }

    if (level1 == null && level2 == null && suggestion == null){
      final response = await http.get("$BASE_URL/abnormality/get_justification");
      return json.decode(response.body);
    }

  }

  static Future<dynamic> getAllUser() async {
    final response = await http.get("$BASE_URL/data/getUser");
    return json.decode(response.body);
  }

  static Future<dynamic> getDataSeverity(double scale_one, double scale_two, String type) async {
    final response = await http.post("$BASE_URL/abnormality/getDataSeverity?scale_one=$scale_one&scale_two=$scale_two&type=$type");
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> login(data) async {
    final response =
    await http.post("$BASE_URL/login/proses_login", body: data);
    return json.decode(response.body);
  }

  static Future<List<dynamic>> getSpvOtif(
      idLineManager, String selectedWeek) async {
    final response = await http
        .post("$BASE_URL/api/get_otif_supervisor/$idLineManager/$selectedWeek");
    return json.decode(response.body);
  }

  static Future<List<dynamic>> getLostTree() async {
    final response = await http.get("$BASE_URL/api/get_lost_tree");
    return json.decode(response.body);
  }

  static Future<dynamic> saveRating(data) async {
    final response = await http.post("$BASE_URL/api/save_rating", body: data);
    return json.decode(response.body);
  }

  static Future<dynamic> saveDelegation(data) async {
    final response =
    await http.post("$BASE_URL/api/save_delegation", body: data);
    return json.decode(response.body);
  }

  static Future<List<dynamic>> getWeeklySupervisor(data) async {
    final response = await http
        .post("$BASE_URL/api/get_supervisor_tasklist_week", body: data);
    return json.decode(response.body);
  }

  static Future<dynamic> savePendingTasklist(data) async {
    final response = await http.post("$BASE_URL/api/set_pending",
        body: {'payload': json.encode(data)});
    return json.decode(response.body);
  }

  static Future<List<dynamic>> getDailySupervisor(data) async {
    final response = await http
        .post("$BASE_URL/api/get_supervisor_tasklist_day", body: data);
    return json.decode(response.body);
  }

  static Future<List<dynamic>> getSupervisorTechnician(data) async {
    final response = await http
        .post("$BASE_URL/api/get_person_under_technician", body: data);
    return json.decode(response.body);
  }

  static Future<void> showCustomDialog(ctx, title, message, callback) {
    return showDialog(
      context: ctx,
      builder: (context) => new AlertDialog(
        title: new Text(title),
        content: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 20),
            child: Text(message)),
        actions: <Widget>[
          new FlatButton(
            onPressed: callback,
            child: new Text('Close'),
          ),
        ],
      ),
    );
  }

  static Future<dynamic> saveSupervisorRating(otif) async {
    final response = await http.post("$BASE_URL/api/save_rating_spv",
        body: {'rating': json.encode(otif)});
    return json.decode(response.body);
  }


// DIGIPM PHASE 2 ----------------------------------------------------- //

  // ------------------- GET DATA

  // Auto Number For EWO Number
  static Future<dynamic> getAutoNumber() async {
    final response = await http.get("$BASE_URL/api/getAutoNumber");
    return response.body;
  }

  // Master SBU
  static Future<dynamic> getSbu() async {
    final response = await http.post("$BASE_URL/api/getSbuByTasklist");
    return json.decode(response.body);
  }

  // Master Line
  static Future<dynamic> getLine(sbu) async {
    final response = await http.post("$BASE_URL/api/getLine?sbu=$sbu");
    return json.decode(response.body);
  }

  // Master Machine
  static Future<dynamic> getMachine(sbu, line) async {
    final response = await http.post("$BASE_URL/api/getMachine?sbu=$sbu&line=$line");
    return json.decode(response.body);
  }

  // Master Unit
  static Future<dynamic> getUnit(sbu,line, machine) async {
    final response = await http.post("$BASE_URL/api/getUnit?sbu=$sbu&line=$line&machine=$machine");
    return json.decode(response.body);
  }

  // Master Sub Unit
  static Future<dynamic> getSubUnit(sbu, line, machine, unit) async {
    final response = await http.post("$BASE_URL/api/getSub?sbu=$sbu&line=$line&machine=$machine&unit=$unit");
    return json.decode(response.body);
  }

  // Master Activity Type
  static Future<dynamic> getActivity(String order_type, [String pmat_description]) async {
    if (pmat_description != null){
      final response = await http.get("$BASE_URL/api/getActivityType?order_type=$order_type&pmat_description=$pmat_description");
      print(response);
      return json.decode(response.body);
    } else {
      final response = await http.get("$BASE_URL/api/getActivityType?order_type=$order_type");
      return json.decode(response.body);
    }
  }

  // Data Jawaban 5W+1H
  static Future<dynamic> getEarlyQuestion(ewoId) async {
    final response = await http.get("$BASE_URL/api/getEarlyQuestion?ewoId=$ewoId");
    return json.decode(response.body);
  }

  // Ambil Data Pillar
  static Future<dynamic> getPillar(id) async {
    final response = await http.post("$BASE_URL/api/getPillar?id=$id");
    return json.decode(response.body);
  }


  // Timeline by Step
  static Future<dynamic> bangsatttt(String sbu, String line, String machine, String unit, String subUnit) async {
    final request = await http.get("$BASE_URL/api/get_sparepart_picklist?sbu=$sbu&line=$line&machine=$machine&unit=$unit&sub_unit=$subUnit");
    return json.decode(request.body);
  }

  // Timeline by Step
  static Future<dynamic> getTimeline(ewoId, pm_type) async {
    final request = await http.get("$BASE_URL/api/getTimeline?ewoId=$ewoId&pm_type=$pm_type");
    return json.decode(request.body);
  }

  // AMBIL SEMUA DATA EWO
  static Future<dynamic> getDataEwoList(String pm_type, [ewoId]) async {

    if (ewoId != null){
      final response = await http.get("$BASE_URL/api/getDataEwoList?pm_type=$pm_type&ewoId=$ewoId");
      return json.decode(response.body);
    } else {
      final response = await http.get("$BASE_URL/api/getDataEwoList?pm_type=$pm_type");
      return json.decode(response.body);
    }

  }

  // Ambil Data
  static Future<dynamic> getTechnicianAssignmentByEWO(String ewoId) async {
    final response = await http.get("$BASE_URL/api/getTechnicianByEWO?ewo_id=$ewoId");
    return json.decode(response.body);
  }

  // ------------------- SAVE

  // Save Submission
  static Future<dynamic> saveSubmission(data) async {

    try {
      var request = http.MultipartRequest("POST", Uri.parse("$BASE_URL/api/save_submission"));

      if(data['photo'][0]['img_path'] != null) {
        var photo0 = await http.MultipartFile.fromPath(
            "photo0", data['photo'][0]['img_path'].toString());
        request.files.add(photo0);
      }

      if(data['photo'][1]['img_path'] != null) {
        var photo1 = await http.MultipartFile.fromPath(
            "photo1", data['photo'][1]['img_path'].toString());
        request.files.add(photo1);
      }

      if(data['photo'][2]['img_path'] != null) {
        var photo2 = await http.MultipartFile.fromPath(
          "photo2", data['photo'][2]['img_path'].toString());
        request.files.add(photo2);
      }

      request.fields['payload'] = json.encode(data['payload']);
      var response = await request.send().timeout(new Duration(seconds: 240));
      var responseData = await response.stream.toBytes();
      var responseString = await String.fromCharCodes(responseData);
      return responseString;

    } on TimeoutException catch (_) {
      return "timeout";
    } on SocketException catch (_) {
      return "offline";
    } on FormatException catch (_) {
      return "offline";
    } on Exception catch (_) {
      return "offline";
    }
  }

  // Delete Submission
  static Future<dynamic> deleteSubmission(id) async {
    final response = await http.post("$BASE_URL/api/delete_submission?id=$id");
    return json.decode(response.body);
  }

  static Future<dynamic> saveAbnormalityApproved(data) async {
    final response = await  http.post("$BASE_URL/abnormality/save_approved",
        body: {'payload' : json.encode(data)});
    return json.decode(response.body);
  }

  static Future<dynamic> saveBreakdownApproved(data) async {
    final response = await http.post("$BASE_URL/breakdown/save_approved_and_assignment",
        body: {'payload' : json.encode(data)});
    return json.decode(response.body);
  }

  // Save Received Teknisi Breakdown PM02
  static Future<dynamic> saveReceivedBreakdown(data) async {
    final response = await http.post("$BASE_URL/breakdown/save_received_breakdown",
        body: {'payload' : jsonEncode(data)});
    return jsonDecode(response.body);
  }
  
  // Save Confirmation Teknisi Breakdown PM02
  static Future<dynamic> saveConfirmationBreakdown(data) async {
    final response = await http.post("$BASE_URL/breakdown/save_confirmation_breakdown",
    body: {'payload' : jsonEncode(data)});
    return jsonDecode(response.body);
  }

  // Save Execution Corrective
  static Future<dynamic> saveExeCorrective(data) async {
    try {
      var request = http.MultipartRequest(
        "POST", Uri.parse("$BASE_URL/breakdown/save_execution_corrective")
      );

      if(data['before'][0]['img_path'] != null) {
        var picBefore0 = await http.MultipartFile.fromPath(
            "pic_before0", data['before'][0]['img_path'].toString());
        request.files.add(picBefore0);
      }

      if(data['before'][1]['img_path'] != null) {
        var picBefore1 = await http.MultipartFile.fromPath(
            "pic_before1", data['before'][1]['img_path'].toString());
        request.files.add(picBefore1);
      }

      if(data['before'][2]['img_path'] != null) {
        var picBefore2 = await http.MultipartFile.fromPath(
          "pic_before2", data['before'][2]['img_path'].toString());
        request.files.add(picBefore2);
      }

      if(data['after'][0]['img_path'] != null) {
        var picAfter0 = await http.MultipartFile.fromPath(
            "pic_after0", data['after'][0]['img_path']);
        request.files.add(picAfter0);
      }

      if(data['after'][1]['img_path'] != null) {
        var picAfter1 = await http.MultipartFile.fromPath(
          "pic_after1", data['after'][1]['img_path']);
        request.files.add(picAfter1);
      }

      if(data['after'][2]['img_path'] != null) {
        var picAfter2 = await http.MultipartFile.fromPath(
          "pic_after2", data['after'][2]['img_path']);
        request.files.add(picAfter2);
      }

      request.fields['payload'] = json.encode(data['payload']);

      var response = await request.send().timeout(new Duration(seconds: 240));
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return responseString;

    } on TimeoutException catch (_) {
      return "timeout";
    } on SocketException catch (_) {
      return "offline";
    } on FormatException catch (_) {
      return "offline";
    } on Exception catch (_) {
      return "offline";
    }
  }
  
  //  save justification PM02
  static Future<dynamic> saveJustificationBreakdown(data) async {
    var response = await http.post("$BASE_URL/breakdown/save_justification_breakdown",
      body: {'payload' : json.encode(data)});
    return json.decode(response.body);
  }

  //  save wo approval
  static Future<dynamic> saveWOApproval(data) async {
    var response = await http.post("$BASE_URL/breakdown/save_wo_approval",
        body: {'payload' : json.encode(data)});
    return json.decode(response.body);
  }

}