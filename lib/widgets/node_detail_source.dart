import 'package:flutter/material.dart';
import 'package:shoes_app/model/node_model.dart';
import 'package:shoes_app/theme/const.dart';

// ignore: must_be_immutable
class NodeDetailSource extends StatefulWidget {
  final String title;
  final num maxValue;
  final double usageValue;
  final bool isPercentage;
  final String? displayValue;
  final String? unit;
  final String? nameInput;
  final String? iconImagePath;

  final NodeModel? nodes;

  const NodeDetailSource({
    super.key,
    required this.title,
    required this.maxValue,
    required this.usageValue,
    this.isPercentage = false,
    this.displayValue,
    this.unit,
    required this.nodes,
    this.nameInput,
    this.iconImagePath,
  });

  @override
  State<NodeDetailSource> createState() => _NodeDetailSourceState();
}

class _NodeDetailSourceState extends State<NodeDetailSource> {
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
              Row(
                children: [
                  Image.asset(
                    widget.iconImagePath!,
                    width: 17,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
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
        ],
      ),
    );
  }
}
