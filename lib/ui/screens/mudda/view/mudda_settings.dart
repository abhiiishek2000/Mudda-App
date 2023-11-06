import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaDetails.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/route_constants.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../model/MuddaPostModel.dart';
import '../../home_screen/controller/mudda_fire_news_controller.dart';
import '../../leader_board/view/leader_board_approval_screen.dart';

class MuddaSettings extends StatefulWidget {
  const MuddaSettings({Key? key}) : super(key: key);

  @override
  State<MuddaSettings> createState() => _MuddaSettingsState();
}




class _MuddaSettingsState extends State<MuddaSettings> {
  MuddaNewsController muddaNewsController= Get.put(MuddaNewsController());
  List<String> des = [
    'You Submit the Mudda with Scope Changed',
    'Your Mudda is reviewed and Approved by Mudda Support',
    'If the scope is expanding, then you would need to get the required leaders as per this chart',
    'Once the requirement is met, the scope of mudda will be changed.'
  ];
  List<String> des2 = [
    'The Mudda will be closed for the Public to further Vote or Discuss.',
    'The Mudda Statistics will be forzen and can’t be changed.',
    'The Mudda will be shown in all the Leader’s profile with final Mudda score.',
    '  You can’t open this Mudda again, until you again have approvals from Mudda Official Team as well as the required number of Leaders approving it again.'
  ];






  @override
  void initState() {
    _getMuddaDetails(context);
    super.initState();
  }
  _getMuddaDetails(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/edit/${AppPreference().getString(PreferencesKey.userId)}",
        param: {
          "_id": muddaNewsController.muddaPost.value.sId
        },
        isLoading: true, onResponseSuccess: (Map object) {

          var result = MuddaDetails.fromJson(object);
          muddaNewsController.muddaProfilePath.value = result.path!;
          muddaNewsController.muddaDetails.value= result.data!;

        });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: AppBar(
        backgroundColor: colorAppBackground,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(onPressed: ()=>Get.back(), icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 25,
        ),),
        title: Text('Mudda Settings',style: size18_M_bold(textColor: Colors.black),),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(ScreenUtil().setSp(8)),
                      child: SizedBox(
                        height: ScreenUtil().setSp(80),
                        width: ScreenUtil().setSp(80),
                        child: CachedNetworkImage(
                          imageUrl:
                          "${muddaNewsController.muddaProfilePath.value}${muddaNewsController.postForMuddaMuddaThumbnail}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12.5),
                Expanded(
                  child: Text(
                    muddaNewsController.muddaPost.value.title !=
                        null
                        ? muddaNewsController
                        .muddaPost.value.title!
                        : "Title",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: size14_M_bold(
                      textColor: const Color(0xFF202020),
                    ),
                  ),
                ),

              ],),
            SizedBox(height: 12),
            Text.rich(
                TextSpan(
                    text: 'Description: ',style:size12_M_bold(
                  textColor: blackGray,),
                    children: <InlineSpan>[
                      TextSpan(
                        text:  muddaNewsController.muddaDetails.value.muddaDescription !=
                            null
                            ? muddaNewsController.muddaDetails.value.muddaDescription!
                            : "Description",
                        style: size12_M_regular(
                            textColor: blackGray),
                      )
                    ]
                )
            ),
            SizedBox(height: 12),
            Divider(color: white,height: 1,thickness: 1),
            SizedBox(height: 19),
            testTile('Edit Mudda','',(){
              Get.toNamed(
                  RouteConstants.raisingMudda,
                  arguments: {
                    "adminMessage": null,
                  });
            }),
           Obx(() =>testTile('Scope of Mudda:  ','${muddaNewsController.muddaDetails.value.initialScope}',()=>showScopeDialog(context))),
            testTile('Conclude & Archieve Mudda','',()=>showConcludeDialog(context)),
            testTile('Postings & Approvals: ','${muddaNewsController.muddaDetails.value.postApprovals}',()=>postApprovalApi(context)),
            testTile('Join Request Approvals:  ','${muddaNewsController.muddaDetails.value.joinApprovals}',()=>joinApprovalApi(context)),
            testTile('View / Edit Leaders','',(){
              muddaNewsController.leaderBoardIndex
                  .value = 0;
              Get.to(
                    () => LeaderBoardApprovalScreen(muddaId: muddaNewsController.muddaPost.value.sId,isFromAdmin: true,),
              );
            }),

          ],
        ),
      )),
    );
  }


  postApprovalApi(BuildContext context){
    Api.post.call(context,
        method: "mudda/update",
        param: {
          '_id': muddaNewsController.muddaPost.value.sId,
          'postApprovals': muddaNewsController.muddaDetails.value.postApprovals=='all'? 'admin': 'all'
        },
        isLoading: true, onResponseSuccess: (Map object) {
          muddaNewsController.muddaDetails.value.postApprovals = object['data']['postApprovals'];
          setState(() {
          });
          var snackBar = const SnackBar(
            content: Text('Updated'),
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar);
        });
  }
  joinApprovalApi(BuildContext context){
    Api.post.call(context,
        method: "mudda/update",
        param: {
          '_id': muddaNewsController.muddaPost.value.sId,
          'joinApprovals': muddaNewsController.muddaDetails.value.joinApprovals=='all'? 'admin': 'all'
        },
        isLoading: true, onResponseSuccess: (Map object) {
          muddaNewsController.muddaDetails.value.joinApprovals = object['data']['joinApprovals'];
          setState(() {
          });
          var snackBar = const SnackBar(
            content: Text('Updated'),
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar);
        });
  }
  showScopeDialog(BuildContext context) {
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Obx(() => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: white
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: ScreenUtil().setSp(68),
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xff606060),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Edit Scope of Mudda',style:size16_M_normal(
                          textColor: white))
                    ],
                  ),
                ),
                getSizedBox(h: ScreenUtil().setSp(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text('Scope:'),
                        SizedBox(width: 8),
                        SizedBox(
                          height: ScreenUtil().setSp(25),
                          width: ScreenUtil().setSp(80),
                          child: DropdownButtonFormField<String>(
                            icon: SvgPicture.asset(
                              AppIcons.icDropDown,
                            ),
                            isExpanded: false,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: ScreenUtil().setSp(8)),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(color: grey)),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(color: grey)),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(color: grey),
                                )),
                            hint: Text( muddaNewsController.muddaDetails.value.initialScope!=null? "${muddaNewsController.muddaDetails.value.initialScope}":"Scope",
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(12),
                                    color: buttonBlue)),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil().setSp(12),
                                color: buttonBlue),
                            items: <String>[
                              "District",
                              "State",
                              "National",
                              "World"
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(12),
                                        color: black)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              String convert = newValue =='District' ? 'district': newValue =='State'? 'state': newValue =='National'? 'country':'worldwide';
                              muddaNewsController.initialScope.value = convert;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Know More',style: size12_M_regular(
                            textColor: Color(0xff2176FF)),),
                        SizedBox(width: 4),
                        SvgPicture.asset(
                          AppIcons.questionIcon,
                        ),
                      ],
                    ),
                  ],
                ),
                getSizedBox(h: ScreenUtil().setSp(32)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: (){
                      Api.post.call(context,
                          method: "mudda/update",
                          param: {
                            '_id': muddaNewsController.muddaPost.value.sId,
                            'initial_scope': muddaNewsController.initialScope.value
                          },
                          isLoading: true, onResponseSuccess: (Map object) {
                            MuddaDetailsData mudda = muddaNewsController.muddaDetails.value;
                            mudda.initialScope = object['data']['initial_scope'];
                            muddaNewsController.muddaDetails.value = mudda;
                            setState(() {

                            });
                            var snackBar = const SnackBar(
                              content: Text('Update'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Get.back();
                          });
                    }, child: Text('Done')),
                    TextButton(onPressed: (){
                      Get.back();
                    }, child: Text('Cancel'))
                  ],
                ),
                getSizedBox(h: ScreenUtil().setSp(20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Steps:'),
                ),
                for (var i = 0; i < des.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i+1}.',style: size12_M_regular(
                            textColor: blackGray),),
                        SizedBox(width: 4),
                        Expanded(
                          child: Container(
                              child: Text(des[i],style: size12_M_regular(
                                  textColor: blackGray),)),
                        )
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Text('Your Mudda will still be live in the original scope until the new scope process is completed',style: GoogleFonts.nunitoSans(
                      color: Color(0xff2176FF),
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400),),
                )
              ],
            ),

          ),
        ));
      },
    );
  }
  showConcludeDialog(BuildContext context) {
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: white
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: ScreenUtil().setSp(68),
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xff606060),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Are you sure you want to conclude this Mudda?',style:size16_M_normal(
                          textColor: white))
                    ],
                  ),
                ),
                getSizedBox(h: ScreenUtil().setSp(16)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('What happens once you Conclude a Mudda-',style: size14_M_semiBold(
                      textColor: blackGray),),
                ),
                for (var i = 0; i < des2.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i+1}.',style: size12_M_regular(
                            textColor: blackGray),),
                        SizedBox(width: 4),
                        Expanded(
                          child: Container(
                              child: Text(des[i],style: GoogleFonts.nunitoSans(
                                  color: blackGray,
                                  fontSize: 12.sp,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400))),
                        )
                      ],
                    ),
                  ),
                ],
                getSizedBox(h: ScreenUtil().setSp(32)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: (){
                      Api.post.call(context,
                          method: "mudda/archive/${muddaNewsController.muddaPost.value.sId}",
                          param: {},
                          isLoading: true, onResponseSuccess: (Map object) {
                            print(object);
                            var snackBar = const SnackBar(
                              content: Text('Archived'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Get.back();
                          });
                    }, child: Text('Yes')),
                    TextButton(onPressed: (){
                      Get.back();
                    }, child: Text('No'))
                  ],
                ),

              ],
            ),

          ),
        );
      },
    );
  }
  Widget testTile(String title,String value,Function() onTap){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Container(height: 5,width: 5,decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle
                ),),
                SizedBox(width: 12),
                Text.rich(
                    TextSpan(
                        text: title,style:size16_M_normal(
                      textColor: Color(0xff31393C)),
                        children: <InlineSpan>[
                          TextSpan(
                            text: value,
                            style: size16_M_bold(
                                textColor: Color(0xff31393C)),
                          )
                        ]
                    )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
