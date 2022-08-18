import 'package:flutter/material.dart';

class MyCardListTile1 extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? subtext;
  final Widget? child;
  final void Function()? onTap;

  const MyCardListTile1({
    IconData? icon,
    this.text = "Click mich if you dare",
    this.subtext,
    this.onTap,
    this.child,
  }) : this.icon = icon ?? Icons.apps;

  @override
  Widget build(BuildContext context) {
    final makeListTile = ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        leading: Icon(icon), // color: Colors.amber[400]),
        title: child != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 140,
                    child: Text(
                      text,
                      //style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  child ?? Container(),
                ],
              )
            : Text(
                text,
                //style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
        subtitle: (subtext != null) ? Text(subtext ?? "") : null,
        trailing: Icon(
            Icons.keyboard_arrow_right) //, color: Colors.white, size: 30.0),
        );

    return Card(
      clipBehavior: Clip.antiAlias,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0),
      // ),
      shadowColor: Colors.transparent,
      // elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: makeListTile,
    );
  }
}
