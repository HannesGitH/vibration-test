import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class VibrationStore extends StatelessWidget {
  const VibrationStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).vibrationStoreTitle),
      ),
      body: Center(
        child: Text(S.of(context).stillWorkInProgress),
      ),
    );
  }
}
