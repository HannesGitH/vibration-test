import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
    final maxAdHeight = MediaQuery.of(context).size.height * 0.25;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: const [
          SaveCurrentPatternButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxAdHeight,
            ),
            child: MyBannerAdWidget(
                adSize: AdSize.getInlineAdaptiveBannerAdSize(
              MediaQuery.of(context).size.width.toInt(),
              maxAdHeight.toInt(),
            )),
          ),
          const Expanded(flex: 5, child: PatternGallery()),
          const SpeedController(),
          const Expanded(flex: 10, child: PatternController()),
          const RepeatController(),
        ],
      ),
      floatingActionButton: const StartVibrationFAB(),
    );
  }
}
