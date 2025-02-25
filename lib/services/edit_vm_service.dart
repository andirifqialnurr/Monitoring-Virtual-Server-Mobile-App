import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoes_app/model/vm_edit_model.dart';

class EditVMService {
  static String baseUrl = 'http://192.168.100.80';
  static final _client = http.Client();

  // Edit CPU
  Future<EditCPUVMModel> editVMCPU({id, cpu}) async {
    final url = Uri.parse('$baseUrl/editcpuvm');
    http.Response response = await _client.post(url, body: {
      "id": id,
      "cpu": cpu,
    });
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      EditCPUVMModel edited = EditCPUVMModel.fromJson(data['data']);
      return edited;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Edit RAM
  Future<EditRAMVMModel> editVMRAM({id, mem}) async {
    final url = Uri.parse('$baseUrl/editmemvm');
    http.Response response = await _client.post(url, body: {
      "id": id,
      "mem": mem,
    });
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      EditRAMVMModel edited = EditRAMVMModel.fromJson(data['data']);
      return edited;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Edit HDD
  Future<EditHDDVMModel> editVMHDD({id, disk}) async {
    final url = Uri.parse('$baseUrl/editdiskvm');
    http.Response response = await _client.post(url, body: {
      "id": id,
      "disk": disk,
    });
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      EditHDDVMModel edited = EditHDDVMModel.fromJson(data['data']);
      return edited;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
