import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/PlaceModel.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';
import 'package:mudda/ui/screens/sign_up_screen/controller/sign_up_controller.dart';

import 'package:mudda/core/constant/app_colors.dart';

import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/text_style.dart';

class TopWidgetColumnWidget extends StatelessWidget {
  TopWidgetColumnWidget(
      {Key? key, required this.signUpController, required this.formKey})
      : super(key: key);

  File? _image;
  GlobalKey formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  String? base64image;

  Future _getImage({bool? fromGallery}) async {
    final pickedFile = await picker.pickImage(
        source: fromGallery! ? ImageSource.camera : ImageSource.gallery);
    //setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      //base64image = base64Encode(_image!.readAsBytesSync());
    } else {
      print('No image selected.');
    }
    //});
    return _image;
  }

  SignUpController signUpController;
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 20.h),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: size16_M_normal(textColor: color606060),
            ),
            Vs(height: 6.h),
            CustomTextFieldWidget(
              keyboardType: TextInputType.name,
              hintText: enterName,
              validator: (value) {
                if (value!.isEmpty || value.trim().length < 3) {
                  return 'Enter your full name';
                }
              },
              signUpController: signUpController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
              ],
            ),
            Vs(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    age,
                    style: size16_M_normal(textColor: color606060),
                  ),
                ),
                const Hs(width: 5),
                Expanded(
                  child: Obx(() => Wrap(
                        children: List.generate(
                          signUpController.ageList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 15, top: 10),
                            child: GestureDetector(
                              onTap: () {
                                signUpController.isSelectedAge.value = index;
                              },
                              child: Container(
                                width: getWidth(60),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: signUpController
                                                    .isSelectedAge.value ==
                                                index
                                            ? Colors.transparent
                                            : colorA0A0A0),
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        signUpController.isSelectedAge.value ==
                                                index
                                            ? colorBlack
                                            : Colors.transparent),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    signUpController.ageList[index],
                                    style: size12_M_normal(
                                        textColor: signUpController
                                                    .isSelectedAge.value ==
                                                index
                                            ? colorWhite
                                            : colorA0A0A0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                )
              ],
            ),
            Vs(height: 16.h),
            SizedBox(
              height: 30.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      gender,
                      style: size16_M_normal(textColor: color606060),
                    ),
                  ),
                  const Hs(width: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: signUpController.maleFemaleList.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () {
                            signUpController.isSelectedMale.value = index;
                          },
                          child: Container(
                            width: 60.w,
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        signUpController.isSelectedMale.value ==
                                                index
                                            ? Colors.transparent
                                            : colorA0A0A0),
                                borderRadius: BorderRadius.circular(10),
                                color: signUpController.isSelectedMale.value ==
                                        index
                                    ? colorBlack
                                    : Colors.transparent),
                            alignment: Alignment.center,
                            child: Text(
                              signUpController.maleFemaleList[index],
                              style: size12_M_normal(
                                  textColor:
                                      signUpController.isSelectedMale.value ==
                                              index
                                          ? colorWhite
                                          : colorA0A0A0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  /*ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: signUpController.maleFemaleList.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () {
                            signUpController.isSelectedMale.value = index;
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              alignment: Alignment.center,
                              child: Image.asset(
                                signUpController.maleFemaleList[index],
                                height: 75.h,
                                width: 50.h,
                                fit: BoxFit.fill,
                              )),
                        ),
                      );
                    },
                  )*/
                ],
              ),
            ),
            Vs(height: 10.h),
            Text(
              location,
              style: size12_M_normal(
                textColor: color606060,
              ),
            ),
            Vs(height: 10.h),
            TypeAheadFormField<Place>(
              direction: AxisDirection.up,
              getImmediateSuggestions: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter location';
                }
              },
              textFieldConfiguration: TextFieldConfiguration(
                  controller: locationController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  scrollPadding:
                      EdgeInsets.only(bottom: ScreenUtil().setHeight(150)),
                  style: size14_M_normal(textColor: color606060),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFf7f7f7),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText:
                        "Enter First 3 character of your district to search",
                    hintStyle: size12_M_normal(textColor: color606060),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                  )),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                hasScrollbar: true,
              ),
              suggestionsCallback: (pattern) {
                return _getLocation(pattern, context);
              },
              hideSuggestionsOnKeyboardHide: true,
              itemBuilder: (context, suggestion) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                signUpController.city.value = suggestion.district!;
                signUpController.state.value = suggestion.state!;
                signUpController.country.value = suggestion.country!;
              },
            ),
          ],
        ),
      ),
    );
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
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          signUpController.profile.value = value.path;
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
                title: Text('Camera'),
                onTap: () async {
                  try {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        signUpController.profile.value = value.path;
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
