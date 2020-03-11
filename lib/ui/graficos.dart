/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.ChartTitle('Ondas(m)',
            titleStyleSpec: charts.TextStyleSpec(fontSize: 10,
              color: charts.ColorUtil.
              fromDartColor(Colors.white)),
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea),
      ],
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 10, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white)
          )
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
      renderSpec: new charts.SmallTickRendererSpec(

    // Tick and Label styling here.
    labelStyle: new charts.TextStyleSpec(
    fontSize: 10, // size in Pts.
    color: charts.MaterialPalette.white),),

            tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                desiredTickCount: 2,
                desiredMaxTickCount: 1,
                zeroBound: true,

            ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('1', 0.5),
      new OrdinalSales('2', 0.6),
      new OrdinalSales('3', 0.8),
      new OrdinalSales('4', 0.5),
      new OrdinalSales('5', 0.7),
      new OrdinalSales('6', 0.8),
      new OrdinalSales('7', 0.6),
      new OrdinalSales('8', 0.4),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.
        fromDartColor(Colors.redAccent.withOpacity(0.5)),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}