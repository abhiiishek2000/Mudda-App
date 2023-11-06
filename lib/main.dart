import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/route_generator.dart';
import 'package:mudda/ui/screens/edit_profile/controller/create_org_controller.dart';
import 'package:mudda/ui/screens/edit_profile/controller/org_profile_update_controller.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/login_screen/controller/login_screen_controller.dart';
import 'package:mudda/ui/screens/notification/controller/NotificationController.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';
import 'package:mudda/ui/shared/fb_sdk_event.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _messageHandler(RemoteMessage message) async {
  log("notification received ${message.notification!.body}");

  displayNotification(message);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications',
  'your channel description', // title
  importance: Importance.max,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppPreference().initialAppPreference();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: colorAppBackground, // status bar color
    statusBarIconBrightness:Brightness.dark
  ));
  FaceBookSdk.init();
  runApp(const MyApp());
}

Future displayNotification(RemoteMessage message) async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  //var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotification() );
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id, channel.name, 'your channel description',
      importance: Importance.max, priority: Priority.high, playSound: true);
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
  var macPlatformChannelSpecifics = const MacOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title,
    message.notification!.body,
    platformChannelSpecifics,
    payload: 'hello',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
// edit
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ScreenUtilInit(
        designSize: Size(constraints.maxWidth, constraints.maxHeight),
        builder: (BuildContext context, contexts) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData().copyWith(
            textTheme: GoogleFonts.nunitoSansTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          navigatorKey: navigatorKey,
          title: 'Mudda',
          initialRoute: RouteConstants.splashScreen,
          initialBinding: AppBidding(),
          getPages: RouteGenerator().getAllRoute(),
        ),
      );
    });
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppBidding extends Bindings {
  AppBidding();

  @override
  Future<void> dependencies() async {
    WidgetsFlutterBinding.ensureInitialized();

    Get.lazyPut<LoginScreenController>(() => LoginScreenController(),
        fenix: true);
    Get.lazyPut<SearchController>(() => SearchController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(),
        fenix: true);
    Get.lazyPut<CreateMuddaController>(() => CreateMuddaController(),
        fenix: true);
    Get.lazyPut<UserProfileUpdateController>(
        () => UserProfileUpdateController(),
        fenix: true);
    Get.lazyPut<LoginScreenController>(() => LoginScreenController(),
        fenix: true);
    Get.lazyPut<SearchController>(() => SearchController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(),
        fenix: true);
    Get.lazyPut<CreateMuddaController>(() => CreateMuddaController(),
        fenix: true);
    Get.lazyPut<UserProfileUpdateController>(
        () => UserProfileUpdateController(),
        fenix: true);
    Get.lazyPut<OrgProfileUpdateController>(() => OrgProfileUpdateController(),
        fenix: true);
    Get.lazyPut<CreateOrgController>(() => CreateOrgController(), fenix: true);
  }
}
