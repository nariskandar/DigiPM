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
  static const BASE_URL_RAW = Endpoint.BASE_URL_LOCAL;
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

  static Future<dynamic> asyncPictureUpload(String ewonumber, File file) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(BASE_URL + "/api/upload_picture_abnormality"));
    var pic = await http.MultipartFile.fromPath("pic", file.path);
    request.files.add(pic);
    request.fields["ewonumber"] = ewonumber;
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



  static Future<dynamic> saveAbnormalityForm1(data) async {
    final response = await http.post("$BASE_URL/api/save_abnormality",
        body: {'payload' : json.encode(data)});
    return json.decode(response.body);
  }

  static Future<dynamic> saveAbnormalityForm2(data) async {
    final response = await http.post("$BASE_URL/api/save_abnormality_question",
        body: {'payload' : json.encode(data)});
    return json.decode(response.body);
  }



  static Future<dynamic> saveAbnormality(data) async {
      var request = http.MultipartRequest(
          "POST", Uri.parse("$BASE_URL/api/save_abnormality"));

      if (data['before'][0]['img_path'] != null) {
        var picBefore0 = await http.MultipartFile.fromPath(
            "pic_before0", data['before'][0]['img_path'].toString());
        request.files.add(picBefore0);
      }

      request.fields["payload"] = json.encode(data['payload']);
  }

  static Future<dynamic> getUserlogin(id) async {
    final response = await http.post("$BASE_URL/user/get_single_user/$id");
    print(response);
    return json.decode(response.body);
  }

  static Future<dynamic> getEwoList([ewoId]) async {
    if (ewoId != null){
      final response = await http.get("$BASE_URL/data/getEwo?ewoId=$ewoId");
      return json.decode(response.body);
    } else {
      final response = await http.get("$BASE_URL/data/getEwo");
      return json.decode(response.body);
    }

  }

  static Future<dynamic> getTimeline(ewoId) async {
    final response = await http.get("$BASE_URL/data/getTimeline?ewoId=$ewoId");
    return json.decode(response.body);
  }

  static Future<dynamic> getExecutionStep() async {
    final request = await http.get("$BASE_URL/data/getExecutionStep");
    return json.decode(request.body);
  }

  static Future<dynamic> getSbu() async {
    final response = await http.get("$BASE_URL/data/getSbu");
    return json.decode(response.body);
  }

  static Future<dynamic> getAutoNumber() async {
    final response = await http.get("$BASE_URL/data/getAutoNumber");
    return response.body;
  }

  static Future<dynamic> getAllUser() async {
    final response = await http.get("$BASE_URL/data/getUser");
    return json.decode(response.body);
  }

  static Future<dynamic> getLine(sbu) async {
    final response = await http.post("$BASE_URL/data/getLine?sbu=$sbu");
    return json.decode(response.body);
  }

  static Future<dynamic> getMachine(line) async {
    final response = await http.post("$BASE_URL/data/getMachine?line=$line");
    return json.decode(response.body);
  }

  static Future<dynamic> getAllDate() async {
    final response = await http.get("$BASE_URL/data/getAllDate");
    return json.decode(response.body);
  }

  static Future<dynamic> getActivity() async {
    final response = await http.get("$BASE_URL/data/getActivityType");
    return json.decode(response.body);
  }

  static Future<dynamic> getPillar(id) async {
    final response = await http.post("$BASE_URL/data/getPillar?id=$id");
    return json.decode(response.body);
  }

  static Future<dynamic> getUnit(machine) async {
    final response = await http.post("$BASE_URL/data/getUnit?machine=$machine");
    return json.decode(response.body);
  }

  static Future<dynamic> getSubUnit(unit) async {
    final response = await http.post("$BASE_URL/data/getSub?unit=$unit");
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
}