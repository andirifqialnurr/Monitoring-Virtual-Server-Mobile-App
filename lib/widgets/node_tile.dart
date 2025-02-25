import 'package:flutter/material.dart';
import 'package:shoes_app/model/node_model.dart';
import 'package:shoes_app/pages/host/detail_node_page.dart';
import '../theme/const.dart';

class NodeTile extends StatelessWidget {
  final NodeModel nodes;
  const NodeTile(this.nodes, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NodeDetailPage(nodes),
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
                        nodes.node!,
                        style: primaryTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        nodes.type!,
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
                  nodes.status ?? '',
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
