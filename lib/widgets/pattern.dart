import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vibration/vibration.dart';

class PatternController extends ConsumerWidget {
  const PatternController({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(vibrationPatternProvider);

    onTouch(num? relativeX, num? relativeY) {
      if ((relativeX ?? relativeY) != null) {
        final num x = relativeX!.clamp(0.01, 1) * pattern.totalDurationMS;
        final num y = (1 - relativeY!.clamp(0, 1)) * MAX_VIBRATION_AMPLITUDE;
        ref
            .read(vibrationPatternProvider.notifier)
            .changeAmplitudeAtMS(newAmplitude: y.toInt(), atMS: x.toInt());
      }
    }

    final firstDuration =
        pattern.elements.isEmpty ? 0 : pattern.elements.first.durationMS;

    final data = pattern.points;
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: MAX_VIBRATION_AMPLITUDE.toDouble(),
          child: LineChartSample2(
            onTouchCallBack: onTouch,
            data: data,
            min: Point(firstDuration, 0),
            max: Point(
              pattern.totalDurationMS,
              MAX_VIBRATION_AMPLITUDE,
            ),
          ),
        ));
  }
}

class LineChartSample2 extends StatelessWidget {
  const LineChartSample2({
    super.key,
    required this.data,
    required this.max,
    required this.min,
    this.onTouchCallBack,
  });

  final List<Point> data;
  final Point max;
  final Point min;
  final void Function(num?, num?)? onTouchCallBack;

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.primaryContainer,
    ];

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
            if (flE.isInterestedForInteractions) onTouchCallBack?.call(x, y);
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
              show: false,
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
    );
  }
}
