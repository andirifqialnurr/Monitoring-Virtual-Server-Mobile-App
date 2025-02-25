import 'package:flutter/material.dart';
import 'package:shoes_app/model/vm_edit_model.dart';

import 'package:shoes_app/services/edit_vm_service.dart';

class EditVMProvider with ChangeNotifier {
  late EditCPUVMModel _cpu;
  late EditHDDVMModel _disk;
  late EditRAMVMModel _mem;

  EditCPUVMModel get cpu => _cpu;
  EditHDDVMModel get disk => _disk;
  EditRAMVMModel get mem => _mem;

  set cpu(EditCPUVMModel cpu) {
    _cpu = cpu;
    notifyListeners();
  }

  set disk(EditHDDVMModel disk) {
    _disk = disk;
    notifyListeners();
  }

  set mem(EditRAMVMModel mem) {
    _mem = mem;
    notifyListeners();
  }

  Future<bool> editVMCPU({
    id,
    cpu,
  }) async {
    try {
      EditCPUVMModel editcpu = await EditVMService().editVMCPU(
        id: id,
        cpu: cpu,
      );

      _cpu = editcpu;
      return true;
        } catch (e) {
      return false;
    }
  }

  Future<bool> editVMHDD({
    id,
    disk,
  }) async {
    try {
      EditHDDVMModel edithdd = await EditVMService().editVMHDD(
        id: id,
        disk: disk,
      );

      _disk = edithdd;
      return true;
        } catch (e) {
      return false;
    }
  }

  Future<bool> editVMRAM({
    id,
    mem,
  }) async {
    try {
      EditRAMVMModel editram = await EditVMService().editVMRAM(
        id: id,
        mem: mem,
      );

      _mem = editram;
      return true;
        } catch (e) {
      return false;
    }
  }
}
