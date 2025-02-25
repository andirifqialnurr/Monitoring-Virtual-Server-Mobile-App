import 'package:flutter/material.dart';
import '../../theme/const.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<_SalesData> data = [
    _SalesData('Jan', 12),
    _SalesData('Feb', 17),
    _SalesData('Mar', 20),
    _SalesData('Apr', 8),
    _SalesData('May', 5)
  ];
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'Message Support',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget test() {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SfCartesianChart(
              title:
                  ChartTitle(text: 'Test Chart', textStyle: primaryTextStyle),
              primaryXAxis: CategoryAxis(),
              legend: Legend(
                isVisible: true,
                textStyle: primaryTextStyle,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: false,
                textStyle: primaryTextStyle,
              ),
              backgroundColor: bg3Color,
              series: <CartesianSeries<dynamic, dynamic>>[
                LineSeries<_SalesData, String>(
                  dataSource: data,
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  name: 'CPU',
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: primaryTextStyle,
                  ),
                  color: secondaryColor,
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: header(),
      body: test(),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
