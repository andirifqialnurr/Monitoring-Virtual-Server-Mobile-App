import 'package:flutter/material.dart';
import 'package:shoes_app/services/edit_con_service.dart';

import '../model/con_edit_model.dart';

class EditContainerProvider with ChangeNotifier {
  late EditCPUContainerModel _cpu;
  late EditHDDContainerModel _disk;
  late EditRAMContainerModel _mem;

  EditCPUContainerModel get cpu => _cpu;
  EditHDDContainerModel get disk => _disk;
  EditRAMContainerModel get mem => _mem;

  set cpu(EditCPUContainerModel cpu) {
    _cpu = cpu;
    notifyListeners();
  }

  set disk(EditHDDContainerModel disk) {
    _disk = disk;
    notifyListeners();
  }

  set mem(EditRAMContainerModel mem) {
    _mem = mem;
    notifyListeners();
  }

  Future<bool> editConCPU({
    id,
    cpu,
  }) async {
    try {
      EditCPUContainerModel editcpu = await EditContainerService().editConCPU(
        id: id,
        cpu: cpu,
      );

      _cpu = editcpu;
      return true;
        } catch (e) {
      return false;
    }
  }

  Future<bool> editConHDD({
    id,
    disk,
  }) async {
    try {
      EditHDDContainerModel edithdd = await EditContainerService().editConHDD(
        id: id,
        disk: disk,
      );

      _disk = edithdd;
      return true;
        } catch (e) {
      return false;
    }
  }

  Future<bool> editConRAM({
    id,
    mem,
  }) async {
    try {
      EditRAMContainerModel editram = await EditContainerService().editConRAM(
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
