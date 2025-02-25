import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/con_edit_model.dart';

class EditContainerService {
  static String baseUrl = 'http://192.168.100.80';
  static final _client = http.Client();

  // Edit CPU
  Future<EditCPUContainerModel> editConCPU({id, cpu}) async {
    final url = Uri.parse('$baseUrl/editcpucontainer');
    http.Response response = await _client.post(url, body: {
      "id": id,
      "cpu": cpu,
    });
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      EditCPUContainerModel edited =
          EditCPUContainerModel.fromJson(data['data']);
      return edited;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Edit RAM
  Future<EditRAMContainerModel> editConRAM({id, mem}) async {
    final url = Uri.parse('$baseUrl/editmemcontainer');
    http.Response response = await _client.post(url, body: {
      "id": id,
      "mem": mem,
    });
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      EditRAMContainerModel edited =
          EditRAMContainerModel.fromJson(data['data']);
      return edited;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Edit HDD
  Future<EditHDDContainerModel> editConHDD({id, disk}) async {
    final url = Uri.parse('$baseUrl/editdiskcontainer');
    http.Response response = await _client.post(url, body: {
      "id": id,
      "disk": disk,
    });
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      EditHDDContainerModel edited =
          EditHDDContainerModel.fromJson(data['data']);
      return edited;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
