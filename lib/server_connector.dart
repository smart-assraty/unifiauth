import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:unifiapp/admin_form.dart';
import 'package:unifiapp/auth_fields.dart';
import 'dart:convert';

import 'main.dart';

String uvicorn = "http://185.125.88.30:8000";

class AuthHelper {
  const AuthHelper();
  Future<dynamic> getForms(String language) async {
    try {
      var response = await get(Uri.parse("$uvicorn/GetLoginForm/$language"));
      // debugPrint(utf8.decode(response.body.codeUnits));
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

  bool checkBrandRequired(List<AuthField> brands) {
    if (brands.isNotEmpty) {
      for (int i = 0; i < brands.length; i++) {
        if (brands[i].isRequired) {
          for (int j = 0; j < brands.length; j++) {
            if (brands[j].data != null) {
              return true;
            }
          }
        }
      }
    } else {
      return true;
    }
    return false;
  }

  Future<int> postData(String lang, List<AuthField> forms) async {
    List<Map<String, dynamic>> dataToApi = [];
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

  Future<String> postChangePassword(String usename, String oldPassword,
      String newPassword, String token) async {
    try {
      Map<String, dynamic> params = {
        'username': usename,
        'old_password': oldPassword,
        'new_password': newPassword
      };
      var request = await post(Uri.parse("$uvicorn/SetNewPassword/"),
          headers: {
            "Content-type": "application/x-www-form-urlencoded",
            "Authorization":
                "${json.decode(token)['token_type']} ${json.decode(token)['access_token']}",
          },
          body: params);
      return json.encode(request.statusCode);
    } catch (e) {
      debugPrint("$e");
      return "Error: $e";
    }
  }

  Future<dynamic> getForms(String token) async {
    try {
      var response =
          await get(Uri.parse("$uvicorn/GetAdminLoginForm/"), headers: {
        "Authorization":
            "${json.decode(token)['token_type']} ${json.decode(token)['access_token']}"
      });
      // debugPrint(utf8.decode(response.body.codeUnits));
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
      //debugPrint(mapToPost.toString());
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
