import 'dart:convert';
import 'package:http/http.dart' as http;

class Unifi {
  static String host = '192.168.1.62';
  static int port = 8443;
  static String username = 'dauletilyas';
  static String password = 'Queuerty15';
  static String siteId = 'default';

  Future<Map<String, bool>> login() async {
    var request = await http.post(
      Uri.parse('https://192.168.1.62:8443/api/login'),
      headers: {
        "Connection": "Keep-Alive",
        "Content-type": "application/json",
        "Charset": "utf-8",
        "Keep-Alive": "timeout=5, max=1000",
      },
      body: jsonEncode(
        {"username": username, "password": password},
      ),
    );
    return (request.statusCode == 200)
        ? {request.headers["set-cookie"]!: true}
        : {"Error": false};
  }

  void setHost(String newHost) {
    host = newHost;
  }

  void setPort(int newPort) {
    port = newPort;
  }

  void setUserName(String newUser) {
    username = newUser;
  }

  void setPassword(String newPass) {
    password = newPass;
  }

  void setSiteId(String newSite) {
    siteId = newSite;
  }

  String setCookie(String cookie) {
    int index = cookie.indexOf(";");
    return (index == -1) ? cookie : cookie.substring(0, index);
  }

  Future<List<String>> getClients() async {
    var log = await login();
    String cookie = setCookie(log.keys.first);
    if (log.values.first) {
      var request = await http.post(
        Uri.parse('https://192.168.1.62:8443/api/s/default/stat/guest'),
        headers: {
          "Content-type": "application/json",
          "Charset": "utf-8",
          "cookie": cookie,
        },
        body: jsonEncode({
          "within": 1,
        }),
      );
      var data = request.body.split(',');
      return data;
    } else {
      return ["error"];
    }
  }

  void authorize(String mac, int minutes) async {
    var log = await login();
    String cookie = setCookie(log.keys.first);
    if (log.values.first) {
      await http.post(
        Uri.parse('https://192.168.1.62:8443/api/s/default/cmd/stamgr'),
        headers: {
          "Content-type": "application/json",
          "Charset": "utf-8",
          "cookie": cookie,
        },
        body: jsonEncode({
          "cmd": "authorize-guest",
          "mac": mac,
          "minutes": minutes,
          "up": null,
          "down": null,
          "megabytes": null,
          "ap_mac": null,
        }),
      );
    }
  }
}
