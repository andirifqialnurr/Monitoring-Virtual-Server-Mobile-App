import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shoes_app/model/node_model.dart';

class NodeService {
  static String baseUrl = 'http://192.168.100.80';
  static final _client = http.Client();

  Future<List<NodeModel>> getNodes() async {
    final url = Uri.parse('$baseUrl/getNode');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['nodes']['data'];
        List<NodeModel> nodes = [];

        for (var item in data) {
          nodes.add(NodeModel.fromJson(item));
        }
        return nodes;
      } else {
        throw Exception(
            'Failed to load nodes data! (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load nodes data! (Error: $e)');
    }
  }

  Future<NodeModel> getNodeById(int index) async {
    final url = Uri.parse('$baseUrl/getNodeByIndex/$index');

    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        NodeModel node = NodeModel.fromJson(data);

        return node;
      } else {
        throw Exception('Failed to load node details');
      }
    } catch (e) {
      throw Exception('Failed to load node data! (Error: $e)');
    }
  }
}
