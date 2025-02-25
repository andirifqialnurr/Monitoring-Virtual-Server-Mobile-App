import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/model/con_model.dart';
import 'package:shoes_app/providers/edit_con_provider.dart';
import 'package:shoes_app/theme/const.dart';

// ignore: must_be_immutable
class ResourceInfoCardCon extends StatefulWidget {
  final String title;
  final num maxValue;
  final double usageValue;
  final bool isPercentage;
  final String? displayValue;
  final String? unit;
  final String? nameInput;
  final String? selectedResources;
  final String? iconImagePath;

  final ContainerModel? containers;

  const ResourceInfoCardCon({
    super.key,
    required this.title,
    required this.maxValue,
    required this.usageValue,
    this.isPercentage = false,
    this.displayValue,
    this.unit,
    required this.containers,
    this.nameInput,
    this.selectedResources,
    this.iconImagePath,
  });

  @override
  State<ResourceInfoCardCon> createState() => _ResourceInfoCardConState();
}

class _ResourceInfoCardConState extends State<ResourceInfoCardCon> {
  static TextEditingController idController = TextEditingController(text: '');
  static TextEditingController cpuController = TextEditingController(text: '');
  static TextEditingController diskController = TextEditingController(text: '');
  static TextEditingController memController = TextEditingController(text: '');

  late String id;
  late String cpu;
  late String disk;
  late String mem;
  late String selectedResource = widget.selectedResources!;

  bool isLoading = false;

  String convertToGB(int sizeInBytes) {
    double sizeInGB = sizeInBytes / 1073741824;
    return sizeInGB.toStringAsFixed(2);
  }

  String convertToMB(int sizeInBytes) {
    double sizeInMB = sizeInBytes / 1048576;
    return sizeInMB.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    EditContainerProvider editConProvider =
        Provider.of<EditContainerProvider>(context);

    void handleEditResources(BuildContext context) async {
      setState(() {
        isLoading = true;
      });

      if (selectedResource.isNotEmpty) {
        if (selectedResource == 'cpu') {
          if (cpu.isNotEmpty) {
            if (await editConProvider.editConCPU(
              id: idController.text,
              cpu: cpuController.text,
            )) {
              Navigator.of(context, rootNavigator: true).pop();
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
            if (await editConProvider.editConHDD(
              id: idController.text,
              disk: diskController.text,
            )) {
              Navigator.of(context, rootNavigator: true).pop();
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
            if (await editConProvider.editConRAM(
              id: idController.text,
              mem: memController.text,
            )) {
              Navigator.of(context, rootNavigator: true).pop();
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

    Widget idInput() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Container ID',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/Username_Icon.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            id = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: idController,
                        decoration: InputDecoration.collapsed(
                          hintText: widget.containers!.vmid.toString(),
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget cpuInput() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CPU(s)',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      widget.iconImagePath!,
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            cpu = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: cpuController,
                        decoration: InputDecoration.collapsed(
                          hintText: widget.containers!.cpus.toString(),
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget diskInput() {
      String maxDiskSizeInGB = convertToGB(widget.containers!.maxdisk!);
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disk(s) GiB',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      widget.iconImagePath!,
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            disk = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: diskController,
                        decoration: InputDecoration.collapsed(
                          hintText: maxDiskSizeInGB,
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget memInput() {
      String formattedMaxMem = (widget.containers!.maxmem! >= 1073741824)
          ? '${(widget.containers!.maxmem! / 1073741824).toStringAsFixed(2)} GB'
          : '${(widget.containers!.maxmem! / 1048576).toStringAsFixed(2)} MB';

      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory(s) MiB',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      widget.iconImagePath!,
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            mem = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: memController,
                        decoration: InputDecoration.collapsed(
                          hintText: formattedMaxMem,
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    // Dialog Add CPU
    Future<void> resourcesDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: 320,
          child: AlertDialog(
            backgroundColor: bg3Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  idInput(),
                  selectedResource == 'cpu'
                      ? cpuInput()
                      : selectedResource == 'disk'
                          ? diskInput()
                          : memInput(),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 320,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        handleEditResources(context);
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
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
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 10,
        left: defaultMargin,
        right: defaultMargin,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg2Color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 1.0),
              Text(
                widget.isPercentage
                    ? "${widget.displayValue}% of ${widget.maxValue.toStringAsFixed(0)} ${widget.unit}"
                    : "${widget.usageValue.toStringAsFixed(2)} ${widget.unit} of ${widget.maxValue.toStringAsFixed(2)} ${widget.unit}",
                style: priceTextStyle.copyWith(
                  fontWeight: semibold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 50,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      resourcesDialog();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    child: Text(
                      'Edit',
                      style: primaryTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(width: 5.0),
                // SizedBox(
                //   width: 50,
                //   height: 30,
                //   child: TextButton(
                //     onPressed: () {},
                //     style: TextButton.styleFrom(
                //         backgroundColor: Colors.green,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         )),
                //     child: Text(
                //       'Auto',
                //       style: primaryTextStyle.copyWith(
                //         fontSize: 12,
                //         fontWeight: medium,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
