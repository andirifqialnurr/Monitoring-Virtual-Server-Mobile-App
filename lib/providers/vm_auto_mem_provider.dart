import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/vm_auto_mem.dart';
import '../services/vm_auto_mem_service.dart';

class VMAutoProvider with ChangeNotifier {
  List<VMDetailModel> _vms = [];
  List<VMDetailModel> get vms => _vms;

  bool _shouldStartPolling = false;

  Timer? _vmTimer;
  Timer? _vmDetailTimer;

  final _vmStreamController = StreamController<List<VMDetailModel>>.broadcast();
  Stream<List<VMDetailModel>> get vmStream => _vmStreamController.stream;

  final _vmDetailStreamController = StreamController<VMDetailModel>.broadcast();
  Stream<VMDetailModel> vmDetailStream(int vmid) =>
      _vmDetailStreamController.stream;

  void setShouldPollVM(bool shouldPoll) {
    _shouldStartPolling = shouldPoll;
    if (_shouldStartPolling) {
      _vmTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        getVM();
      });
    } else {
      _vmTimer?.cancel();
    }
  }

  void startPollingForVMDetail(int vmid) {
    _vmDetailTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      getVMById(vmid);
    });
  }

  void stopPollingDetail() {
    _vmDetailTimer?.cancel();
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

  Future<void> getVM() async {
    try {
      _vms = await VMAutoService().getVM();
      _vmStreamController.add(_vms);
    } catch (e) {
      print('Error fetching vms: $e');
    }
  }

  Future<VMDetailModel> getVMById(int vmid) async {
    try {
      VMDetailModel vm = await VMAutoService().getVMDetails(vmid);
      _vmDetailStreamController.add(vm);
      return vm;
    } catch (e) {
      print('Error fetching VM by ID: $e');
      rethrow;
    }
  }

  // Future<VMDetailModel> startVM(int vmid) async {
  //   try {
  //     VMDetailModel vm = await VMAutoService().startVM(vmid);
  //     _vmDetailStreamController.add(vm);
  //     return vm;
  //   } catch (e) {
  //     print('Error starting VM: $e');
  //     rethrow;
  //   }
  // }

  // Future<VMDetailModel> stopVM(int vmid) async {
  //   try {
  //     VMDetailModel vm = await VMAutoService().stopVM(vmid);
  //     _vmDetailStreamController.add(vm);
  //     return vm;
  //   } catch (e) {
  //     print('Error stopping VM: $e');
  //     rethrow;
  //   }
  // }

  // Future<void> handleStopVM(int vmid) async {
  //   try {
  //     VMDetailModel vm = await VMAutoProvider().stopVM(vmid);
  //     _vmDetailStreamController.add(vm);

  //     await Future.delayed(const Duration(seconds: 20));
  //     VMDetailModel updatedVM = await getVMById(vmid);

  //     if (updatedVM.status == 'running') {
  //       print('VM is still running after stop attempt.');
  //     } else {
  //       print('VM stopped successfully.');
  //     }
  //   } catch (e) {
  //     print('Error stopping VM: $e');
  //   }
  // }

  Future<void> toggleAutomation(int vmId, bool isAutomationRunning) async {
    try {
      await VMAutoService().toggleAutomation(vmId, isAutomationRunning);
      final index = _vms.indexWhere((vm) => vm.vmid == vmId);
      if (index != -1) {
        _vms[index] =
            _vms[index].copyWith(isAutomationRunning: isAutomationRunning);
        _vmStreamController.add(_vms[index] as List<VMDetailModel>);
        notifyListeners();
      }
    } catch (error) {
      print('Error toggling automation: $error');
    }
  }

  @override
  void dispose() {
    _vmStreamController.close();
    _vmDetailStreamController.close();
    super.dispose();
  }
}
