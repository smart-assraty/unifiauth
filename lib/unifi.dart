import 'dart:convert';
import 'package:http/http.dart' as http;

class Unifi {
  static String host = '192.168.1.62';
  static int port = 8443;
  static String username = 'dauletilyas';
  static String password = 'Queuerty15';
  static String siteId = 'default';

  Future<String> login() async {
    var request = await http.post(
      Uri.parse('https://192.168.1.62:8443/api/login'),
      headers: {
        "Content-type": "application/json",
        "Charset": "utf-8",
      },
      body: jsonEncode(
        {"username": username, "password": password},
      ),
    );
    return (request.statusCode == 200)
        ? request.headers["set-cookie"]!
        : "Error";
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

  Future<String> authorize(String mac) async {
    var log = await login();
    String cookie = setCookie(log);
    var request = await http.post(
      Uri.parse('https://192.168.1.62:8443/api/s/default/cmd/stamgr'),
      headers: {
        "Content-type": "application/json",
        "Charset": "utf-8",
        "cookie": cookie,
      },
      body: jsonEncode({
        "cmd": "authorize-guest",
        "mac": mac,
        "minutes": 30,
        "up": null,
        "down": null,
        "megabytes": null,
        "ap_mac": null,
      }),
    );
    return "${request.headers.toString()}\n\n${request.body}";
  }
}
