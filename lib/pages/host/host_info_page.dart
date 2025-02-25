import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/model/host_model.dart';
import 'package:shoes_app/theme/const.dart';

import '../../model/admin_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/host_provider.dart';

class HostInfoPage extends StatefulWidget {
  const HostInfoPage({super.key});

  @override
  State<HostInfoPage> createState() => _HostInfoPageState();
}

class _HostInfoPageState extends State<HostInfoPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AdminModel admin = authProvider.admin;

    HostProvider hostProvider = Provider.of<HostProvider>(context);
    HostModel? host = hostProvider.host;

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'Host',
          style: primaryTextStyle,
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: alertColor,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      );
    }

    Widget dataLogin() {
      return Container(
        margin: const EdgeInsets.only(
          top: defaultMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adminstrator',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              admin.name ?? 'N/A',
              style: secondaryTextStyle,
            ),
            const SizedBox(height: 20),
            Text(
              'IP Address',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${host?.ipAddress}:${host?.port}',
              style: secondaryTextStyle,
            ),
            const SizedBox(height: 20),
            Text(
              'Login as',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              host?.usernameFromProxmox ?? 'N/A',
              style: secondaryTextStyle,
            ),
          ],
        ),
      );
    }

    Widget buttons() {
      return Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/nodes');
              },
              style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
              child: Text(
                'List Node',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: bg3Color,
      appBar: header(),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            dataLogin(),
            buttons(),
          ],
        ),
      ),
    );
  }
}
