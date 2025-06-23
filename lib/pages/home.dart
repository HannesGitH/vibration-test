import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibrationtest/fragments/mainDrawer.dart';
import 'package:vibrationtest/widgets/ads/wrapper.dart';
import 'package:vibrationtest/widgets/pattern/pattern.dart';
import 'package:vibrationtest/widgets/patternGallery.dart';
import 'package:vibrationtest/widgets/vibration/repeatController.dart';
import 'package:vibrationtest/widgets/vibration/speedController.dart';
import 'package:vibrationtest/widgets/vibration/startVibrationFAB.dart';
import 'package:vibrationtest/widgets/vibration/storePatternButton.dart';

import '../generated/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).colorScheme.surface,
    ));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: const [
          SaveCurrentPatternButton(),
        ],
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MyBannerAdWidget(),
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
