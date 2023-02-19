import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generated/l10n.dart';
import '../models/vibration/vibration.dart';

class BuzzModePage extends ConsumerWidget {
  const BuzzModePage({Key? key}) : super(key: key);
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  pattern.isCurrentlyVibrating ? Icons.stop : Icons.play_arrow),
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
    );
  }
}
