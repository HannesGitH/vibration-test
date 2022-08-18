import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/fragments/mainDrawer.dart';
import 'package:vibrationtest/widgets/pattern.dart';
import 'package:vibrationtest/widgets/vibration/repeatController.dart';
import 'package:vibrationtest/widgets/vibration/speedController.dart';
import 'package:vibrationtest/widgets/vibration/startVibrationFAB.dart';
import 'package:vibrationtest/widgets/vibration/storePatternButton.dart';

import '../generated/l10n.dart';
import '../models/vibration/vibration.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: [
          SaveCurrentPatternButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            SpeedController(),
            PatternController(),
            RepeatController(),
          ],
        ),
      ),
      floatingActionButton: const StartVibrationFAB(),
    );
  }
}

class SaveCurrentPatternButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(vibrationPatternProvider);
    return StorePatternButton(pattern: pattern);
  }
}
