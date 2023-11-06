import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/ui/screens/edit_profile/controller/create_org_controller.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/shared/get_started_button.dart';

class OrgAdditionalDataScreen extends GetView {
  OrgAdditionalDataScreen({Key? key}) : super(key: key);

  CreateOrgController? createOrgController;
  UserProfileUpdateController? userProfileUpdateController;
  @override
  Widget build(BuildContext context) {
    createOrgController = Get.find<CreateOrgController>();
    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.transparent,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Verify your Org Profile",
                    style: size18_M_bold(textColor: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    userProfileUpdateController!.isOrgAvailable.value = AppPreference().getString(PreferencesKey.orgUserId).isNotEmpty;
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            getSizedBox(h: 20),
            Text(
              "While your Org is being formed, you may want to verify your profile to have a verified tag on your profile.",
              style: size12_M_normal(textColor: colorGrey),
            ),
            getSizedBox(h: 60),
            Row(
              children: [
                Text(
                  "Is your org registered in Government Department",
                  style: size14_M_normal(textColor: colorGrey),
                ),
              ],
            ),
            getSizedBox(h: 20),
            Obx(
                  ()=> Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      createOrgController!.isGovDepartment.value = "Yes";
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: createOrgController!.isGovDepartment.value == "Yes" ? const Center(
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.black87,
                              )):Container(),
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
                          "Yes",
                          style: size12_M_normal(textColor: colorGrey),
                        ),
                      ],
                    ),
                  ),
                  getSizedBox(w: 20),
                  InkWell(
                    onTap: (){
                      createOrgController!.isGovDepartment.value = "No";
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: createOrgController!.isGovDepartment.value == "No" ? const Center(
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.black87,
                              )):Container(),
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
                          "No",
                          style: size12_M_normal(textColor: colorGrey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            getSizedBox(h: 20),
            Row(
              children: [
                Text(
                  "If Yes, then upload registration document",
                  style: size12_M_normal(textColor: colorGrey),
                ),
              ],
            ),
            getSizedBox(h: 20),
            Obx(
                  () =>
                  InkWell(
                    onTap: () {
                      uploadProfilePic(context);
                    },
                    child: createOrgController!.registrationDoc.value.isEmpty
                        ? Container(
                      height: 160,
                      width: 160,
                      child: Icon(Icons.camera_alt, size: 90, color: colorGrey),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                    )
                        : Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1),
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: FileImage(File(createOrgController!.registrationDoc.value))
                          )
                      ),
                    ),
                  ),
            ),
            getSizedBox(h: 20),
            Text(
              "The data you provide here will be kept strictly confidential and shall be used for verification purpose only.",
              textAlign: TextAlign.center,
              style: size12_M_normal(textColor: colorGrey),
            ),
            getSizedBox(h: 40),
            GetStartedButton(
              onTap: () async{
                FormData formData = FormData.fromMap({
                  "is_govt_register": createOrgController!.isGovDepartment.value,
                  "_id": AppPreference().getString(PreferencesKey.orgUserId),
                });
                if (createOrgController!.registrationDoc.value.isNotEmpty) {
                  var video = await MultipartFile.fromFile(
                      createOrgController!.registrationDoc.value,
                      filename:
                      createOrgController!.registrationDoc.value
                          .split('/')
                          .last);
                  formData.files.addAll([
                    MapEntry("registration_document", video),
                  ]);
                }
                Api.uploadPost.call(context,
                    method: "user/profile-update",
                    param: formData,
                    isLoading: true,
                    onResponseSuccess: (Map object) {
                      print(object);
                      userProfileUpdateController!.isOrgAvailable.value = AppPreference().getString(PreferencesKey.orgUserId).isNotEmpty;
                      var snackBar = const SnackBar(
                        content: Text('Uploaded'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      Get.back();
                    });
              },
              title: "Submit",
            )
          ],
        ),
      ),
    );
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
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          createOrgController!.registrationDoc.value = value.path;
                        });
                      }
                      ;
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
                        createOrgController!.registrationDoc.value = value.path;
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

