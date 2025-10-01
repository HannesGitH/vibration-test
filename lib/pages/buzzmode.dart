import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generated/l10n.dart';
import '../models/vibration/vibration.dart';
import '../widgets/pattern/pattern.dart';

class BuzzModePage extends ConsumerWidget {
  const BuzzModePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(activeVibrationPatternProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).buzzMode),
      ),
      body: InkWell(
        onTapDown: (details) {
          ref
              .read(activeVibrationPatternProvider.notifier)
              .startVib(context: context);
        },
        onTapUp: (details) {
          ref.read(activeVibrationPatternProvider.notifier).stopVib();
        },
        onTapCancel: () {
          ref.read(activeVibrationPatternProvider.notifier).stopVib();
        },
        highlightColor: Colors.transparent, 
        child: Stack(
          children: [
            IgnorePointer(
              child: MyLineChart(
                data: pattern.points,
                min: Point(
                    pattern.elements.isEmpty
                        ? 0
                        : pattern.elements.first.durationMS,
                    0),
                max: Point(
                  pattern.totalDurationMS,
                  MAX_VIBRATION_AMPLITUDE,
                ),
                animationDuration: pattern.doNotAnimate ? 5 : 100,
                showDot: pattern.isCurrentlyVibrating,
              ),
            ),
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container()),
            Container(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            ),
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(pattern.isCurrentlyVibrating
                          ? Icons.stop
                          : Icons.play_arrow),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          pattern.isCurrentlyVibrating
                              ? S.of(context).buzzmodeStopInstruction
                              : S.of(context).buzzmodeInstruction,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
