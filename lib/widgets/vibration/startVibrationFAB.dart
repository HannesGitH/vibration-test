import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/models/vibration/vibration.dart';

import '../../generated/l10n.dart';

class StartVibrationFAB extends ConsumerWidget {
  const StartVibrationFAB({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(vibrationPatternProvider);

    return FloatingActionButton(
      onPressed: () {
        !pattern.isCurrentlyVibrating
            ? ref
                .read(vibrationPatternProvider.notifier)
                .startVib(context: context)
            : ref.read(vibrationPatternProvider.notifier).stopVib();
      },
      child: Icon(pattern.isCurrentlyVibrating ? Icons.stop : Icons.play_arrow),
    );
  }
}
