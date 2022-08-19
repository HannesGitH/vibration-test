import 'package:flutter/material.dart';

import 'myListTile1.dart';

class OpenNewViewTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? newView;
  final String? route;
  final bool pop;

  const OpenNewViewTile({
    this.icon = Icons.open_in_full,
    required this.title,
    this.newView,
    Key? key,
    this.onPop,
    this.route,
    this.pop = true,
  })  : assert((route ?? newView) != null,
            'either route or view must be provided'),
        assert((route == null) || (newView == null),
            'only one of route or view can be provided'),
        super(key: key);

  final Function? onPop;

  @override
  Widget build(BuildContext context) {
    return MyCardListTile1(
      icon: icon,
      text: title,
      onTap: () {
        if (pop) Navigator.pop(context);
        if (route != null) {
          Navigator.pushNamed(context, route!).then((value) => onPop);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => newView!,
            ),
          ).then((value) => onPop);
        }
      },
    );
  }
}
