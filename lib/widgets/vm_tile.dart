import 'package:flutter/material.dart';
import 'package:shoes_app/model/vm_auto_mem.dart';
import 'package:shoes_app/pages/host/detail_vm_page.dart';
import '../theme/const.dart';

class VMTile extends StatelessWidget {
  final VMDetailModel vms;
  const VMTile(this.vms, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailVMPage(vms),
          ),
        );
      },
      child: Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vms.name!,
                        style: primaryTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        vms.vmid.toString(),
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
                  vms.status ?? '',
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
