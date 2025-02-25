import 'package:flutter/material.dart';
import 'package:shoes_app/model/host_model.dart';
import '../theme/const.dart';

// ignore: must_be_immutable
class HostTile extends StatelessWidget {
  final HostModel host;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  HostTile(
    this.host, 
  {
    super.key, 
    required this.onEdit, 
    required this.onDelete, 
  });

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print('Host: $host');
    return Container(
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
                      '${host.ipAddress}:${host.port}',
                      style: primaryTextStyle.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      host.usernameFromProxmox!,
                      style: secondaryTextStyle.copyWith(
                        fontSize: 10,
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
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: primaryColor),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
