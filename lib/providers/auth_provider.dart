import 'package:flutter/material.dart';
import 'package:shoes_app/services/auth_service.dart';

import '../model/admin_model.dart';

class AuthProvider with ChangeNotifier {
  late AdminModel _admin;

  AdminModel get admin => _admin;

  set admin(AdminModel admin) {
    _admin = admin;
    notifyListeners();
  }

  Future<bool> registerAdmins({
    name,
    username,
    email,
    password,
  }) async {
    try {
      AdminModel admin = await AuthService().registerAdmins(
        name: name,
        username: username,
        email: email,
        password: password,
      );

      _admin = admin;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginAdmins({
    email,
    password,
  }) async {
    try {
      AdminModel admin = await AuthService().loginAdmins(
        email: email,
        password: password,
      );

      _admin = admin;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
