import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/vm_auto_mem.dart';

class VMAutoService {
  static String baseUrl = 'http://192.168.100.80';
  static final _client = http.Client();

  Future<List<VMDetailModel>> getVM() async {
    final url = Uri.parse(
      '$baseUrl/vm',
    );

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['vms']['data'];
        List<VMDetailModel> vms = [];

        for (var item in data) {
          vms.add(VMDetailModel.fromJson(item));
        }
        return vms;
      } else {
        throw Exception(
            'Failed to load vms data! (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load vms data! (Error: $e)');
    }
  }

  Future<VMDetailModel> getVMDetails(int id) async {
    final url = Uri.parse(
      '$baseUrl/virtualmachines/$id',
    );
    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        VMDetailModel vm = VMDetailModel.fromJson(data);

        return vm;
      } else {
        throw Exception('Failed to load VM details');
      }
    } catch (e) {
      throw Exception('Failed to load vms data! (Error: $e)');
    }
  }

  Future<VMDetailModel> startVM(int id) async {
    final url = Uri.parse('$baseUrl/startVM/$id');
    http.Response response = await _client.post(url, body: {
      "id": id.toString(),
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      VMDetailModel host = VMDetailModel.fromJson(data);
      return host;
    } else {
      throw Exception('Ahh masih mati');
    }
  }

  Future<VMDetailModel> stopVM(int id) async {
    final url = Uri.parse('$baseUrl/stopVM/$id');
    http.Response response = await _client.post(url, body: {
      "id": id.toString(),
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      VMDetailModel host = VMDetailModel.fromJson(data);
      return host;
    } else {
      throw Exception('Masih nyala tuh');
    }
  }

  Future<void> toggleAutomation(int vmId, bool isAutomationRunning) async {
    final url = '$baseUrl/memoryautovm';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'vmid': vmId.toString(),
        'isAutomationRunning': isAutomationRunning.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Automation status toggled successfully');
    } else {
      throw Exception('Failed to toggle automation status');
    }
  }
}
