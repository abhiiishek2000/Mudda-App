import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constant/route_constants.dart';
import '../../core/utils/color.dart';
import '../../core/utils/size_config.dart';
import '../../core/utils/text_style.dart';
import '../../model/PostForMuddaModel.dart';
import '../screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'create_dynamic_link.dart';
import 'get_started_button.dart';

reportPostDialogBox(BuildContext context, String muddaId) {
  final muddaNewsController = Get.put(MuddaNewsController());
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: Get.height * 0.25,
            width: Get.width * 0.45,
            color: Colors.white,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  commonPostText(
                      text: "Report Post",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                        reportDialogBox(context, muddaId, true, false, false);
                      }),
                  cDivider(margin: 20),
                  commonPostText(
                      text: "Report User",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                      }),
                  cDivider(margin: 20),
                  Obx(() =>
                      !muddaNewsController.postForMudda.value.isUserBlocked!
                          ? commonPostText(
                              text: "Block User",
                              color: colorGrey,
                              size: 13,
                              onPressed: () {
                                _showBlockDialog(context).then(
                                    (value) => {Navigator.pop(context, value)});
                              })
                          : commonPostText(
                              text: "Unblock",
                              color: colorGrey,
                              size: 13,
                              onPressed: () {
                                _showUnBlockDialog(context).then(
                                    (value) => {Navigator.pop(context, value)});
                              })),
                  cDivider(margin: 20),
                  commonPostText(
                      text: "Share Post",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                        CreateMyDynamicLinksClass()
                            .createDynamicLink(
                                true, '/muddaDetailsScreen?id=$muddaId')
                            .then(
                                (value) => Share.share("$shareMessage$value"));
                        // Share.share(
                        //   '${Const.shareUrl}mudda/$muddaId',
                        // );
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

reportMuddaBazzDialogBox(BuildContext context, String muddaId) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: Get.height * 0.2,
            width: Get.width * 0.4,
            color: Colors.white,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  commonPostText(
                      text: "Report Post",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                        reportDialogBox(context, muddaId, true, false, false);
                      }),
                  cDivider(margin: 20),
                  commonPostText(
                      text: "Report User",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                      }),
                  cDivider(margin: 20),
                  commonPostText(
                      text: "Share Post",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                        CreateMyDynamicLinksClass()
                            .createDynamicLink(
                                true, '/muddaDetailsScreen?id=$muddaId')
                            .then(
                                (value) => Share.share("$shareMessage$value"));
                        // Share.share(
                        //   '${Const.shareUrl}mudda/$muddaId',
                        // );
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

reportPostDeleteDialogBox(BuildContext context, String muddaId) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: 169,
            width: 168,
            color: Colors.white,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonPostText(
                      text: "Delete Post",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        // Get.back();
                        //reportDialogBox(context, muddaId, true, false, false);
                        _showDeletePostDialog(context, muddaId)
                            .then((value) => {Navigator.pop(context, value)});
                      }),
                  // cDivider(margin: 60),
                  // commonPostText(
                  //     text: "Edit Post",
                  //     color: colorGrey,
                  //     size: 13,
                  //     onPressed: () {
                  //       Get.toNamed(
                  //           RouteConstants.editPostScreen);
                  //     }),
                  cDivider(margin: 60),
                  commonPostText(
                      text: "Share Post",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                        CreateMyDynamicLinksClass()
                            .createDynamicLink(
                                true, '/muddaDetailsScreen?id=$muddaId')
                            .then((value) => Share.share(value));
                        // Share.share(
                        //   '${Const.shareUrl}mudda/$muddaId',
                        // );
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

reportQuotePostDialogBox(BuildContext context, Quote quote) {
  final profileController = Get.put(ProfileController());
  profileController.quotesOrActivity.value = quote;
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: 100,
            width: 120,
            color: Colors.white,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (quote.user!.sId !=
                      AppPreference().getString(PreferencesKey.userId))
                    commonPostText(
                        text: "Report Post",
                        color: colorGrey,
                        size: 13,
                        onPressed: () {
                          Get.back();
                          reportDialogBox(
                              context, quote.sId!, false, false, true);
                        }),
                  if (quote.user!.sId !=
                      AppPreference().getString(PreferencesKey.userId))
                    cDivider(margin: 20)
                  else
                    Container(),
                  if (quote.user!.sId !=
                      AppPreference().getString(PreferencesKey.userId))
                    Obx(() => profileController
                                .quotesOrActivity.value.isUserBlocked ==
                            1
                        ? commonPostText(
                            text: "Unblock User",
                            color: colorGrey,
                            size: 13,
                            onPressed: () {
                              _showQuoteUnBlockDialog(context).then(
                                  (value) => {Navigator.pop(context, value)});
                            })
                        : commonPostText(
                            text: "Block User",
                            color: colorGrey,
                            size: 13,
                            onPressed: () {
                              _showQuoteBlockDialog(context).then(
                                  (value) => {Navigator.pop(context, value)});
                            }))
                  else
                    commonPostText(
                        text: "Delete",
                        color: colorGrey,
                        size: 13,
                        onPressed: () {
                          _showQuotePostDeleteDialog(context, quote.sId!)
                              .then((value) => {

                          });
                        }),
                  // quote.user!.sId != AppPreference()
                  //     .getString(PreferencesKey.userId) ?cDivider(margin: 60):Container(),
                  // commonPostText(
                  //     text: "Share Post",
                  //     color: colorGrey,
                  //     size: 13,
                  //     onPressed: () {
                  //       Get.back();
                  //       Share.share(
                  //         '${Const.shareUrl}quote/${quote.user!.sId}',
                  //       );
                  //     }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
reportQuotePostDeleteDialogBox(BuildContext context, Quote quote) {
  final profileController = Get.put(ProfileController());
  profileController.quotesOrActivity.value = quote;
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: 80,
            width: 100,
            color: Colors.white,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    commonPostText(
                        text: "Delete",
                        color: colorGrey,
                        size: 13,
                        onPressed: () {
                          _showQuotePostDeleteDialog(context, quote.sId!)
                              .then((value) => {Navigator.pop(context,value)});
                        }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

reportPostCommentDialogBox(
    BuildContext context, String muddaId, String muddaPostId) {
  final muddaNewsController = Get.put(MuddaNewsController());
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: Get.height * 0.2,
            width: Get.width * 0.4,
            color: Colors.white,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonPostText(
                      text: "Report Comment",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Get.back();
                        reportDialogBox(context, muddaId, true, true, false);
                      }),
                  cDivider(margin: 30),
                  commonPostText(
                      text: "Report User",
                      color: colorGrey,
                      size: 13,
                      onPressed: () async {
                        Get.back();

                        // await CreateMyDynamicLinksClass()
                        //     .createDynamicLink(
                        //         true, '/muddaDetailsScreen?id=$muddaPostId')
                        //     .then((value) {
                        //   print(' link is $value');
                        //   Share.share(
                        //       value //  '${Const.shareUrl}mudda/$muddaPostId',
                        //       );
                        // });

                        // Share.share(
                        //   '${Const.shareUrl}mudda/$muddaPostId',
                        // );
                      }),
                  cDivider(margin: 30),
                  Obx(() =>
                      !muddaNewsController.commentDetails.value.isUserBlocked!
                          ? commonPostText(
                              text: "Block User",
                              color: colorGrey,
                              size: 13,
                              onPressed: () {
                                _showCommentBlockDialog(context).then(
                                    (value) => {Navigator.pop(context, value)});
                              })
                          : commonPostText(
                              text: "Unblock",
                              color: colorGrey,
                              size: 13,
                              onPressed: () {
                                _showCommentUnBlockDialog(context).then(
                                    (value) => {Navigator.pop(context, value)});
                              })),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<bool?> reportPostCommentWithDeleteDialogBox(
    BuildContext context, String muddaId, String muddaPostId) async {
  return await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: 130,
            width: 168,
            color: Colors.white,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonPostText(
                      text: "Report Comment",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        Navigator.pop(context, false);
                        reportDialogBox(context, muddaId, true, true, false);
                      }),
                  cDivider(margin: 60),
                  commonPostText(
                      text: "Share Post",
                      color: colorGrey,
                      size: 13,
                      onPressed: () async {
                        Navigator.pop(context, false);
                        await CreateMyDynamicLinksClass()
                            .createDynamicLink(
                                true, '/muddaDetailsScreen?id=$muddaPostId')
                            .then((value) {
                          print(' link is $value');
                          Share.share(
                              value //  '${Const.shareUrl}mudda/$muddaPostId',
                              );
                          // Share.share(
                          //   '${Const.shareUrl}mudda/$muddaPostId',
                          // );
                        });
                      }),
                  cDivider(margin: 60),
                  commonPostText(
                      text: "Delete",
                      color: colorGrey,
                      size: 13,
                      onPressed: () {
                        // Get.back();
                        _showMyDialog(context, muddaId)
                            .then((value) => {Navigator.pop(context, value)});
                        // Share.share(
                        //   '${Const.shareUrl}mudda/$muddaId',
                        // );
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<bool?> _showMyDialog(BuildContext context, String muddaId) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Delete the comment?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.delete.call(
                context,
                method: "comment/delete/$muddaId",
                isLoading: true,
                param: {},
                onResponseSuccess: (object) {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> _showQuoteBlockDialog(BuildContext context) async {
  final profileController = Get.put(ProfileController());
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Block this user?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.post.call(context,
                  method:
                      'user/block/${profileController.quotesOrActivity.value.user!.sId}',
                  isLoading: false,
                  param: {}, onResponseSuccess: (object) {
                Quote quote = profileController.quotesOrActivity.value;
                quote.isUserBlocked = 1;
                profileController.quotesOrActivity.value = quote;
                Navigator.pop(context, true);
              });
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> _showQuoteUnBlockDialog(BuildContext context) async {
  final profileController = Get.put(ProfileController());
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Unblock this user?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.post.call(context,
                  method:
                      'user/unblock/${profileController.quotesOrActivity.value.user!.sId}',
                  isLoading: false,
                  param: {}, onResponseSuccess: (object) {
                Quote quote = profileController.quotesOrActivity.value;
                quote.isUserBlocked = 0;
                profileController.quotesOrActivity.value = quote;
                Navigator.pop(context, true);
              });
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> _showBlockDialog(BuildContext context) async {
  final muddaNewsController = Get.put(MuddaNewsController());
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Block this user?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.post.call(context,
                  method:
                      'user/block/${muddaNewsController.postForMudda.value.userDetail!.sId}',
                  isLoading: false,
                  param: {}, onResponseSuccess: (object) {
                PostForMudda post = muddaNewsController.postForMudda.value;
                post.isUserBlocked = true;
                muddaNewsController.postForMudda.value = post;
                Navigator.pop(context, true);
              });
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> _showUnBlockDialog(BuildContext context) async {
  final muddaNewsController = Get.put(MuddaNewsController());
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Unblock this user?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.post.call(context,
                  method:
                      'user/unblock/${muddaNewsController.postForMudda.value.userDetail!.sId}',
                  isLoading: false,
                  param: {}, onResponseSuccess: (object) {
                PostForMudda post = muddaNewsController.postForMudda.value;
                post.isUserBlocked = false;
                muddaNewsController.postForMudda.value = post;
                Navigator.pop(context, true);
              });
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> _showCommentBlockDialog(BuildContext context) async {
  final muddaNewsController = Get.put(MuddaNewsController());
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Block this user?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.post.call(context,
                  method:
                      'user/block/${muddaNewsController.commentDetails.value.user!.sId}',
                  isLoading: false,
                  param: {}, onResponseSuccess: (object) {
                Comments post = muddaNewsController.commentDetails.value;
                post.isUserBlocked = true;
                muddaNewsController.commentDetails.value = post;
                Navigator.pop(context, true);
              });
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> _showCommentUnBlockDialog(BuildContext context) async {
  final muddaNewsController = Get.put(MuddaNewsController());
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Unblock this user?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.post.call(context,
                  method:
                      'user/unblock/${muddaNewsController.commentDetails.value.user!.sId}',
                  isLoading: false,
                  param: {}, onResponseSuccess: (object) {
                Comments post = muddaNewsController.commentDetails.value;
                post.isUserBlocked = false;
                muddaNewsController.commentDetails.value = post;
                Navigator.pop(context, true);
              });
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> _showDeletePostDialog(BuildContext context, String postId) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Delete the post?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.delete.call(
                context,
                method: "post-for-mudda/delete/$postId",
                isLoading: true,
                param: {},
                onResponseSuccess: (object) {
                  print("hcch" + object.toString());
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}
Future<bool?> _showQuotePostDeleteDialog(BuildContext context, String quoteId) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure Delete the post?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Api.delete.call(
                context,
                method: "quote-or-activity/delete/$quoteId",
                isLoading: true,
                param: {},
                onResponseSuccess: (object) {
                  print("hcch" + object.toString());
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

cDivider({double margin = 0}) {
  return Container(
    height: 1,
    color: colorGrey,
    margin: EdgeInsets.symmetric(horizontal: margin),
  );
}

commonText(
    {required String text,
    required void Function() onPressed,
    required Color color,
    required double size}) {
  return SizedBox(
    height: 35,
    child: InkWell(
      onTap: onPressed,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: size.sp,
              letterSpacing: 0.0,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal),
        ),
      ),
    ),
  );
}

commonPostText(
    {required String text,
    required void Function() onPressed,
    required Color color,
    required double size}) {
  return SizedBox(
    height: Get.height * 0.055,
    child: InkWell(
      onTap: onPressed,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: size.sp,
              letterSpacing: 0.0,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal),
        ),
      ),
    ),
  );
}

reportDialogBox(BuildContext context, String muddaId, bool isPost,
    bool isPostComment, bool isQuoteActivity) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: ScreenUtil().setSp(250),
            width: ScreenUtil().setSp(200),
            decoration: BoxDecoration(color: Colors.white),
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    color: colorGrey,
                    child: Center(
                      child: Text(
                        "Report",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            letterSpacing: 0.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonText(
                          text: "Nudity",
                          onPressed: () {
                            Api.post.call(
                              context,
                              method: "spam-report/store",
                              isLoading: true,
                              param: {
                                "user_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                                "relative_id": muddaId,
                                "relative_type": isQuoteActivity
                                    ? "QuoteOrActivity"
                                    : isPostComment
                                        ? "Comments"
                                        : isPost
                                            ? "post-for-mudda"
                                            : "RealMudda",
                                "report_type": "Nudity",
                              },
                              onResponseSuccess: (object) {
                                Get.back();
                              },
                            );
                          },
                          color: Colors.black,
                          size: 12,
                        ),
                        cDivider(),
                        commonText(
                          text: "Harassment",
                          onPressed: () {
                            Api.post.call(
                              context,
                              method: "spam-report/store",
                              isLoading: true,
                              param: {
                                "user_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                                "relative_id": muddaId,
                                "relative_type": isQuoteActivity
                                    ? "QuoteOrActivity"
                                    : isPostComment
                                        ? "Comments"
                                        : isPost
                                            ? "post-for-mudda"
                                            : "RealMudda",
                                "report_type": "Harassment",
                              },
                              onResponseSuccess: (object) {
                                Get.back();
                              },
                            );
                          },
                          color: Colors.black,
                          size: 12,
                        ),
                        cDivider(),
                        commonText(
                          text: "Violence",
                          onPressed: () {
                            Api.post.call(
                              context,
                              method: "spam-report/store",
                              isLoading: true,
                              param: {
                                "user_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                                "relative_id": muddaId,
                                "relative_type": isQuoteActivity
                                    ? "QuoteOrActivity"
                                    : isPostComment
                                        ? "Comments"
                                        : isPost
                                            ? "post-for-mudda"
                                            : "RealMudda",
                                "report_type": "Violence",
                              },
                              onResponseSuccess: (object) {
                                Get.back();
                              },
                            );
                          },
                          color: Colors.black,
                          size: 12,
                        ),
                        cDivider(),
                        commonText(
                          text: "Spam",
                          onPressed: () {
                            Api.post.call(
                              context,
                              method: "spam-report/store",
                              isLoading: true,
                              param: {
                                "user_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                                "relative_id": muddaId,
                                "relative_type": isQuoteActivity
                                    ? "QuoteOrActivity"
                                    : isPostComment
                                        ? "Comments"
                                        : isPost
                                            ? "post-for-mudda"
                                            : "RealMudda",
                                "report_type": "Spam",
                              },
                              onResponseSuccess: (object) {
                                Get.back();
                              },
                            );
                          },
                          color: Colors.black,
                          size: 12,
                        ),
                        cDivider(),
                        commonText(
                          text: "Hate Speech",
                          onPressed: () {
                            Api.post.call(
                              context,
                              method: "spam-report/store",
                              isLoading: true,
                              param: {
                                "user_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                                "relative_id": muddaId,
                                "relative_type": isQuoteActivity
                                    ? "QuoteOrActivity"
                                    : isPostComment
                                        ? "Comments"
                                        : isPost
                                            ? "post-for-mudda"
                                            : "RealMudda",
                                "report_type": "Hate Speech",
                              },
                              onResponseSuccess: (object) {
                                Get.back();
                              },
                            );
                          },
                          color: Colors.black,
                          size: 12,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

reportUsersBox(BuildContext context, String muddaId) {
  String descriptionValue = "";
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 32),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Report User",
                  style: GoogleFonts.nunitoSans(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w700,
                      color: black),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(42)),
            child: Container(
              height: getHeight(160),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue)),
              child: TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(300),
                ],
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (text) {
                  descriptionValue = text;
                },
                style: size14_M_normal(textColor: color606060),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  hintText: "Enter report for the user",
                  border: InputBorder.none,
                  hintStyle: size12_M_normal(textColor: color606060),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 37),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetStartedButton(
                  onTap: () async {
                    Api.post.call(
                      context,
                      method: "spam-report/store",
                      isLoading: true,
                      param: {
                        "user_id":
                            AppPreference().getString(PreferencesKey.userId),
                        "relative_id": muddaId,
                        "relative_type": "Users",
                        "report_type": "Spam",
                        "reportText": descriptionValue,
                      },
                      onResponseSuccess: (object) {
                        Get.back();
                      },
                    );
                  },
                  title: "Submit",
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

anynymousDialogBox(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: ScreenUtil().setSp(97),
            width: ScreenUtil().screenWidth - ScreenUtil().setSp(50),
            decoration: const BoxDecoration(color: Colors.white),
            child: Material(
              child: commonPostText(
                text: "Anonymous user profiles can be visited or contacted.",
                onPressed: () {
                  Get.back();
                },
                color: Colors.black,
                size: 12,
              ),
            ),
          ),
        ),
      );
    },
  );
}
