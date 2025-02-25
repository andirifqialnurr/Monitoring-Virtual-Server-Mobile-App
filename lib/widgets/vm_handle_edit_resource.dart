import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/edit_vm_provider.dart';
import 'package:shoes_app/providers/vm_auto_mem_provider.dart';
import 'package:shoes_app/theme/const.dart';

class VMHandleEditResource extends StatefulWidget {
  final String selectedResources;

  const VMHandleEditResource({
    super.key,
    required this.selectedResources,
  });

  @override
  State<VMHandleEditResource> createState() => _VMHandleEditResourceState();
}

class _VMHandleEditResourceState extends State<VMHandleEditResource> {
  static TextEditingController idController = TextEditingController(text: '');
  static TextEditingController cpuController = TextEditingController(text: '');
  static TextEditingController diskController = TextEditingController(text: '');
  static TextEditingController memController = TextEditingController(text: '');

  late String id;
  late String cpu;
  late String disk;
  late String mem;
  late String selectedResource;

  bool isLoading = false;

  late VMAutoProvider vmProvider;

  @override
  void initState() {
    super.initState();
    selectedResource = widget
        .selectedResources; // Initialize selectedResource with the value from the widget
  }

  @override
  Widget build(BuildContext context) {
    EditVMProvider editVMProvider = Provider.of<EditVMProvider>(context);
    vmProvider = Provider.of<VMAutoProvider>(context);

    void handleEditResources() async {
      setState(() {
        isLoading = true;
      });

      if (selectedResource.isNotEmpty) {
        if (selectedResource == 'cpu') {
          if (cpu.isNotEmpty) {
            if (await editVMProvider.editVMCPU(
              id: idController.text,
              cpu: cpuController.text,
            )) {
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: alertColor,
                content: Text(
                  'CPU field is empty',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else if (selectedResource == 'disk') {
          if (disk.isNotEmpty) {
            if (await editVMProvider.editVMHDD(
              id: idController.text,
              disk: diskController.text,
            )) {
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: alertColor,
                content: Text(
                  'Disk field is empty',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else if (selectedResource == 'mem') {
          if (mem.isNotEmpty) {
            if (await editVMProvider.editVMRAM(
              id: idController.text,
              mem: memController.text,
            )) {
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: alertColor,
                content: Text(
                  'Memory field is empty',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'No Field to Edit',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Resource'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: handleEditResources,
                child: const Text('Edit Resource'),
              ),
      ),
    );
  }
}
