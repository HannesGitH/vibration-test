import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/extensions/list.dart';

import '../models/vibration/vibration.dart';

class PatternController extends ConsumerWidget {
  const PatternController({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(vibrationPatternProvider);

    onTouch(num relativeX, num relativeY) {
      final notifier = ref.read(vibrationPatternProvider.notifier);
      num x = max(
        ((relativeX.clamp(0, 1) + (1 / pattern.elements.length)) *
            pattern.totalDurationMS),
        pattern.elements.safeAt(2)?.durationMS ?? 0 - (resolutionInMS ~/ 2),
      );
      num y = (1 - relativeY.clamp(0, 1.1)) * MAX_VIBRATION_AMPLITUDE;
      if (_prevTouch != null) {
        num xp = max(
          ((_prevTouch!.x.clamp(0, 1) + (1 / pattern.elements.length)) *
              pattern.totalDurationMS),
          pattern.elements.safeAt(2)?.durationMS ?? 0 - (resolutionInMS ~/ 2),
        );
        num yp = (1 - _prevTouch!.y.clamp(0, 1.1)) * MAX_VIBRATION_AMPLITUDE;

        if (xp != x) {
          if (xp < x) {
            final tmpx = x;
            final tmpy = y;
            y = yp;
            yp = tmpy;
            x = xp;
            xp = tmpx;
          }
          final delta = (yp - y) / (xp - x);
          var currentX = x;
          while (currentX < xp) {
            notifier.changeAmplitudeAtMS(
              atMS: currentX.toInt(),
              newAmplitude: ((currentX - x) * delta + y).toInt(),
            );
            currentX += resolutionInMS;
          }
        }
      }
      // debugPrint('$relativeX $relativeY $x $y');

      notifier.changeAmplitudeAtMS(newAmplitude: y.toInt(), atMS: x.toInt());
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
            animationDuration: pattern.doNotAnimate ? 5 : 100,
          ),
        ));
  }
}

Point? _prevTouch;

class LineChartSample2 extends StatelessWidget {
  const LineChartSample2({
    super.key,
    required this.data,
    required this.max,
    required this.min,
    this.onTouchCallBack,
    this.animationDuration = 100,
  });

  final List<Point> data;
  final Point max;
  final Point min;
  final void Function(num, num)? onTouchCallBack;
  final int animationDuration;

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.primary,
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
      swapAnimationDuration:
          Duration(milliseconds: animationDuration), // Optional
    );
  }
}
