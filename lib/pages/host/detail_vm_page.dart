import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_app/widgets/arc_percentage.dart';
import 'package:shoes_app/widgets/manual_edit.dart';
import '../../model/vm_auto_mem.dart';
import '../../providers/vm_auto_mem_provider.dart';
import '../../theme/const.dart';

class DetailVMPage extends StatefulWidget {
  final VMDetailModel vms;
  const DetailVMPage(this.vms, {super.key});

  @override
  State<DetailVMPage> createState() => _DetailVMPageState();
}

class _DetailVMPageState extends State<DetailVMPage> {
  bool isAutomationRunning = false;
  bool isMemoryBelowThreshold = false;
  late VMAutoProvider vmProvider;

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
    vmProvider = Provider.of<VMAutoProvider>(context, listen: false);

    isAutomationRunning = widget.vms.isAutomationRunning ?? false;
    _loadAutomationState();

    double maxMemSizeInMB = widget.vms.maxmem! / 1048576;
    double currentMemSizeInMB = widget.vms.mem! / 1048576;

    double memThreshold = maxMemSizeInMB * 0.4;
    isMemoryBelowThreshold = currentMemSizeInMB < memThreshold;

    isMemoryBelowThreshold = calculateMemoryBelowThreshold(widget.vms);

    vmProvider.startPollingForVMDetail(widget.vms.vmid!);
  }

  @override
  void dispose() {
    super.dispose();
    vmProvider.stopPollingDetail();
  }

  bool calculateMemoryBelowThreshold(VMDetailModel vmDetail) {
    double maxMemSizeInMB = vmDetail.maxmem! / 1048576;
    double currentMemSizeInMB = vmDetail.mem! / 1048576;
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
    vmProvider = Provider.of<VMAutoProvider>(context);

    Widget header(VMDetailModel vmDetail) {
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
                    color: vmDetail.status == 'stopped'
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
                widget.vms.name!,
                style: secondaryTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: bold,
                ),
              ),
              Text(
                'ID: ${widget.vms.vmid!.toString()}',
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

    Widget content(VMDetailModel vmDetail) {
      String diskSizeInGB = convertToGB(vmDetail.disk!.toInt());
      String maxDiskSizeInGB =
          convertToGB(vmDetail.maxdisk!); // Corrected calculation
      String maxMemSizeInMB = convertToMB(vmDetail.maxmem!);

      String memory = vmDetail.mem! > 1073741824
          ? (vmDetail.mem! / 1073741824).toStringAsFixed(2)
          : (vmDetail.mem! / 1048576).toStringAsFixed(2);

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
                    maxValue: vmDetail.cpus!.toInt(),
                    usageValue: vmDetail.cpu!.toDouble(),
                    isPercentage: true,
                    displayValue: (vmDetail.cpu! * 100).toStringAsFixed(2),
                    unit: "Core(s)",
                    progressColor: Colors.white,
                  ),
                  ArcPercentage(
                    title: 'RAM',
                    maxValue: double.parse(maxMemSizeInMB),
                    usageValue: double.parse(memory),
                    unit: 'MiB',
                    progressColor: Colors.white,
                  ),
                  ArcPercentage(
                    title: 'HDD',
                    maxValue: double.parse(maxDiskSizeInGB),
                    usageValue: double.parse(diskSizeInGB),
                    unit: 'GiB',
                    progressColor: Colors.white,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ResourceInfoCard(
                    title: 'CPU',
                    maxValue: vmDetail.cpus!.toInt(),
                    usageValue: vmDetail.cpu!.toDouble(),
                    isPercentage: true,
                    displayValue: (vmDetail.cpu! * 100).toStringAsFixed(2),
                    unit: "Core(s)",
                    nameInput: 'CPU',
                    selectedResources: 'cpu',
                    vms: vmDetail,
                    iconImagePath: 'assets/icon_cpu.png',
                  ),
                  ResourceInfoCard(
                    title: 'RAM',
                    maxValue: double.parse(maxMemSizeInMB),
                    usageValue: double.parse(memory),
                    unit: 'MiB',
                    nameInput: 'RAM',
                    selectedResources: 'mem',
                    vms: vmDetail,
                    iconImagePath: 'assets/icon_ram.png',
                  ),
                  ResourceInfoCard(
                    title: 'HDD',
                    maxValue: double.parse(maxDiskSizeInGB),
                    usageValue: double.parse(diskSizeInGB),
                    unit: 'GiB',
                    nameInput: 'HDD',
                    selectedResources: 'disk',
                    vms: vmDetail,
                    iconImagePath: 'assets/icon_hdd.png',
                  ),
                ],
              ),
            ),
            // NOTE: Button Auto Add
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(
                  right: defaultMargin,
                  left: defaultMargin,
                  bottom: defaultMargin,
                  top: 200),
              child: TextButton(
                onPressed: () {
                  _toggleAutomation(vmProvider, vmDetail);
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
            // NOTE: Button Start VM
            // Container(
            //   width: double.infinity,
            //   margin: const EdgeInsets.only(
            //       bottom: defaultMargin,
            //       right: defaultMargin,
            //       left: defaultMargin),
            //   child: Column(
            //     children: [
            //       SizedBox(
            //         width: double.infinity,
            //         height: 50,
            //         child: TextButton(
            //           onPressed: () {
            //             if (widget.vms.status == 'running') {
            //               // Panggil fungsi untuk menghentikan VM
            //               Provider.of<VMAutoProvider>(context, listen: false)
            //                   .stopVM(widget.vms.vmid!);
            //             } else {
            //               // Panggil fungsi untuk memulai VM
            //               Provider.of<VMAutoProvider>(context, listen: false)
            //                   .startVM(widget.vms.vmid!);
            //             }
            //           },
            //           style: TextButton.styleFrom(
            //             backgroundColor: widget.vms.status == 'running'
            //                 ? Colors.red
            //                 : Colors.green,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(12),
            //             ),
            //           ),
            //           child: Text(
            //             widget.vms.status == 'running' ? 'Stop VM' : 'Start VM',
            //             style: primaryTextStyle.copyWith(
            //               fontSize: 16,
            //               fontWeight: medium,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    }

    return ChangeNotifierProvider<VMAutoProvider>.value(
      value: vmProvider,
      builder: (context, child) {
        final vmProvider = Provider.of<VMAutoProvider>(context, listen: false);
        return Scaffold(
          backgroundColor: bg6Color,
          body: ListView(
            children: [
              StreamBuilder<VMDetailModel>(
                stream: vmProvider.vmDetailStream(widget.vms.vmid!),
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
                    final vmDetail = snapshot.data!;
                    return Column(
                      children: [
                        header(vmDetail),
                        content(vmDetail),
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

  void _toggleAutomation(VMAutoProvider provider, VMDetailModel vmDetail) {
    final newAutomationState = !isAutomationRunning;
    final vmId = widget.vms.vmid ?? 0;

    provider.toggleAutomation(vmId, newAutomationState);
    _saveAutomationState(newAutomationState);

    setState(() {
      isAutomationRunning = newAutomationState;
    });
  }
}
