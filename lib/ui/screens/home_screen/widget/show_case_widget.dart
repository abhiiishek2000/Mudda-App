import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {Key? key,
      required this.globalKey,
      required this.title,
      required this.description,
      this.shapeBorder = const CircleBorder(),
      required this.child})
      : super(key: key);

  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Showcase(
        // onTargetClick: () async {
        //   SharedPreferences pref = await SharedPreferences.getInstance();
        //   pref.setBool('topicsShowCaseWatched ', true);
        //   print(
        //       'topicsShowCaseWatched function ${pref.getBool('topicsShowCaseWatched')}');
        // },
        key: globalKey,
        title: title,
        titleAlignment: TextAlign.center,
        description: description,
        child: child);
  }
}
