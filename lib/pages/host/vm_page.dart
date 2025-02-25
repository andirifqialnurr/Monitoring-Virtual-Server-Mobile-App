import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/model/vm_auto_mem.dart';
import 'package:shoes_app/providers/vm_auto_mem_provider.dart';
import 'package:shoes_app/theme/const.dart';
import 'package:shoes_app/widgets/vm_tile.dart';

class VMPage extends StatefulWidget {
  const VMPage({super.key});

  @override
  State<VMPage> createState() => _VMPageState();
}

class _VMPageState extends State<VMPage> {
  late VMAutoProvider vmAutoProvider;

  @override
  void initState() {
    // Start polling for VM data when entering the page
    super.initState();
    Provider.of<VMAutoProvider>(context, listen: false).setShouldPollVM(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Simpan referensi provider
    vmAutoProvider = Provider.of<VMAutoProvider>(context, listen: false);
    // Mulai polling VM
    vmAutoProvider.setShouldPollVM(true);
  }

  @override
  void dispose() {
    vmAutoProvider.setShouldPollVM(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'Virtual Machine',
          style: primaryTextStyle,
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      );
    }

    Widget content(BuildContext context, List<VMDetailModel> vmList) {
      // Sort the VM list based on name and then VM ID
      vmList.sort((vm1, vm2) {
        final nameComparison = vm1.name!.compareTo(vm2.name!);
        if (nameComparison != 0) {
          return nameComparison;
        }
        return vm1.vmid!.compareTo(vm2.vmid!);
      });
      // print('Number of containers: ${vms.length}');
      return Container(
        color: bg3Color,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          children: vmList
              .map(
                (vms) => VMTile(vms),
              )
              .toList(),
        ),
      );
    }

    return Builder(builder: (BuildContext builderContext) {
      return Scaffold(
        appBar: header(),
        body: StreamBuilder<List<VMDetailModel>>(
          stream: Provider.of<VMAutoProvider>(context, listen: false).vmStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<VMDetailModel> vmList = snapshot.data!;
              return content(context, vmList);
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
