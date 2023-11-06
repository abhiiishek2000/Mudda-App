import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  @override
  final Widget child;
  final double height;
  final Color backgroundColor;

  CustomAppBar(
      {Key? key, required this.child,
      this.height = kToolbarHeight,
      this.backgroundColor = Colors.transparent})
      : super(key: key, child: child, preferredSize: Size.fromHeight(height));

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 35, left: 10, right: 10),
      height: preferredSize.height,
      color: backgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }
}
