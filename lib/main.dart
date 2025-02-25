import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/edit_profile_page.dart';
import 'package:shoes_app/pages/home/main_page.dart';
import 'package:shoes_app/pages/host/container_page.dart';
import 'package:shoes_app/pages/host/host_info_page.dart';
import 'package:shoes_app/pages/host/host_login_page.dart';
import 'package:shoes_app/pages/host/node_page.dart';
import 'package:shoes_app/pages/host/vm_page.dart';
import 'package:shoes_app/pages/sign_in_page.dart';
import 'package:shoes_app/pages/sign_up_page.dart';
import 'package:shoes_app/pages/splash_page.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/providers/con_provider.dart';
import 'package:shoes_app/providers/edit_con_provider.dart';
import 'package:shoes_app/providers/edit_vm_provider.dart';
import 'package:shoes_app/providers/host_provider.dart';
import 'package:shoes_app/providers/node_providers.dart';
import 'package:shoes_app/providers/page_provider.dart';
import 'package:shoes_app/providers/vm_auto_mem_provider.dart';

import 'pages/home/host_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HostProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NodeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContainerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VMAutoProvider(),
        ),

        // Edit Manual Provider
        ChangeNotifierProvider(
          create: (context) => EditVMProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditContainerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/sign-in': (context) => const SignInPage(),
          '/sign-up': (context) => const SignUpPage(),
          '/home': (context) => const MainPage(),
          '/edit-profile': (context) => const EditProfilePage(),
          '/host': (context) => const HostPage(),
          '/host-login': (context) => const HostLogin(),
          '/host-info': (context) => const HostInfoPage(),
          '/nodes': (context) => const NodePage(),
          '/vm': (context) => const VMPage(),
          '/container': (context) => const ContainerPage(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
