import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DiagramChart extends StatefulWidget {
  const DiagramChart({super.key});

  @override
  State<DiagramChart> createState() => _DiagramChartState();
}

class _DiagramChartState extends State<DiagramChart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: SfCartesianChart(
          title: ChartTitle(text: "Diagram"),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.longPress,
          ),
          series: <ChartSeries>[
            ColumnSeries<SalesData, double>(
              width: 0.05,
              dataSource: getColumnData(),
              yValueMapper: (SalesData sales, _) => sales.y,
              xValueMapper: (SalesData sales, _) => sales.x,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.inside,
              ),
              enableTooltip: true,
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  double x, y;
  SalesData(this.x, this.y);
}

dynamic getColumnData() {
  List<SalesData> columndata = <SalesData>[
    SalesData(10, 20),
    SalesData(30, 40),
    SalesData(50, 50),
    SalesData(70, 80),
  ];
  return columndata;
}
