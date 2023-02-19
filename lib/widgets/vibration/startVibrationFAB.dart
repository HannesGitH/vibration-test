import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/models/vibration/vibration.dart';
import 'package:vibrationtest/pages/buzzmode.dart';

class StartVibrationFAB extends ConsumerWidget {
  const StartVibrationFAB({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(activeVibrationPatternProvider);

    return InkWell(
      customBorder: Theme.of(context).floatingActionButtonTheme.shape,
      borderRadius: BorderRadius.circular(20),
      onLongPress: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BuzzModePage(),
        ),
      ),
      child: FloatingActionButton(
        onPressed: () {
          !pattern.isCurrentlyVibrating
              ? ref
                  .read(activeVibrationPatternProvider.notifier)
                  .startVib(context: context)
              : ref.read(activeVibrationPatternProvider.notifier).stopVib();
        },
        child:
            Icon(pattern.isCurrentlyVibrating ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}
