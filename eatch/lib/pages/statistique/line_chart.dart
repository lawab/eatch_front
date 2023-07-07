import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData(2021, 35),
      SalesData(2022, 28),
      SalesData(2023, 34),
      /*SalesData(2013, 32),
      SalesData(2014, 40)*/
    ];

    return SafeArea(
      child: SizedBox(
        child: SfCartesianChart(
          title: ChartTitle(text: "Chiffre par année"),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.longPress,
          ),
          series: <ChartSeries>[
            // Renders line chart
            LineSeries<SalesData, double>(
              dataSource: chartData,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
              enableTooltip: true,
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}
