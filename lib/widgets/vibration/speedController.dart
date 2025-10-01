import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:squiggly_slider/slider.dart';

import 'package:vibrationtest/models/vibration/vibration.dart';

import '../../generated/l10n.dart';

class SpeedController extends ConsumerWidget {
  static const power = 3;
  const SpeedController({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(activeVibrationPatternProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).speed),
              Text(
                pattern.speedModifier.toStringAsFixed(2),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        SquigglySlider(
          value: pow(pattern.speedModifier, 1 / power).toDouble(),
          min: pow(0.1, 1 / power).toDouble(),
          max: pow(5, 1 / power).toDouble(),
          onChanged: (value) {
            ref
                .read(activeVibrationPatternProvider.notifier)
                .setSpeedModifier(pow(value, power));
          },
          onChangeEnd: (value) {
            ref
                .read(activeVibrationPatternProvider.notifier)
                .maybeContinueVib();
          },
          label: S.of(context).speed,
          squiggleAmplitude: pattern.isCurrentlyVibrating
              ? pattern.amplitudes.first.toDouble() / 80
              : 0.0,
          squiggleWavelength: 5.0,
          squiggleSpeed: 0.5,
        ),
      ],
    );
  }
}
