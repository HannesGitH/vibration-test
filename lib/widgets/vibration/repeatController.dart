import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/models/vibration/vibration.dart';

import '../../generated/l10n.dart';

class RepeatController extends ConsumerWidget {
  const RepeatController({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(vibrationPatternProvider);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).repeat),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.arrow_forward,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(!pattern.onRepeat ? 1 : 0.2)),
              Switch(
                  value: pattern.onRepeat,
                  onChanged:
                      ref.read(vibrationPatternProvider.notifier).setOnRepeat),
              Icon(Icons.repeat_rounded,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(pattern.onRepeat ? 1 : 0.2)),
            ],
          ),
        ],
      ),
    );
  }
}
