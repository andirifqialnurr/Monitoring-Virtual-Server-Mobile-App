import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_app/model/con_model.dart';
import 'package:shoes_app/services/con_service.dart';

class ContainerProvider with ChangeNotifier {
  List<ContainerModel> _containers = [];
  List<ContainerModel> get containers => _containers;

  bool _shouldStartPolling = false;

  Timer? _conTimer;
  Timer? _conDetailTimer;

  final _conStreamController =
      StreamController<List<ContainerModel>>.broadcast();
  Stream<List<ContainerModel>> get conStream => _conStreamController.stream;

  final _conDetailStreamController =
      StreamController<ContainerModel>.broadcast();
  Stream<ContainerModel> conDetailStream(int vmid) =>
      _conDetailStreamController.stream;

  void setShouldStartPolling(bool shouldStart) {
    _shouldStartPolling = shouldStart;
  }

  void startPolling() {
    if (_shouldStartPolling) {
      _conTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        getContainer();
      });
    }
  }

  void stopPolling() {
    _conTimer?.cancel();
  }

  void startPollingForConDetail(int vmid) {
    _conDetailTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      getContainerById(vmid);
    });
  }

  void stopPollingDetail() {
    _conDetailTimer?.cancel();
  }

  bool _isAutoAddButtonEnabled = false;

  bool get isAutoAddButtonEnabled => _isAutoAddButtonEnabled;
  set isAutoAddButtonEnabled(bool value) {
    _isAutoAddButtonEnabled = value;
    notifyListeners();
  }

  Future<void> loadButtonState() async {
    final prefs = await SharedPreferences.getInstance();
    isAutoAddButtonEnabled = prefs.getBool('isAutoAddButtonEnabled') ?? false;
  }

  Future<void> saveButtonState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAutoAddButtonEnabled', value);
  }

  Future<void> getContainer() async {
    try {
      _containers = await ContainerService().getContainer();
      _conStreamController.add(_containers);
    } catch (e) {
      print('Error fetching containers: $e');
    }
  }

  Future<ContainerModel> getContainerById(int vmid) async {
    try {
      ContainerModel con = await ContainerService().getContainerDetails(vmid);
      _conDetailStreamController.add(con);
      return con;
    } catch (e) {
      print('Error fetching Container by ID: $e');
      rethrow;
    }
  }

  Future<void> toggleAutomationCon(
      String vmid, bool isAutomationRunning) async {
    try {
      await ContainerService().toggleAutomationCon(vmid, isAutomationRunning);
      final index = _containers.indexWhere((con) => con.vmid == vmid);
      if (index != -1) {
        _containers[index] = _containers[index]
            .copyWith(isAutomationRunning: isAutomationRunning);
        _conStreamController.add(_containers[index] as List<ContainerModel>);
        notifyListeners();
      }
    } catch (error) {
      print('Error toggling automation: $error');
    }
  }

  @override
  void dispose() {
    _conStreamController.close();
    _conDetailStreamController.close();

    super.dispose();
  }
}
