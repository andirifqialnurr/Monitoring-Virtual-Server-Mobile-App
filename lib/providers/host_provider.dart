import 'package:flutter/material.dart';
import 'package:shoes_app/model/host_model.dart';
import 'package:shoes_app/services/host_service.dart';

class HostProvider with ChangeNotifier {
  HostModel? _host;
  HostModel? get host => _host;

  final List<HostModel> _hostList = [];
  List<HostModel> get hostList => _hostList;

  Future<bool> registerHosts({
    String? ipAddress,
    String? port,
    String? username,
    String? password,
  }) async {
    try {
      HostModel host = await HostService().registerHosts(
        ipAddress: ipAddress,
        port: port,
        username: username,
        password: password,
      );

      _host = host;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginHosts({
    required String ipAddress,
    required String port,
    required String username,
    required String password,
  }) async {
    try {
      HostModel host = await HostService().loginHosts(
        ipAddress: ipAddress,
        port: port,
        username: username,
        password: password,
      );

      _host = host;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateHost({
    required int hostId, // ID host yang ingin diupdate
    String? ipAddress,
    String? port,
    String? username,
    String? password,
  }) async {
    try {
      HostModel updatedHost = await HostService().updateHost(
        hostId: hostId, // ID host untuk update
        ipAddress: ipAddress,
        port: port,
        username: username,
        password: password,
      );

      _host = updatedHost;
      return true;  // Update berhasil
    } catch (e) {
      print(e);
      return false;  // Update gagal
    }
  }

  Future<void> getHosts() async {
    try {
      List<HostModel> host = await HostService().getHosts();
      print('Response from getHosts API: $host');

      _hostList.clear();
      _hostList.addAll(host);
      notifyListeners();
    } catch (e) {
      print('Error fetching hosts: $e');
      rethrow;
    }
  }

  Future<void> getHostById(int id) async {
    try {
      _host = await HostService().getHostById(id);
      notifyListeners();  // Notifikasi perubahan data
    } catch (e) {
      print('Error fetching host by ID: $e');
      rethrow;
    }
  }
}
