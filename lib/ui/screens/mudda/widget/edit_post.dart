import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';

import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/core/constant/app_colors.dart';

import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/shared/trimmer_view.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_trimmer/video_trimmer.dart';

class EditPostScreen extends GetView {
  EditPostScreen({Key? key}) : super(key: key);
  MuddaNewsController? muddaNewsController;
  final Trimmer _trimmer = Trimmer();
  int selectedIndex = 0;
  int rolePage = 1;
  ScrollController roleController = ScrollController();
  TextEditingController disController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    muddaNewsController = Get.find<MuddaNewsController>();
    muddaNewsController!.postAnynymous.value = false;
    muddaNewsController!.postIn.value = "favour";
    muddaNewsController!.descriptionValue.value = "";
    muddaNewsController!.uploadPhotoVideos.value = [""];
    roleController.addListener(() {
      if (roleController.position.maxScrollExtent ==
          roleController.position.pixels) {
        rolePage++;
        _getRoles(context);
      }
    });
    _getRoles(context);
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    disController.clear();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Add Post to Mudda",
                    style: size15_M_bold(textColor: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getSizedBox(h: 30),
            SizedBox(
              height: 100,
              child: Obx(
                    () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(38)),
                    itemCount: muddaNewsController!.uploadPhotoVideos.length > 5
                        ? 5
                        : muddaNewsController!.uploadPhotoVideos.length,
                    itemBuilder: (followersContext, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(4)),
                        child: GestureDetector(
                          onTap: () {
                            if ((muddaNewsController!.uploadPhotoVideos.length -
                                index) ==
                                1) {
                              uploadPic(context);
                            } else {
                              // muddaVideoDialog(
                              //     context, muddaNewsController!.uploadPhotoVideos);
                            }
                          },
                          child: (muddaNewsController!.uploadPhotoVideos.length -
                              index) ==
                              1
                              ? Container(
                            height: 100,
                            width: 100,
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey)),
                          )
                              : Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: muddaNewsController!.uploadPhotoVideos
                                .elementAt(index)
                                .contains("Trimmer")
                                ? Stack(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child:
                                  VideoViewer(trimmer: _trimmer),
                                )
                              ],
                            )
                                : Image.file(
                              File(muddaNewsController!
                                  .uploadPhotoVideos
                                  .elementAt(index)),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            // Row(
            //   children: [
            //     const Spacer(),
            //     const Icon(Icons.crop_rotate),
            //     getSizedBox(w: ScreenUtil().setSp(20))
            //   ],
            // ),
            getSizedBox(h: ScreenUtil().setSp(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(42)),
              child: Container(
                // height: getHeight(250),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue)),
                child: TextField(
                  // controller: disController,
                  // textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  maxLength: 600,
                  onChanged: (text) {
                    muddaNewsController!.descriptionValue.value = text;
                  },
                  style: size14_M_normal(textColor: color606060),
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: "Enter Text for the post",
                    border: InputBorder.none,
                    hintStyle: size12_M_normal(textColor: color606060),
                  ),
                ),
              ),
            ),
            getSizedBox(h: 5),
            Obx(
                  ()=> Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "max ${600 - muddaNewsController!.descriptionValue.value.length} characters",
                      style: size12_M_normal(textColor: colorGrey),
                    ),
                    getSizedBox(w: 30)
                  ],
                ),
              ),
            ),
            getSizedBox(h: 20),
            Obx(
                  ()=> Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        getSizedBox(w: 20),
                        InkWell(
                          onTap: () {
                            muddaNewsController!.postAnynymous.value = !muddaNewsController!.postAnynymous.value;
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                child: Center(
                                  child: Container(
                                    height: 8,
                                    width: 8,
                                    color: muddaNewsController!.postAnynymous.value ? Colors.black:Colors.transparent,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              getSizedBox(w: 10),
                              Text(
                                "Post as Anynymous ",
                                style: size12_M_normal(textColor: colorGrey),
                              ),
                            ],
                          ),
                        ),
                        getSizedBox(w: 10),
                        GestureDetector(
                          onTap: () {
                            postAnynymousDialogBox(descriptionText);
                          },
                          child: Container(
                            height: 15,
                            width: 15,
                            child: const Icon(Icons.question_mark, size: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(color: colorGrey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: muddaNewsController!.roleList.isNotEmpty,
                      child: InkWell(
                        onTap: (){
                          showRolesDialog(context);
                        },
                        child: Row(
                          children: [
                            muddaNewsController!.selectedRole.value.user != null ?muddaNewsController!.selectedRole.value.user!.profile != null ?CachedNetworkImage(
                              imageUrl: "${muddaNewsController!.roleProfilePath.value}${muddaNewsController!.selectedRole.value.user!.profile}",
                              imageBuilder: (context, imageProvider) => Container(
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(30),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(
                                    width: ScreenUtil().setSp(1),
                                    color: buttonBlue,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(15)) //                 <--- border radius here
                                  ),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor: lightGray,
                                radius: ScreenUtil().setSp(15),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                backgroundColor: lightGray,
                                radius: ScreenUtil().setSp(15),
                              ),
                            ):Container(
                              height: ScreenUtil().setSp(30),
                              width: ScreenUtil().setSp(30),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: darkGray,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(muddaNewsController!.selectedRole.value.user!.fullname![0].toUpperCase(),
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(16),
                                        color: black)),
                              ),
                            ):AppPreference().getString(PreferencesKey.profile).isNotEmpty ?CachedNetworkImage(
                              imageUrl: "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                              imageBuilder: (context, imageProvider) => Container(
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(30),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(
                                    width: ScreenUtil().setSp(1),
                                    color: buttonBlue,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(15)) //                 <--- border radius here
                                  ),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor: lightGray,
                                radius: ScreenUtil().setSp(15),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                backgroundColor: lightGray,
                                radius: ScreenUtil().setSp(15),
                              ),
                            ):Container(
                              height: ScreenUtil().setSp(30),
                              width: ScreenUtil().setSp(30),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: darkGray,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(AppPreference().getString(PreferencesKey.fullName)[0].toUpperCase(),
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(16),
                                        color: black)),
                              ),
                            ),
                            getSizedBox(w: 6),
                            Text(
                                muddaNewsController!.selectedRole.value.user != null ? muddaNewsController!.selectedRole.value.user!.fullname!:"Self",
                                style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w400,fontSize: ScreenUtil().setSp(10),color: buttonBlue,fontStyle: FontStyle.italic)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            getSizedBox(h: 20),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Obx(
                  ()=> Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          muddaNewsController!.postIn.value = "favour";
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: muddaNewsController!.postIn.value == "favour"
                                  ? const Center(
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.black87,
                                  ))
                                  : Container(),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            getSizedBox(w: 10),
                            Text(
                              "Favour",
                              style: size12_M_normal(textColor: colorGrey),
                            ),
                          ],
                        ),
                      ),
                      getSizedBox(w: 20),
                      InkWell(
                        onTap: () {
                          muddaNewsController!.postIn.value = "opposition";
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child:
                              muddaNewsController!.postIn.value == "opposition"
                                  ? const Center(
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.black87,
                                  ))
                                  : Container(),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            getSizedBox(w: 10),
                            Text(
                              "Opposition",
                              style: size12_M_normal(textColor: colorGrey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetStartedButton(
                  onTap: () async {
                    AppPreference _appPreference = AppPreference();
                    FormData formData = FormData.fromMap({
                      "mudda_description": muddaNewsController!.descriptionValue.value,
                      "mudda_id": muddaNewsController!.muddaPost.value.sId,
                      "post_in": muddaNewsController!.postIn.value,
                      "user_id": _appPreference.getString(PreferencesKey.interactUserId),
                    });
                    if(muddaNewsController!.postAnynymous.value){
                      formData.fields.add(const MapEntry("post_as", "anynymous"));
                    }
                    for (int i = 0;
                    i <
                        (muddaNewsController!.uploadPhotoVideos.length == 5
                            ? 5
                            : (muddaNewsController!.uploadPhotoVideos.length -
                            1));
                    i++) {
                      formData.files.addAll([
                        MapEntry(
                            "gallery",
                            await MultipartFile.fromFile(
                                muddaNewsController!.uploadPhotoVideos[i],
                                filename: muddaNewsController!.uploadPhotoVideos[i]
                                    .split('/')
                                    .last)),
                      ]);
                    }
                    muddaNewsController!.uploadMuddaPost(formData);
                    Get.back();
                    // try{
                    //   Api.uploadPost.call(context,
                    //       method: "post-for-mudda/store",
                    //       param: formData,
                    //       isLoading: true, onResponseSuccess: (Map object) {
                    //         print(object);
                    //         var snackBar = const SnackBar(
                    //           content: Text('Uploaded'),
                    //         );
                    //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //         muddaNewsController!.postForMuddaList.insert(0,PostForMudda.fromJson(object['data']));
                    //         Get.back();
                    //       });
                    // }catch(e){
                    //    muddaNewsController!.isUploadFailed.value = true;
                    // }
                  },
                  title: "Post",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {"page": rolePage.toString(),"user_id": AppPreference().getString(PreferencesKey.userId),"interactModal":"CreatePost"},
        isLoading: false, onResponseSuccess: (Map object) {
          var result = UserRolesModel.fromJson(object);
          if(rolePage == 1){
            muddaNewsController!.roleList.clear();
          }
          if (result.data!.isNotEmpty) {
            muddaNewsController!.roleProfilePath.value = result.path!;
            muddaNewsController!.roleList.addAll(result.data!);
            Role role = Role();
            role.user = User();
            role.user!.profile = AppPreference().getString(PreferencesKey.profile);
            role.user!.fullname = "Self";
            role.user!.sId = AppPreference().getString(PreferencesKey.userId);
            muddaNewsController!.roleList.add(role);
          } else {
            rolePage = rolePage > 1 ? rolePage-1 : rolePage;
          }
        });
  }

  showRolesDialog(BuildContext context) {
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(16))
            ),
            padding: EdgeInsets.only(top: ScreenUtil().setSp(24),left: ScreenUtil().setSp(24),right: ScreenUtil().setSp(24),bottom: ScreenUtil().setSp(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Interact as",style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w400,fontSize: ScreenUtil().setSp(13),color: black,decoration: TextDecoration.underline,decorationColor: black)),
                ListView.builder(
                    shrinkWrap: true,
                    controller: roleController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                    itemCount: muddaNewsController!.roleList.length,
                    itemBuilder: (followersContext, index) {
                      Role role = muddaNewsController!.roleList[index];
                      return InkWell(
                        onTap: () {
                          muddaNewsController!.selectedRole.value = role;
                          AppPreference().setString(PreferencesKey.interactUserId,role.user!.sId!);
                          AppPreference().setString(PreferencesKey.interactProfile,role.user!.profile!);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text(role.user!.fullname!,style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w400,fontSize: ScreenUtil().setSp(13),color: black))),
                              SizedBox(
                                width: ScreenUtil().setSp(14),
                              ),
                              role.user!.profile != null ? SizedBox(
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(30),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "${muddaNewsController!
                                      .roleProfilePath}${role.user!.profile}",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: ScreenUtil().setSp(30),
                                        height: ScreenUtil().setSp(30),
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                Colors.black.withOpacity(.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(ScreenUtil().setSp(
                                                  4)) //                 <--- border radius here
                                          ),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ),
                              ) : Container(
                                height: ScreenUtil().setSp(30),
                                width: ScreenUtil().setSp(30),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: darkGray,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(
                                          4)) //                 <--- border radius here
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                      role.user!.fullname![0].toUpperCase(),
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(20),
                                          color: black)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  Future uploadPic(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    try {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          muddaNewsController!.uploadPhotoVideos.insert(
                              muddaNewsController!.uploadPhotoVideos.length - 1,
                              value.path);
                        });
                      }
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  try {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        muddaNewsController!.uploadPhotoVideos.insert(
                            muddaNewsController!.uploadPhotoVideos.length - 1,
                            value.path);
                      });
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Video Library'),
                  onTap: () async {
                    try {
                      Navigator.of(context).pop();
                      var result = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);
                      if (result != null) {
                        File file = File(result.path);
                        // print("ORG:::${_getVideoSize(file: file)}");
                        print(file.path);
                        var filePath = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrimmerView(file)));
                        if (filePath != null) {
                          File videoFile = File(filePath);
                          _trimmer.loadVideo(videoFile: videoFile);
                          muddaNewsController!.uploadPhotoVideos.insert(
                              muddaNewsController!.uploadPhotoVideos.length - 1,
                              filePath);
                          /*final MediaInfo? info =
                          await VideoCompress.compressVideo(
                            videoFile.path,
                            quality: VideoQuality.MediumQuality,
                            deleteOrigin: false,
                            includeAudio: true,
                          );
                          print(info!.path);
                          _trimmer.loadVideo(videoFile: File(info.path!));
                          muddaNewsController!.uploadPhotoVideos.add(info.path!);*/
                        }
                      }
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Video Camera'),
                onTap: () async {
                  try {
                    final video = await ImagePicker()
                        .pickVideo(source: ImageSource.camera);
                    if (video == null) return;
                    if (video != null) {
                      File file = File(video.path);
                      // print("ORG:::${_getVideoSize(file: file)}");
                      print(file.path);
                      var filePath = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrimmerView(file)));
                      if (filePath != null) {
                        var videoFile = File(filePath);
                        // print("TRIMM:::${_getVideoSize(file: videoFile)}");
                        // String  _desFile = await _destinationFile;
                        // print("DEST:::${_desFile}");
                        final MediaInfo? info =
                        await VideoCompress.compressVideo(
                          videoFile.path,
                          quality: VideoQuality.MediumQuality,
                          deleteOrigin: false,
                          includeAudio: true,
                        );
                        print(info!.path);
                        _trimmer.loadVideo(videoFile: videoFile);
                        muddaNewsController!.uploadPhotoVideos.insert(
                            muddaNewsController!.uploadPhotoVideos.length - 1,
                            info.path!);
                      }
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File> _cropImage(File profileImageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: profileImageFile.path,
        // aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          )
        ]);
    return File(croppedFile!.path);
  }

  postAnynymousDialogBox(String text) {
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Text(text),
          ],
        );
      },
    );
  }
}