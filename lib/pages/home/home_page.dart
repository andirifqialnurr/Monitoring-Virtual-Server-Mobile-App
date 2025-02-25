import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import '../../model/admin_model.dart';
import '../../theme/const.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AdminModel admin = authProvider.admin;

    Widget header() {
      return Container(
        margin: const EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${admin.name}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: semibold,
                    ),
                  ),
                  Text(
                    '@${admin.username}',
                    style: subtitleTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: admin.profilePhotoUrl != null
                        ? NetworkImage(admin.profilePhotoUrl!)
                        : NetworkImage(
                            'https://ui-avatars.com/api/?name=${admin.name}&color=7F9CF5&background=EBF4FF')),
              ),
            ),
          ],
        ),
      );
    }

    Widget popularProductsTitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: defaultMargin,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Text(
              'Just Some Text',
              style: primaryTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semibold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 170,
            margin: const EdgeInsets.only(
              top: 12,
              left: defaultMargin,
              right: defaultMargin,
            ),
            decoration: BoxDecoration(
              color: bg4Color,
              borderRadius: BorderRadius.circular(15),
            ),
          )
        ],
      );
    }

    return ListView(
      children: [
        header(),
        popularProductsTitle(),
      ],
    );
  }
}
