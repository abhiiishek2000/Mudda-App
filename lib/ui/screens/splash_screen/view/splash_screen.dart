import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/ui/screens/splash_screen/controller/splash_controller.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/text_style.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  SplashController splashController = Get.put(SplashController());

  Future<void> initDynamicLinks() async {
    print('called');
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      print('uri ${uri.toString()}');
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        log('queryParams ${queryParams.toString()}');
      }
    }).onError((error) {
      log('onLink error $error');
    });
  }
@override
  void initState() {
  initDynamicLinks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Container(
          // color: const Color.fromARGB(139, 0, 0, 0),
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          // child: Image.asset(
          //   'assets/png/mudda.gif',
          // )),
      ));
  }}

