import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/con_provider.dart';
import 'package:shoes_app/widgets/container_tile.dart';

import '../../model/con_model.dart';
import '../../theme/const.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  late BuildContext _ancestorContext; // Add this variable

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ancestorContext = context;
    Provider.of<ContainerProvider>(_ancestorContext, listen: false)
        .setShouldStartPolling(true);
    Provider.of<ContainerProvider>(_ancestorContext, listen: false)
        .startPolling();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ContainerProvider>(context, listen: false)
        .setShouldStartPolling(true);
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<ContainerProvider>(context, listen: false).stopPolling();
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'Container',
          style: primaryTextStyle,
        ),
        elevation: 0,
      );
    }

    Widget content(BuildContext context, List<ContainerModel> containerList) {
      // Sort the VM list based on name and then VM ID
      containerList.sort((con1, con2) {
        final nameComparison = con1.name!.compareTo(con2.name!);
        if (nameComparison != 0) {
          return nameComparison;
        }
        return con1.vmid!.compareTo(con2.vmid!);
      });
      return Container(
        color: bg3Color,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          children: containerList
              .map(
                (containers) => ContainerTile(containers),
              )
              .toList(),
        ),
      );
    }

    return Builder(builder: (BuildContext builderContext) {
      _ancestorContext = builderContext;
      return Scaffold(
        appBar: header(),
        body: StreamBuilder<List<ContainerModel>>(
          stream:
              Provider.of<ContainerProvider>(context, listen: false).conStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ContainerModel> containerList = snapshot.data!;
              return content(context, containerList);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    });
  }
}
