import 'dart:async';
import 'dart:convert';

import 'package:shoes_app/model/admin_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String baseUrl = 'http://192.168.100.80';
  static final _client = http.Client();

  Future<AdminModel> registerAdmins({name, email, username, password}) async {
    final url = Uri.parse('$baseUrl/registerAdmin');
    

    http.Response response = await _client.post(url, 
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: {
      "name": name,
      "username": username,
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      AdminModel admin = AdminModel.fromJson(data['admin']);

      return admin;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<AdminModel> loginAdmins({email, password}) async {
    final url = Uri.parse('$baseUrl/loginAdmin');

    http.Response response = await _client.post(url, 
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: {
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      AdminModel admin = AdminModel.fromJson(data['admin']);

      return admin;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
