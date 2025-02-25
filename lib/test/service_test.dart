import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ServiceTest {
  static final _client = http.Client();

  static final _regisUrl = Uri.parse('http://127.0.0.1:5000/register');

  static login(ipAdd, username, password) async {
    http.Response response = await _client.post(_regisUrl, body: {
      "ip_address": ipAdd,
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print(json);
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  // static register(email, password, context) async {
  //   http.Response response = await _client.post(_registerUrl, body: {
  //     "email": email,
  //     "password": password,
  //   });
  //   if (response.statusCode == 200) {
  //     var json = jsonDecode(response.body);
  //     if (json[0] == 'username already exist') {
  //       await EasyLoading.showError(json[0]);
  //     } else {
  //       await EasyLoading.showSuccess(json[0]);
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => Dashboard()));
  //     }
  //   } else {
  //     await EasyLoading.showError(
  //         "Error Code : ${response.statusCode.toString()}");
  //   }
  // }

  // Fungsi untuk melakukan registrasi
  static registerAdmins(name, username, email, password) async {
    final url = Uri.parse('http://127.0.0.1:5000/registerAdmin');

    http.Response response = await _client.post(url, body: {
      "name": name,
      "username": username,
      "email": email,
      "password": password,
    });
    print(response.body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to register: ${response.statusCode}');
    }
  }

// Fungsi untuk melakukan login
  static loginAdmins(email, password) async {
    final url = Uri.parse('http://127.0.0.1:5000/loginAdmin');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    http.Response response = await _client.post(url, headers: headers, body: {
      "email": email,
      "password": password,
    });
    print(response.body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }
}
