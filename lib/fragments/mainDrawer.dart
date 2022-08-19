import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../generated/l10n.dart';
import '../widgets/openNewViewTile.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var settingsTile = OpenNewViewTile(
    //   title: S.of(context).settings,
    //   icon: Icons.settings,
    //   newView: SettingsView(
    //     logoutcontext: context,
    //   ),
    // );

    // ignore: unused_local_variable
    var counterTile = OpenNewViewTile(
      title: S.of(context).counter,
      icon: Icons.control_point_duplicate_rounded,
      route: '/counter',
    );

    var storeTile = OpenNewViewTile(
      title: S.of(context).vibrationStoreTitle,
      icon: Icons.store,
      route: '/store',
    );

    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.
        //padding: EdgeInsets.zero,
        children: <Widget>[
          const MainDrawerHeader(),
          storeTile,
          const Spacer(),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: VersionInfo(),
            ),
          ),
        ],
      ),
    );
  }
}

class VersionInfo extends StatelessWidget {
  const VersionInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          return Text(
            '${snapshot.data?.appName ?? 'Vibration'} ${snapshot.data?.buildNumber ?? '...'}',
          );
        });
  }
}

class MainDrawerHeader extends StatelessWidget {
  const MainDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        // gradient: LinearGradient(begin: Alignment.topLeft, colors: [
        //   Theme.of(context).primaryColorDark.withAlpha(200),
        //   Theme.of(context).canvasColor,
        //   //Theme.of(context).primaryColor.withAlpha(250),
        // ]),
        //color: Theme.of(context).primaryColor,
      ),
      child: const Center(
        child: Image(image: AssetImage('assets/icon/icon.png')),
      ),
    );
  }
}
