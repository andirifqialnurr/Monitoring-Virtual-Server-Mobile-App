import 'dart:async';
import 'dart:convert';

import 'package:shoes_app/model/host_model.dart';
import 'package:http/http.dart' as http;

class HostService {
  static String baseUrl = 'http://192.168.100.80';
  static final _client = http.Client();

  Future<HostModel> registerHosts({ipAddress, port, username, password}) async {
    final url = Uri.parse('$baseUrl/registerHosts');

    http.Response response = await _client.post(url, body: {
      "ip_address": ipAddress,
      "port": port,
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      HostModel host = HostModel.fromJson(data['host']);
      return host;
    } else {
      throw Exception('Register Failed');
    }
  }

  Future<HostModel> updateHost({
    required int hostId,
    String? ipAddress,
    String? port,
    String? username,
    String? password,
  }) async {
    try {
      // Endpoint untuk update data host
      final response = await http.put(
        Uri.parse('$baseUrl/updateHosts/$hostId'),
        headers: {
          'Content-Type': 'application/json',  // Pastikan header ini sesuai
        },
        body: jsonEncode({
          'ipAddress': ipAddress,
          'port': port,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Mengonversi response body menjadi objek HostModel
        return HostModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update host');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to update host');
    }
  }

  Future<HostModel> loginHosts({
    required String ipAddress,
    required String port,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/loginHosts');

    final Map<String, dynamic> requestBody = {
      "ip_address": ipAddress,
      "port": port,
      "username": username,
      "password": password,
    };

    final headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await _client.post(
      url,
      body: jsonEncode(requestBody),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      HostModel host = HostModel.fromJson(data['host']);
      return host;
    } else {
      throw Exception('Login Failed');
    }
  }

  Future<List<HostModel>> getHosts() async {
    final url = Uri.parse('$baseUrl/getHosts');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<HostModel> hosts = [];

        for (var item in data) {
          hosts.add(HostModel.fromJson(item));
        }

        return hosts;
      } else {
        throw Exception(
            'Failed to load hosts data! (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load hosts data! (Error: $e)');
    }
  }

  Future<HostModel?> getHostById(int id) async {
    final url = Uri.parse('$baseUrl/hosts/$id');  // Sesuaikan endpointnya dengan API Anda

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        if (data != null) {
          return HostModel.fromJson(data);  // Mengembalikan data HostModel berdasarkan ID
        } else {
          throw Exception('Data not found');
        }
      } else {
        throw Exception('Failed to load host data!');
      }
    } catch (e) {
      throw Exception('Failed to load host data! (Error: $e)');
    }
  }

  
}
