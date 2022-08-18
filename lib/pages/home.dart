import 'package:flutter/material.dart';
import 'package:vibrationtest/fragments/mainDrawer.dart';

import '../generated/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
      ),
    );
  }
}
