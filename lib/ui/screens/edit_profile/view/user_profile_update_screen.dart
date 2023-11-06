import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/PlaceModel.dart';
import 'package:mudda/model/UserProfileModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/profile_screen/widget/profile_verification_screen.dart';
import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/ui/shared/image_compression.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';
import 'package:mudda/ui/shared/keyboard_visibility.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:video_compress/video_compress.dart';

class UserProfileEditScreen extends StatefulWidget {
  UserProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  TextEditingController locationController = TextEditingController();

  UserProfileUpdateController? userProfileUpdateController;

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    userProfileUpdateController!.userNameAvilable.value =
        userProfileUpdateController!.userProfile.value.username != null
            ? true
            : false;
    userProfileUpdateController!.ageSelected.value =
        userProfileUpdateController!.ageList.indexOf(
            userProfileUpdateController!.userProfile.value.age ?? "18-25");
    locationController.text = userProfileUpdateController!
                .userProfile.value.city !=
            null
        ? "${userProfileUpdateController!.userProfile.value.city ?? ''}, ${userProfileUpdateController!.userProfile.value.state ?? ''}, ${userProfileUpdateController!.userProfile.value.country ?? ''}"
        : "";
    userProfileUpdateController!.userProfileImage.value = "";
    return Scaffold(
        backgroundColor: colorAppBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  Text(
                    "Profile Update",
                    style: size18_M_bold(textColor: Colors.black),
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
        body: KeyboardVisibilityBuilder(
          builder: (context, child, isKeyboardVisible) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  getSizedBox(h: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result3 = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileVideoVerificationScreen()),
                            );
                            if (result3 != null) {
                              var snackBar = SnackBar(
                                content: Text('Compressing'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              // Constants.verificationStatus = "Submitted";
                              final MediaInfo? info =
                                  await VideoCompress.compressVideo(
                                result3,
                                quality: VideoQuality.MediumQuality,
                                deleteOrigin: false,
                                includeAudio: true,
                              );
                              var video = await MultipartFile.fromFile(
                                  info!.path!,
                                  filename:
                                      "${File(result3).path.split('/').last}");
                              var formData = FormData.fromMap({
                                "verification_video": video,
                                "_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                              });
                              Api.uploadPost.call(context,
                                  method: "user/profile-update",
                                  param: formData,
                                  onResponseSuccess: (Map object) {
                                var snackBar = SnackBar(
                                  content: Text('Uploaded'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Text("Verify your Profile",
                                    style: size12_M_semibold(
                                        textColor: Colors.black54)),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Obx(() => InkWell(
                            onTap: () {
                              uploadProfilePic(context);
                            },
                            child: userProfileUpdateController!
                                    .userProfileImage.value.isNotEmpty
                                ? Container(
                                    height: 95,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.2),
                                            blurRadius: 5.0,
                                            offset: const Offset(0, 5))
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        File(userProfileUpdateController!
                                            .userProfileImage.value),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : userProfileUpdateController!
                                            .userProfile.value.profile !=
                                        null
                                    ? Container(
                                        height: 95,
                                        width: 95,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Stack(children: [
                                              Image.network(
                                                  "${userProfileUpdateController!.userProfilePath}${userProfileUpdateController!.userProfile.value.profile}",
                                                  fit: BoxFit.cover),
                                              Positioned(
                                                bottom: 5,
                                                right: 10,
                                                child: Visibility(
                                                  visible:
                                                      userProfileUpdateController!
                                                              .userProfile
                                                              .value
                                                              .isProfileVerified ==
                                                          1,
                                                  child: Image.asset(
                                                    AppIcons.verifyProfile,
                                                    width: 18,
                                                    height: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ])),
                                        decoration: BoxDecoration(
                                          color: Colors.amberAccent,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5))
                                          ],
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                      )
                                    : Container(
                                        height: 95,
                                        width: 95,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child:
                                                const Icon(Icons.add_a_photo)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5))
                                          ],
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                      ))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-z@_]"))
                                ],
                                initialValue: userProfileUpdateController!
                                    .userProfile.value.username,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? "Enter your username"
                                      : userProfileUpdateController!
                                                  .userNameAvilable.value ==
                                              false
                                          ? "Username is already exist!"
                                          : null;
                                },
                                onChanged: (text) {
                                  userProfileUpdateController!
                                      .userProfile.value.username = text.trim();
                                  if (text.trim().isNotEmpty) {
                                    Api.get.call(context,
                                        method:
                                            "user/check-username/${text.trim()}",
                                        param: {
                                          "user_id": AppPreference()
                                              .getString(PreferencesKey.userId),
                                        },
                                        isLoading: false,
                                        onResponseSuccess: (Map object) {
                                      userProfileUpdateController!
                                          .userNameAvilable
                                          .value = object['isStatus'] == 1;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(top: 20),
                                  hintText: "username",
                                  suffixStyle:
                                      size12_M_medium(textColor: Colors.black),
                                  border: InputBorder.none,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: userProfileUpdateController!
                                            .userNameAvilable.value
                                        ? const Icon(
                                            Icons.done,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getSizedBox(h: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: size14_M_normal(textColor: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  getSizedBox(h: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppTextField(
                        hintText: "Enter your name",
                        validate: (value) {
                          return value!.isEmpty
                              ? "Enter your name"
                              : value.trim().length < 3
                                  ? "Enter minimum 3 character"
                                  : null;
                        },
                        onChange: (text) {
                          userProfileUpdateController!
                              .userProfile.value.fullname = text.trim();
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z_ ]"))
                        ],
                        initialValue: userProfileUpdateController!
                            .userProfile.value.fullname),
                  ),
                  getSizedBox(h: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          "Age:",
                          style: size14_M_normal(textColor: greyTextColor),
                        ),
                        getSizedBox(w: 20),
                        Expanded(
                          child: Obx(
                            () => Row(
                              children: List.generate(
                                userProfileUpdateController!.ageList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      userProfileUpdateController!
                                          .ageSelected.value = index;
                                    },
                                    child: Container(
                                      width: getWidth(60),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  userProfileUpdateController!
                                                              .ageSelected
                                                              .value ==
                                                          index
                                                      ? Colors.transparent
                                                      : colorA0A0A0),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: userProfileUpdateController!
                                                      .ageSelected.value ==
                                                  index
                                              ? colorBlack
                                              : Colors.transparent),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          userProfileUpdateController!
                                              .ageList[index],
                                          style: size12_M_normal(
                                              textColor:
                                                  userProfileUpdateController!
                                                              .ageSelected
                                                              .value ==
                                                          index
                                                      ? colorWhite
                                                      : colorA0A0A0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  getSizedBox(h: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          "Gender:",
                          style: size14_M_normal(textColor: greyTextColor),
                        ),
                        getSizedBox(w: 20),
                        userProfileUpdateController?.userProfile.value.gender ==
                                    null ||
                                userProfileUpdateController
                                        ?.userProfile.value.gender ==
                                    ""
                            ? Container()
                            : Expanded(
                                child: Obx(
                                  () => Row(
                                    children: List.generate(
                                      userProfileUpdateController!
                                          .genderList.length,
                                      (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              userProfileUpdateController
                                                      ?.userProfile
                                                      .value
                                                      .gender =
                                                  userProfileUpdateController
                                                      ?.genderList[index];
                                            });
                                            //  userProfileUpdateController?.updateGender( userProfileUpdateController!.genderList[index]);
                                          },
                                          child: Container(
                                            width: getWidth(60),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: userProfileUpdateController
                                                                ?.userProfile
                                                                .value
                                                                .gender ==
                                                            userProfileUpdateController!
                                                                    .genderList[
                                                                index]
                                                        ? Colors.transparent
                                                        : colorA0A0A0),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: userProfileUpdateController
                                                            ?.userProfile
                                                            .value
                                                            .gender ==
                                                        userProfileUpdateController!
                                                            .genderList[index]
                                                    ? colorBlack
                                                    : Colors.transparent),
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Text(
                                                userProfileUpdateController!
                                                    .genderList[index],
                                                style: size12_M_normal(
                                                    textColor: userProfileUpdateController
                                                                ?.userProfile
                                                                .value
                                                                .gender ==
                                                            userProfileUpdateController!
                                                                    .genderList[
                                                                index]
                                                        ? colorWhite
                                                        : colorA0A0A0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  getSizedBox(h: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Location",
                          style: size16_M_normal(textColor: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  getSizedBox(h: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TypeAheadFormField<Place>(
                      validator: (value) {
                        return value!.isEmpty ? "Enter Location" : null;
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: locationController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          style: size14_M_normal(textColor: color606060),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFf7f7f7),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Enter your District Name",
                            hintStyle: size14_M_normal(textColor: color606060),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: white, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: white, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: white, width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: white, width: 1),
                            ),
                          )),
                      suggestionsCallback: (pattern) {
                        return _getLocation(pattern, context);
                      },
                      hideSuggestionsOnKeyboardHide: false,
                      itemBuilder: (context, suggestion) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "${suggestion.district}, ${suggestion.state}, ${suggestion.country}",
                            style: GoogleFonts.nunitoSans(
                                color: darkGray,
                                fontWeight: FontWeight.w300,
                                fontSize: ScreenUtil().setSp(12)),
                          ),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) async {
                        locationController.text =
                            "${suggestion.district}, ${suggestion.state}, ${suggestion.country}";
                        userProfileUpdateController!.userProfile.value.city =
                            suggestion.district!;
                        userProfileUpdateController!.userProfile.value.state =
                            suggestion.state!;
                        userProfileUpdateController!.userProfile.value.country =
                            suggestion.country!;
                      },
                    ),
                  ),
                  getSizedBox(h: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Occupation",
                          style: size14_M_normal(textColor: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  getSizedBox(h: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppTextField(
                      hintText: "Enter Occupation",
                      onChange: (text) {
                        userProfileUpdateController!
                            .userProfile.value.profession = text;
                      },
                      initialValue: userProfileUpdateController!
                          .userProfile.value.profession,
                    ),
                  ),
                  getSizedBox(h: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "About You",
                          style: size14_M_normal(textColor: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  getSizedBox(h: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: getHeight(119),
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: const Color(0xFFf7f7f7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white)),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(400),
                        ],
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        initialValue: userProfileUpdateController!
                            .userProfile.value.description,
                        onChanged: (text) {
                          userProfileUpdateController!
                              .userProfile.value.description = text;
                        },
                        style: size14_M_normal(textColor: color606060),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          hintText: "Brief about you",
                          border: InputBorder.none,
                          hintStyle: size14_M_normal(textColor: color606060),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetStartedButton(
                        title: "Update",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            AppPreference _appPreference = AppPreference();
                            FormData formData = FormData.fromMap({
                              "fullname": userProfileUpdateController!
                                  .userProfile.value.fullname,
                              "username": userProfileUpdateController!
                                  .userProfile.value.username,
                              "city": userProfileUpdateController!
                                  .userProfile.value.city,
                              "state": userProfileUpdateController!
                                  .userProfile.value.state,
                              "country": userProfileUpdateController!
                                  .userProfile.value.country,
                              "profession": userProfileUpdateController!
                                  .userProfile.value.profession,
                              "description": userProfileUpdateController!
                                  .userProfile.value.description,
                              "age": userProfileUpdateController!.ageList
                                  .elementAt(userProfileUpdateController!
                                      .ageSelected.value),
                              "gender": userProfileUpdateController
                                  ?.userProfile
                                  .value
                                  .gender,
                              "_id": _appPreference
                                  .getString(PreferencesKey.userId),
                            });
                            if (userProfileUpdateController!
                                .userProfileImage.value.isNotEmpty) {
                              var video = await MultipartFile.fromFile(
                                  userProfileUpdateController!
                                      .userProfileImage.value,
                                  filename: userProfileUpdateController!
                                      .userProfileImage.value
                                      .split('/')
                                      .last);
                              formData.files.addAll([
                                MapEntry("profile", video),
                              ]);
                            }
                            Api.uploadPost.call(context,
                                method: "user/profile-update",
                                param: formData,
                                isLoading: true,
                                onResponseSuccess: (Map object) {
                              var snackBar = const SnackBar(
                                content: Text('Updated'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              var result = UserProfileModel.fromJson(object);
                              userProfileUpdateController!
                                  .userProfilePath.value = result.path!;
                              userProfileUpdateController!.userProfile.value =
                                  result.data!;
                              AppPreference().setString(
                                  PreferencesKey.city,
                                  userProfileUpdateController!
                                      .userProfile.value.city!);
                              AppPreference().setString(
                                  PreferencesKey.state,
                                  userProfileUpdateController!
                                      .userProfile.value.state!);
                              AppPreference().setString(
                                  PreferencesKey.country,
                                  userProfileUpdateController!
                                      .userProfile.value.country!);
                              AppPreference()
                                  .setBool(PreferencesKey.isGuest, false);
                              Get.back(result: true);
                              // Get.toNamed(RouteConstants.homeScreen);
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }

  Future<List<Place>> _getLocation(String query, BuildContext context) async {
    List<Place> matches = <Place>[];
    if (query.length >= 3 && query.length < 20) {
      var responce = await Api.get.futureCall(context,
          method: "country/location",
          param: {
            "search": query,
            "page": "1",
            "search_type": "district",
          },
          isLoading: false);
      if (responce != null) {
        final result = PlaceModel.fromJson(responce.data!);
        return result.data!;
      } else {
        return matches;
      }
    } else {
      return matches;
    }
  }

  Future uploadProfilePic(BuildContext context) async {
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
                          .pickImage(source: ImageSource.gallery,imageQuality: ImageCompression.imageQuality);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          userProfileUpdateController!.userProfileImage
                                .value =
                                value.path;
                          // if(value.lengthSync()>150000) {
                          // //   testCompressAndGetFile(90,
                          // //       value, '${value.path}compressed.jpg').then((
                          // //       value) {
                          // //     print('final size${value.lengthSync()}');
                          // //     userProfileUpdateController!.userProfileImage
                          // //         .value =
                          // //         value.path;
                          // //   });
                          // // }
                          // else{
                          //   userProfileUpdateController!.userProfileImage
                          //       .value =
                          //       value.path;
                          // }
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
                        .pickImage(source: ImageSource.camera,imageQuality: ImageCompression.imageQuality);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        userProfileUpdateController!.userProfileImage
                            .value =
                            value.path;
                        // if(value.lengthSync()>150000) {
                        //   testCompressAndGetFile(90,
                        //       value, '${value.path}compressed.jpg').then((
                        //       value) {
                        //         print('final size${value.lengthSync()}');
                        //     userProfileUpdateController!.userProfileImage
                        //         .value =
                        //         value.path;
                        //   });
                        // }
                        // else{
                        //   userProfileUpdateController!.userProfileImage
                        //       .value =
                        //       value.path;
                        // }
                      });
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

  Future<File> testCompressAndGetFile(int quality,File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: quality,
    );
     if(result!.lengthSync()>150000 && quality>0){
       result = await testCompressAndGetFile(quality-=10,
           file, '${file.path}compressed.jpg');
     }
     return File(result.path);
  }

  Future<File> _cropImage(File profileImageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: profileImageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
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
}
