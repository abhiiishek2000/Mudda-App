import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';

import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/PlaceModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/create_org_controller.dart';
import 'package:mudda/ui/screens/edit_profile/controller/org_profile_update_controller.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

import '../../../shared/get_started_button.dart';

class OrgBuilderScreen extends GetView {
  OrgBuilderScreen({Key? key}) : super(key: key);
  CreateOrgController createOrgController = Get.put(CreateOrgController());
  TextEditingController locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    log("-=-=- orgId -=-= ${AppPreference().getString(PreferencesKey.orgUserId)}");
    return Scaffold(
      backgroundColor: colorAppBackground,
      /*appBar: PreferredSize(
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
                    "Org Builder",
                    style: size18_M_medium(textColor: Colors.black),
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
      ),*/
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              getSizedBox(h: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          uploadProfilePic(context);
                        },
                        child: createOrgController.orgThumb.value.isEmpty
                            ? Container(
                                height: 95,
                                width: 95,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Center(
                                      child: Image.asset(AppIcons.dummyOrg,
                                          height: 50, width: 50)),
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                              )
                            : Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: FileImage(File(
                                            createOrgController
                                                .orgThumb.value)))),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              getSizedBox(h: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Org Name*",
                      style: size14_M_normal(textColor: Colors.black),
                    ),
                  ],
                ),
              ),
              getSizedBox(h: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                    onChange: (text) {
                      createOrgController.orgName.value = text.trim();
                    },
                    validate: (value) {
                      return value!.isEmpty
                          ? "Enter Org name"
                          : value.trim().length < 3
                              ? "Enter minimum 3 character"
                              : null;
                    },
                    hintText:
                        "Shorter the better,try your community name in 7 words"),
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
                            onChanged: (text) {
                              createOrgController.username.value = text.trim();
                              if (text.trim().isNotEmpty) {
                                Api.get.call(context,
                                    method:
                                    "user/check-username/${text.trim()}",
                                    param: {
                                      "user_id": AppPreference()
                                          .getString(PreferencesKey.orgUserId),
                                    },
                                    isLoading: false,
                                    onResponseSuccess: (Map object) {
                                      createOrgController.userNameAvilable.value =
                                          object['isStatus'] == 1;
                                    });
                              }
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-z@_]"))
                            ],
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Enter your username"
                                  : createOrgController
                                  .userNameAvilable.value ==
                                  false
                                  ? "Username is already exist!"
                                  : null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 20),
                              hintText: "username",
                              suffixStyle:
                              size12_M_medium(textColor: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child:
                                createOrgController.userNameAvilable.value
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
                      "Category*",
                      style: size14_M_normal(textColor: Colors.black),
                    ),
                    const Spacer(),
                    Text(
                      "(Min 1,max 3 categories)",
                      style: size10_M_normal(textColor: Colors.grey),
                    ),
                  ],
                ),
              ),
              getSizedBox(h: 5),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                      spacing: 5,
                      children: List.generate(
                          createOrgController.categoryList.length, (index) {
                        return Chip(
                          label: Text(
                              createOrgController.categoryList[index].name!),
                          onDeleted: () {
                            createOrgController.categoryList.removeAt(index);
                          },
                        );
                      })),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 40,
                  child: TypeAheadFormField<Category>(
                    textFieldConfiguration: TextFieldConfiguration(
                        style: size14_M_normal(textColor: color606060),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFf7f7f7),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
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
                                  const BorderSide(color: white, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: white, width: 1),
                            ),
                            hintText: "Category",
                            hintStyle:
                                size14_M_normal(textColor: color606060))),
                    suggestionsCallback: (pattern) {
                      return _getCategory(pattern, context);
                    },
                    hideSuggestionsOnKeyboardHide: false,
                    itemBuilder: (context, suggestion) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          suggestion.name!,
                          style: size14_M_normal(textColor: color606060),
                        ),
                      );
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (suggestion) {
                      if (createOrgController.categoryList.length < 3) {
                        createOrgController.categoryList.add(suggestion);
                      } else {
                        var snackBar = const SnackBar(
                          content: Text('Max 3 allowed'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
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
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: white, width: 1),
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
                    createOrgController.city.value = suggestion.district!;
                    createOrgController.state.value = suggestion.state!;
                    createOrgController.country.value = suggestion.country!;
                  },
                ),
              ),
              getSizedBox(h: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Org Type",
                      style: size14_M_normal(textColor: Colors.black),
                    ),
                  ],
                ),
              ),
              getSizedBox(h: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTextField(
                    validate: (value) {
                      return value!.isEmpty ? "Enter Org Type" : null;
                    },
                    onChange: (text) {
                      createOrgController.orgType.value = text;
                    },
                    hintText: "NGO /Union /Party /Group /Trust"),
              ),
              getSizedBox(h: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Vision Statement",
                      style: size14_M_normal(textColor: Colors.black),
                    ),
                  ],
                ),
              ),
              getSizedBox(h: 5),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Container(
              //     height: getHeight(120),
              //     width: Get.width,
              //     decoration: BoxDecoration(
              //         color: const Color(0xFFf7f7f7),
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(color: Colors.white)),
              //     child: TextFormField(
              //       inputFormatters: [
              //         LengthLimitingTextInputFormatter(400),
              //       ],
              //       textInputAction: TextInputAction.done,
              //       textCapitalization: TextCapitalization.sentences,
              //       keyboardType: TextInputType.multiline,
              //       maxLines: null,
              //       style: size14_M_normal(textColor: color606060),
              //       onChanged: (text) {
              //         createOrgController.visionStatement.value = text;
              //       },
              //       decoration: const InputDecoration(
              //         contentPadding: const EdgeInsets.symmetric(
              //             horizontal: 15, vertical: 10),
              //         hintText:
              //             "Help your audience know your Vision max 400 words",
              //         border: InputBorder.none,
              //       ),
              //     ),
              //   ),
              // ),
              // getSizedBox(h: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     children: [
              //       Text(
              //         "Org Address",
              //         style: size14_M_normal(textColor: Colors.black),
              //       ),
              //     ],
              //   ),
              // ),
              // getSizedBox(h: 5),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: AppTextField(
              //       inputFormatters: [
              //         LengthLimitingTextInputFormatter(100),
              //       ],
              //       onChange: (text) {
              //         createOrgController.orgAddress.value = text;
              //       },
              //       hintText:
              //           "Type Org Contact Number(this wont be shown to public)"),
              // ),
              // getSizedBox(h: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GetBuilder(
                      builder: (CreateOrgController createOrgController) {
                        return GestureDetector(
                          onTap: () {
                            if (createOrgController.isSelected) {
                              createOrgController.isSelected = false;
                            } else {
                              createOrgController.isSelected = true;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border.all(color: colorBlack),
                                borderRadius: BorderRadius.circular(2)),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: createOrgController.isSelected
                                      ? colorBlack
                                      : Colors.transparent),
                            ),
                          ),
                        );
                      },
                    ),
                    getSizedBox(w: 8),
                    Expanded(
                      child: Text(
                        "I agree to the community guidelines set by Mudda",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: size14_M_medium(textColor: colorGrey),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetStartedButton(
                    title: "Register Up",
                    onTap: () async {
                      List<String> idList = [];
                      for (Category challenges
                          in createOrgController.categoryList) {
                        idList.add(challenges.name!);
                      }
                      if (_formKey.currentState!.validate()) {
                        if (idList.isNotEmpty) {
                          if (createOrgController.isSelected) {
                            AppPreference _appPreference = AppPreference();
                            FormData formData = FormData.fromMap({
                              "fullname": createOrgController.orgName.value,
                              "city": createOrgController.city.value,
                              "state": createOrgController.state.value,
                              "country": createOrgController.country.value,
                              "organization_type":
                                  createOrgController.orgType.value,
                              "username": createOrgController.username.value,
                              "user_type": "organisation",
                              "category": jsonEncode(idList),
                              "created_by": _appPreference
                                  .getString(PreferencesKey.userId),
                            });
                            if (createOrgController.orgThumb.value.isNotEmpty) {
                              var video = await MultipartFile.fromFile(
                                  createOrgController.orgThumb.value,
                                  filename: createOrgController.orgThumb.value
                                      .split('/')
                                      .last);
                              formData.files.addAll([
                                MapEntry("profile", video),
                              ]);
                            }
                            Api.uploadPost.call(context,
                                method: "user/create-organization",
                                param: formData,
                                isLoading: true,
                                onResponseSuccess: (Map object) {
                              print(object);
                              var snackBar = const SnackBar(
                                content: Text('Uploaded'),
                              );
                              createOrgController.orgId.value =
                                  object['data']['_id'];
                              createOrgController.city.value = "";
                              createOrgController.state.value = "";
                              createOrgController.country.value = "";
                              createOrgController.orgType.value = "";
                              createOrgController.categoryList.value = [];
                              AppPreference().setString(
                                  PreferencesKey.orgUserId,
                                  object['data']['_id']);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Get.back();
                              Get.toNamed(RouteConstants.orgCreated);
                            });
                          } else {
                            var snackBar = const SnackBar(
                              content: Text(
                                  'agree to the community guidelines set by Mudda'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } else {
                          var snackBar = const SnackBar(
                            content: Text('Enter Category'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                  )
                ],
              )
            ],
          ),
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

  Future<List<Category>> _getCategory(
      String query, BuildContext context) async {
    List<Category> matches = <Category>[];
    if (query.isNotEmpty) {
      var responce = await Api.get.futureCall(context,
          method: "category/index",
          param: {"page": "1", "search": query},
          isLoading: false);
      print("RES:::${responce.data!}");
      var result = CategoryListModel.fromJson(responce.data!);
      return result.data!;
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
                          if(value.lengthSync()>150000) {
                            testCompressAndGetFile(90,
                                value, '${value.path}compressed.jpg').then((
                                value) {
                              createOrgController.orgThumb.value =
                                  value.path;
                            });
                          }
                          else{
                            createOrgController.orgThumb.value =
                                value.path;
                          }
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
                        if(value.lengthSync()>150000) {
                          testCompressAndGetFile(90,
                            value, '${value.path}compressed.jpg').then((
                            value) {
                              createOrgController.orgThumb.value =
                              value.path;
                          });
                        }
                        else{
                          createOrgController.orgThumb.value =
                        value.path;
                        }
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
