import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'main.dart';

String api = "$server/api";

class AuthHelper {
  Future<dynamic> getForms(String language) async {
    var response = await get(Uri.parse("$api/GetLoginForm/$language"));
    try {
      return json.decode(utf8.decode(response.body.codeUnits));
    } catch (e) {
      return "$e";
    }
  }

  Future<void> connecting() async {
    await get(
      Uri.parse("$server/admin/connecting.php/?${Uri.base.query}"),
      headers: {
        "Charset": "utf-8",
      },
    );
  }

  Future<void> postData(
      String lang, List<Map<String, dynamic>> dataToApi, List forms) async {
    for (int i = 0; i < forms.length; ++i) {
      dataToApi.add(forms.elementAt(i).commit());
    }
    Map<String, dynamic> mapToServer = {"lang": lang, "fields": dataToApi};
    await post(
      Uri.parse("$api/GuestAuth/"),
      headers: {
        "Content-type": "application/json",
      },
      body: json.encode(mapToServer),
    );
    dataToApi.clear();
  }
}

class AdminHelper {
  Future<StreamedResponse?> login(String username, String password) async {
    try {
      var request =
          MultipartRequest("POST", Uri.parse("$api/AdministratorSignIn"));
      request.fields.addAll({"username": username, "password": password});
      request.headers.addAll({"Content-type": "multipart/form-data"});
      return await request.send();
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<dynamic> getForms(String token) async {
    try {
      var response = await get(Uri.parse("$api/GetAdminLoginForm/"), headers: {
        "Authorization":
            "${json.decode(token)['token_type']} ${json.decode(token)['access_token']}"
      });
      return json.decode(utf8.decode(response.body.codeUnits));
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<List<dynamic>> getLangs() async {
    try {
      var request = await get(Uri.parse("$api/GetAllLangsList/"));
      return json.decode(request.body);
    } catch (e) {
      debugPrint("$e");
      return ["$e"];
    }
  }

  Future<String> postToServer(
      List forms, List languages, String api, String token) async {
    try {
      List<Map<String, dynamic>> list = [];
      for (int i = 0; i < forms.length; i++) {
        list.add(forms.elementAt(i).getChild().commit());
      }
      Map<String, dynamic> mapToPost = {};
      mapToPost.addAll({
        "login": "string",
        "settings": {
          "langs": languages,
          "count_langs": languages.length,
          "logo_img": "string",
          "bg_image": "string",
          "count_fields": forms.length,
          "api_url": api
        },
        "fields": list,
      });
      var request = await post(Uri.parse("$api/LoginForm/"),
          headers: {
            "Content-type": "application/json",
            "Authorization":
                "${json.decode(token)['token_type']} ${json.decode(token)['access_token']}"
          },
          body: json.encode(mapToPost));

      return json.encode(request.body);
    } catch (e) {
      debugPrint("$e");
      return "Error: $e";
    }
  }

  Future<dynamic> pickfile() async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowCompression: false,
      );
      return file;
    } catch (e) {
      debugPrint("$e");
      return "$e";
    }
  }

  Future<String> sendImage(
      FilePickerResult image, String toDir, String token, int? number) async {
    try {
      var bytes = image.files.first.bytes!;
      var request = MultipartRequest(
        "POST",
        Uri.parse("$api/$toDir/"),
      );
      var listImage = List<int>.from(bytes);
      request.headers.addAll({
        "Content-type": "multipart/form-data",
        "Authorization":
            "${json.decode(token)['token_type']} ${json.decode(token)['access_token']}",
      });

      var file = MultipartFile.fromBytes("file", listImage,
          contentType: MediaType("application", "octet-stream"),
          filename: image.files.first.name);
      request.fields.addAll({"img_type": "${image.files.first.extension}"});
      if (number != null) {
        request.fields.addAll({"number": "$number"});
      }
      request.files.add(file);

      var response = await request.send();
      return response.stream.bytesToString();
    } catch (e) {
      debugPrint("$e");
      return "$e";
    }
  }
}
