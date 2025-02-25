import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shoes_app/model/node_model.dart';
import 'package:shoes_app/services/node_service.dart';

class NodeProvider extends ChangeNotifier {
  List<NodeModel> _nodes = [];
  List<NodeModel> get nodes => _nodes;

  bool _shouldStartPolling = false;

  Timer? _nodeTimer;
  Timer? _nodeDetailTimer;

  final _nodeStreamController = StreamController<List<NodeModel>>.broadcast();
  Stream<List<NodeModel>> get vmStream => _nodeStreamController.stream;

  final _nodeDetailStreamController = StreamController<NodeModel>.broadcast();
  Stream<NodeModel> nodeDetailStream(int index) =>
      _nodeDetailStreamController.stream;

  void setShouldPollVM(bool shouldPoll) {
    _shouldStartPolling = shouldPoll;
    if (_shouldStartPolling) {
      _nodeTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        getNodes();
      });
    } else {
      _nodeTimer?.cancel();
    }
  }

  void startPollingForNodeDetail(int index) {
    _nodeDetailTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      getNodeById(index);
    });
  }

  void stopPollingDetail() {
    _nodeDetailTimer?.cancel();
  }

  Future<void> getNodes() async {
    try {
      _nodes = await NodeService().getNodes();
      _nodeStreamController.add(_nodes);
    } catch (e) {
      print('Error fetching nodes: $e');
    }
  }

  Future<NodeModel> getNodeById(int index) async {
    try {
      NodeModel node = await NodeService().getNodeById(index);
      _nodeDetailStreamController.add(node);
      return node;
    } catch (e) {
      print('Error fetching nodes by index: $e');
      rethrow;
    }
  }
}
