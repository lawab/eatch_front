import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BubleChart extends StatefulWidget {
  const BubleChart({super.key});

  @override
  State<BubleChart> createState() => _BubleChartState();
}

class _BubleChartState extends State<BubleChart> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: SfCartesianChart(
          title: ChartTitle(text: "Buble"),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
          tooltipBehavior: _tooltip,
          series: <ChartSeries<_ChartData, String>>[
            BubbleSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              //name: 'Gold',
              color: const Color.fromRGBO(8, 142, 255, 1),
              enableTooltip: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
