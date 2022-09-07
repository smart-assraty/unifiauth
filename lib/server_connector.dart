import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:unifiapp/admin_forms.dart';
import 'dart:convert';

import 'main.dart';

String uvicorn = "http://185.125.88.30:8001";

class AuthHelper {
  Future<dynamic> getForms(String language) async {
    try {
      var response = await get(Uri.parse("$uvicorn/GetLoginForm/$language"));
      return json.decode(utf8.decode(response.body.codeUnits));
    } catch (e) {
      return "$e";
    }
  }

  Future<int> connecting() async {
    var response = await get(
      Uri.parse("$server/admin/connecting.php/?${Uri.base.query}"),
      headers: {
        "Charset": "utf-8",
      },
    );
    return response.statusCode;
  }

  Future<int> postData(
      String lang, List<Map<String, dynamic>> dataToApi, List forms) async {
    for (int i = 0; i < forms.length; ++i) {
      dataToApi.add(forms.elementAt(i).commit());
    }
    Map<String, dynamic> mapToServer = {"lang": lang, "fields": dataToApi};
    var response = await post(
      Uri.parse("$uvicorn/GuestAuth/"),
      headers: {
        "Content-type": "application/json",
      },
      body: json.encode(mapToServer),
    );
    dataToApi.clear();
    return response.statusCode;
  }
}

class AdminHelper {
  Future<StreamedResponse?> login(String username, String password) async {
    try {
      var request =
          MultipartRequest("POST", Uri.parse("$uvicorn/AdministratorSignIn"));
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
      var response =
          await get(Uri.parse("$uvicorn/GetAdminLoginForm/"), headers: {
        "Authorization":
            "${json.decode(token)['token_type']} ${json.decode(token)['access_token']}"
      });
      debugPrint(utf8.decode(response.body.codeUnits));
      return json.decode(utf8.decode(response.body.codeUnits));
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<List<dynamic>> getLangs() async {
    try {
      var request = await get(Uri.parse("$uvicorn/GetAllLangsList/"));
      return json.decode(request.body);
    } catch (e) {
      debugPrint("$e");
      return ["$e"];
    }
  }

  Future<String> postToServer(String bgImage, String logoImage,
      List<AdminForm> forms, List languages, String api, String token) async {
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
          "logo_image": logoImage,
          "bg_image": bgImage,
          "count_fields": forms.length,
          "api_url": api
        },
        "fields": list,
      });
      var request = await post(Uri.parse("$uvicorn/LoginForm/"),
          headers: {
            "Content-type": "application/json",
            "Authorization":
                "${json.decode(token)['token_type']} ${json.decode(token)['access_token']}"
          },
          body: json.encode(mapToPost));

      return json.encode(request.body);
    } catch (e) {
      debugPrint("Post To Server Error: $e");
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
        Uri.parse("$uvicorn/$toDir/"),
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
