import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserDataPage(),
    );
  }
}

class UserDataPage extends StatefulWidget {
  const UserDataPage({super.key});

  @override
  _UserDataPageState createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  String userData = '';

  Future<void> getUserData(int userId) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/user/$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userData =
            'ID: ${data['id']}\nIP Address: ${data['ip_address']}\nUsername: ${data['username']}';
      });
    } else {
      setState(() {
        userData = 'Failed to fetch user data';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(
        1); // Mengambil data pengguna dengan ID 1, ganti dengan ID yang sesuai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
      ),
      body: Center(
        child: Text(userData),
      ),
    );
  }
}
