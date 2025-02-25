import 'dart:convert';
import 'package:shoes_app/model/con_model.dart';
import 'package:http/http.dart' as http;

class ContainerService {
  static String baseUrl = 'http://192.168.100.80';
  static final _client = http.Client();

  Future<List<ContainerModel>> getContainer() async {
    final url = Uri.parse(
      '$baseUrl/container',
    );

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['containers']['data'];
        List<ContainerModel> containers = [];

        for (var item in data) {
          containers.add(ContainerModel.fromJson(item));
        }

        return containers;
      } else {
        throw Exception(
            'Failed to load containers data! (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load containers data! (Error: $e)');
    }
  }

  Future<ContainerModel> getContainerDetails(int vmid) async {
    final url = Uri.parse(
      '$baseUrl/containerview/$vmid',
    );
    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        ContainerModel container = ContainerModel.fromJson(data);
        return container;
      } else {
        throw Exception('Failed to load container details');
      }
    } catch (e) {
      throw Exception('Failed to load containers data! (Error: $e)');
    }
  }

  Future<void> toggleAutomationCon(
      String vmid, bool isAutomationRunning) async {
    final url = '$baseUrl/memoryautocon';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'vmid': vmid,
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
