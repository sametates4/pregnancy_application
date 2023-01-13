import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class ChartToRun extends StatelessWidget {
  const ChartToRun({Key? key, required this.label, required this.data}) : super(key: key);
  final List<List<double>> data;
  final List<String> label;
  @override
  Widget build(BuildContext context) {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    chartOptions = const ChartOptions(
      dataContainerOptions: DataContainerOptions(
        startYAxisAtDataMinRequested: true,
      ),
    );
    chartData = ChartData(
      dataRowsColors: const [Colors.red],
      dataRows: data,
      xUserLabels: label,
      dataRowsLegends: const [
        'Hemogram',
      ],
      chartOptions: chartOptions,
    );
    var verticalBarChartContainer = VerticalBarChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );
    var verticalBarChart = VerticalBarChart(
      painter: VerticalBarChartPainter(
        verticalBarChartContainer: verticalBarChartContainer,
      ),
    );
    return verticalBarChart;
  }
}
