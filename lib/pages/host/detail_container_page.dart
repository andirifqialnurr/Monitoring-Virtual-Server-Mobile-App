import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_app/model/con_model.dart';
import 'package:shoes_app/providers/con_provider.dart';
import 'package:shoes_app/widgets/arc_percentage.dart';
import 'package:shoes_app/widgets/manual_edit_con.dart';

import '../../theme/const.dart';

class DetailContainerPage extends StatefulWidget {
  final ContainerModel containers;
  const DetailContainerPage(this.containers, {super.key});

  @override
  State<DetailContainerPage> createState() => _DetailContainerPageState();
}

class _DetailContainerPageState extends State<DetailContainerPage> {
  bool isAutomationRunning = false;
  bool isMemoryBelowThreshold = false;
  late ContainerProvider conProvider;

  // Function to convert disk size from bytes to gigabytes (GB)
  String convertToGB(int sizeInBytes) {
    double sizeInGB = sizeInBytes / 1073741824; // Convert bytes to GB
    return sizeInGB.toStringAsFixed(2); // Show 2 decimal places
  }

  String convertToMB(int sizeInBytes) {
    double sizeInMB = sizeInBytes / 1048576; // Convert bytes to GB
    return sizeInMB.toStringAsFixed(1); // Show 2 decimal places
  }

  @override
  void initState() {
    super.initState();
    conProvider = Provider.of<ContainerProvider>(context, listen: false);

    isAutomationRunning = widget.containers.isAutomationRunning ?? false;
    _loadAutomationState();

    double maxMemSizeInMB = widget.containers.maxmem! / 1048576;
    double currentMemSizeInMB = widget.containers.mem! / 1048576;

    double memThreshold = maxMemSizeInMB * 0.4;
    isMemoryBelowThreshold = currentMemSizeInMB < memThreshold;

    isMemoryBelowThreshold = calculateMemoryBelowThreshold(widget.containers);

    conProvider.startPollingForConDetail(widget.containers.vmid!);
  }

  @override
  void dispose() {
    super.dispose();
    conProvider.stopPollingDetail();
  }

  bool calculateMemoryBelowThreshold(ContainerModel conModel) {
    double maxMemSizeInMB = conModel.maxmem! / 1048576;
    double currentMemSizeInMB = conModel.mem! / 1048576;
    double memThreshold = maxMemSizeInMB * 0.4;
    return currentMemSizeInMB < memThreshold;
  }

  Future<void> _loadAutomationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedAutomationState = prefs.getBool('automation_state') ?? false;
    setState(() {
      isAutomationRunning = savedAutomationState;
    });
  }

  Future<void> _saveAutomationState(bool newState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('automation_state', newState);
  }

  @override
  Widget build(BuildContext context) {
    conProvider = Provider.of<ContainerProvider>(context);

    Widget header(ContainerModel conModel) {
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
                    color: conModel.status == 'stopped'
                        ? Colors.red
                        : Colors.green,
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
                widget.containers.name!,
                style: secondaryTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: bold,
                ),
              ),
              Text(
                'ID: ${widget.containers.vmid!.toString()}',
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

    Widget content(ContainerModel conModel) {
      String diskSizeInGB = convertToGB(conModel.disk!.toInt());
      String maxDiskSizeInGB =
          convertToGB(conModel.maxdisk!); // Corrected calculation
      // String maxMemSizeInGB = convertToGB(conModel.maxmem!);
      String maxMemSizeInMB = convertToMB(conModel.maxmem!);

      String memory = conModel.mem! > 1073741824
          ? (conModel.mem! / 1073741824).toStringAsFixed(2)
          : (conModel.mem! / 1048576).toStringAsFixed(2);

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
          color: bg1Color,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ArcPercentage(
                    title: 'CPU',
                    maxValue: conModel.cpus!.toInt(),
                    usageValue: conModel.cpu!.toDouble(),
                    isPercentage: true,
                    displayValue: (conModel.cpu! * 100).toStringAsFixed(2),
                    unit: "Core(s)",
                    progressColor: Colors.green,
                  ),
                  ArcPercentage(
                    title: 'RAM',
                    maxValue: double.parse(maxMemSizeInMB),
                    usageValue: double.parse(memory),
                    unit: 'MiB',
                    progressColor: Colors.yellow,
                  ),
                  ArcPercentage(
                    title: 'HDD',
                    maxValue: double.parse(maxDiskSizeInGB),
                    usageValue: double.parse(diskSizeInGB),
                    unit: 'GiB',
                    progressColor: Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ResourceInfoCardCon(
                    title: 'CPU',
                    maxValue: conModel.cpus!.toInt(),
                    usageValue: conModel.cpu!.toDouble(),
                    isPercentage: true,
                    displayValue: (conModel.cpu! * 100).toStringAsFixed(2),
                    unit: "Core(s)",
                    nameInput: 'CPU',
                    selectedResources: 'cpu',
                    containers: conModel,
                    iconImagePath: 'assets/icon_cpu.png',
                  ),
                  ResourceInfoCardCon(
                    title: 'RAM',
                    maxValue: double.parse(maxMemSizeInMB),
                    usageValue: double.parse(memory),
                    unit: 'MiB',
                    nameInput: 'RAM',
                    selectedResources: 'mem',
                    containers: conModel,
                    iconImagePath: 'assets/icon_ram.png',
                  ),
                  ResourceInfoCardCon(
                    title: 'HDD',
                    maxValue: double.parse(maxDiskSizeInGB),
                    usageValue: double.parse(diskSizeInGB),
                    unit: 'GiB',
                    nameInput: 'HDD',
                    selectedResources: 'disk',
                    containers: conModel,
                    iconImagePath: 'assets/icon_hdd.png',
                  ),
                ],
              ),
            ),

            // NOTE: Button Auto Add
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(defaultMargin),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(top: 150),
                    child: TextButton(
                      onPressed: () {
                        _toggleAutomationCon(conProvider, conModel);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      child: Text(
                        isAutomationRunning ? 'Stop Auto' : 'Auto Add',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ChangeNotifierProvider<ContainerProvider>.value(
      value: conProvider,
      builder: (context, child) {
        final conProvider =
            Provider.of<ContainerProvider>(context, listen: false);
        return Scaffold(
          backgroundColor: bg6Color,
          body: ListView(
            children: [
              StreamBuilder<ContainerModel>(
                stream: conProvider.conDetailStream(widget.containers.vmid!),
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
                    final conModel = snapshot.data!;
                    return Column(
                      children: [
                        header(conModel),
                        content(conModel),
                      ],
                    );
                  } else {
                    return const Text('No VMs data available');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleAutomationCon(
      ContainerProvider provider, ContainerModel conModel) {
    final newAutomationState = !isAutomationRunning;
    final vmid = widget.containers.vmid ?? 0;

    provider.toggleAutomationCon(vmid.toString(), newAutomationState);
    _saveAutomationState(newAutomationState);

    setState(() {
      isAutomationRunning = newAutomationState;
    });
  }
}
