import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/fragments/mainDrawer.dart';
import 'package:vibrationtest/widgets/pattern/pattern.dart';
import 'package:vibrationtest/widgets/patternGallery.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).colorScheme.surface,
    ));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: [
          SaveCurrentPatternButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Expanded(
            flex: 1,
            child: Spacer(),
          ),
          Expanded(flex: 5, child: PatternGallery()),
          SpeedController(),
          Expanded(flex: 10, child: PatternController()),
          RepeatController(),
        ],
      ),
      floatingActionButton: const StartVibrationFAB(),
    );
  }
}

class SaveCurrentPatternButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(activeVibrationPatternProvider);
    return StorePatternButton(pattern: pattern);
  }
}
