import 'package:flutter/material.dart';
import 'package:shoes_app/model/con_model.dart';
import 'package:shoes_app/pages/host/detail_container_page.dart';

import '../theme/const.dart';

class ContainerTile extends StatelessWidget {
  final ContainerModel containers;
  const ContainerTile(this.containers, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailContainerPage(containers),
          ),
        );
      },
      child: Container(
        key: ValueKey(containers.vmid),
        margin: const EdgeInsets.only(
          top: 33,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/Logo Shop Picture.png',
                  width: 54,
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        containers.name!,
                        style: primaryTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        containers.vmid!.toString(),
                        style: secondaryTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: light,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0xff2B2939),
                      )
                    ],
                  ),
                ),
                Text(
                  containers.status ?? '',
                  style: secondaryTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
