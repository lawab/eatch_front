import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Lundi', 9),
      ChartData('Mardi', 11),
      ChartData('Mercredi', 10),
      ChartData('Jeudi', 12),
      ChartData('Vendredi', 8),
      ChartData('Samedi', 25),
      ChartData('Dimanche', 25)
    ];

    return SafeArea(
      child: SizedBox(
        child: SfCircularChart(
          title: ChartTitle(text: "Affluence par jour"),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.longPress,
            animationDuration: 5,
          ),
          series: <CircularSeries>[
            // Render pie chart
            PieSeries<ChartData, String>(
              dataSource: chartData,
              //pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
              ),
              enableTooltip: true,
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    /*this.color*/
  );
  final String x;
  final double y;
  //final Color color;
}
