part of 'pattern.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart({
    super.key,
    required this.data,
    required this.max,
    required this.min,
    this.onTouchCallBack,
    this.animationDuration = 100,
    this.showDot = false,
  });

  final List<Point> data;
  final Point max;
  final Point min;
  final void Function(num, num)? onTouchCallBack;
  final int animationDuration;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.primary,
    ];

    FlDotPainter _dotPainter(
        FlSpot spot, double xPercentage, LineChartBarData bar, int index,
        {double? size}) {
      return FlDotCirclePainter(
        radius: size != null ? size * 2 : 10,
        color: Theme.of(context).colorScheme.secondary,
        strokeColor: Colors.transparent,
      );
    }

    LineChartData mainData() {
      return LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          touchCallback: (flE, ltr) {
            final bounds = context.findRenderObject()?.paintBounds;
            final totalWidth = bounds?.width ?? 1;
            final totalHeight = bounds?.height ?? 1;

            final x = (flE.localPosition?.dx != null && bounds != null)
                ? ((flE.localPosition!.dx - 0 /*bounds.left*/) / totalWidth)
                : null;
            final y = (flE.localPosition?.dy != null && bounds != null)
                ? ((flE.localPosition!.dy + 0 /*bounds.bottom*/) / totalHeight)
                : null;
            if (flE.isInterestedForInteractions && (x != null && y != null)) {
              onTouchCallBack?.call(x, y);
              _prevTouch = Point(x, y);
            } else
              _prevTouch = null;
          },
          enabled: onTouchCallBack != null,
          // getTouchedSpotIndicator: (barData, spotIndexes) => [],
          // touchTooltipData:
          //     LineTouchTooltipData(getTooltipItems: ((touchedSpots) => [])),
        ),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: min.x.toDouble(),
        maxX: max.x.toDouble(),
        minY: min.y.toDouble(),
        maxY: max.y.toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: data
                .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
                .toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            barWidth: 7,
            isStrokeCapRound: true,
            dotData: FlDotData(
              getDotPainter: _dotPainter,
              show: showDot,
              checkToShowDot: (spot, barData) => barData.spots.first == spot,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .asMap()
                    .map((i, color) => MapEntry(
                        i, color.withOpacity(i / gradientColors.length * 0.5)))
                    .values
                    .toList(),
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ],
      );
    }

    return LineChart(
      mainData(),
      swapAnimationDuration:
          Duration(milliseconds: animationDuration), // Optional
    );
  }
}
