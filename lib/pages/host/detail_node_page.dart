import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/model/node_model.dart';
import 'package:shoes_app/providers/node_providers.dart';
import 'package:shoes_app/widgets/node_detail_source.dart';
import '../../theme/const.dart';

class NodeDetailPage extends StatefulWidget {
  final NodeModel nodes;
  const NodeDetailPage(this.nodes, {super.key});

  @override
  State<NodeDetailPage> createState() => _NodeDetailPageState();
}

class _NodeDetailPageState extends State<NodeDetailPage> {
  late NodeProvider nodeProvider;

  String convertToGB(int sizeInBytes) {
    double sizeInGB = sizeInBytes / 1073741824;
    return sizeInGB.toStringAsFixed(2);
  }

  String convertToMB(int sizeInBytes) {
    double sizeInMB = sizeInBytes / 1048576;
    return sizeInMB.toStringAsFixed(1);
  }

  @override
  void initState() {
    super.initState();
    nodeProvider = Provider.of<NodeProvider>(context, listen: false);

    nodeProvider.startPollingForNodeDetail(widget.nodes.index!);
  }

  @override
  void dispose() {
    super.dispose();
    nodeProvider.stopPollingDetail();
  }

  bool calculateMemoryBelowThreshold(NodeModel nodeDetail) {
    double maxMemSizeInMB = nodeDetail.maxmem! / 1048576;
    double currentMemSizeInMB = nodeDetail.mem! / 1048576;
    double memThreshold = maxMemSizeInMB * 0.4;
    return currentMemSizeInMB < memThreshold;
  }

  @override
  Widget build(BuildContext context) {
    nodeProvider = Provider.of<NodeProvider>(context);

    Widget header(NodeModel nodeDetail) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: nodeDetail.status == 'online'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.nodes.node!,
                style: secondaryTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: bold,
                ),
              ),
              Text(
                'ID: ${widget.nodes.id!}',
                style: secondaryTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget content(NodeModel nodeDetail) {
      String diskSizeInGB = convertToGB(nodeDetail.disk!.toInt());
      String maxDiskSizeInGB =
          convertToGB(nodeDetail.maxdisk!); // Corrected calculation
      String maxMemSizeInMB = convertToMB(nodeDetail.maxmem!);

      String memory = nodeDetail.mem! > 1073741824
          ? (nodeDetail.mem! / 1073741824).toStringAsFixed(2)
          : (nodeDetail.mem! / 1048576).toStringAsFixed(2);

      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(
          top: 17,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            color: bg1Color),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NodeDetailSource(
                    title: 'CPU',
                    maxValue: nodeDetail.cpus!.toInt(),
                    usageValue: nodeDetail.cpu!.toDouble(),
                    isPercentage: true,
                    displayValue: (nodeDetail.cpu! * 100).toStringAsFixed(2),
                    unit: "Core(s)",
                    nameInput: 'CPU',
                    nodes: nodeDetail,
                    iconImagePath: 'assets/icon_cpu.png',
                  ),
                  NodeDetailSource(
                    title: 'RAM',
                    maxValue: double.parse(maxMemSizeInMB),
                    usageValue: double.parse(memory),
                    unit: 'MiB',
                    nameInput: 'RAM',
                    nodes: nodeDetail,
                    iconImagePath: 'assets/icon_ram.png',
                  ),
                  NodeDetailSource(
                    title: 'HDD',
                    maxValue: double.parse(maxDiskSizeInGB),
                    usageValue: double.parse(diskSizeInGB),
                    unit: 'GiB',
                    nameInput: 'HDD',
                    nodes: nodeDetail,
                    iconImagePath: 'assets/icon_hdd.png',
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 230,
                bottom: 10,
                right: defaultMargin,
                left: defaultMargin,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/vm');
                },
                style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                child: Text(
                  'Virtual Machine',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(
                  bottom: defaultMargin,
                  right: defaultMargin,
                  left: defaultMargin),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/container');
                },
                style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                child: Text(
                  'Container',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ChangeNotifierProvider<NodeProvider>.value(
      value: nodeProvider,
      builder: (context, child) {
        final nodeProvider = Provider.of<NodeProvider>(context, listen: false);
        return Scaffold(
          backgroundColor: bg6Color,
          body: ListView(
            children: [
              StreamBuilder<NodeModel>(
                stream: nodeProvider.nodeDetailStream(widget.nodes.index!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            kBottomNavigationBarHeight,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final nodeDetail = snapshot.data as NodeModel;
                    return Column(
                      children: [
                        header(nodeDetail),
                        content(nodeDetail),
                      ],
                    );
                  } else {
                    return const Text('No Node data available');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
