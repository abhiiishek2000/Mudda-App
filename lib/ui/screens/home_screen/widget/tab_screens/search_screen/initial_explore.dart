import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserProfileModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/search_controller_new.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/trending_leaders.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/trending_new_users.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/trending_orgs.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';

import '../../../../../../core/constant/route_constants.dart';
import '../../../../../../core/preferences/preference_manager.dart';
import '../../../../../../core/preferences/preferences_key.dart';
import '../../../../../../dio/Api/Api.dart';
import '../../../../../../model/SearchModel.dart';

class InitialExplore extends StatefulWidget {
  const InitialExplore({Key? key}) : super(key: key);

  @override
  State<InitialExplore> createState() => _InitialExploreState();
}

class _InitialExploreState extends State<InitialExplore> {
  ScrollController searchScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
        TrendingLeaders(),
        TrendingOrgs(),
        TrendingNewUsers()
      ]),
    );
  }


}
