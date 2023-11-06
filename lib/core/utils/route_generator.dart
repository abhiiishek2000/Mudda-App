import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/ui/screens/circle_chat/view/channel_window_screen.dart';
import 'package:mudda/ui/screens/circle_chat/view/circle_chat_screen.dart';
import 'package:mudda/ui/screens/circle_chat/view/create_channel.dart';
import 'package:mudda/ui/screens/circle_chat/view/org_chat_page.dart';
import 'package:mudda/ui/screens/circle_chat/view/stages_live_comments_leaders.dart';
import 'package:mudda/ui/screens/edit_profile/view/org_builder_screen.dart';
import 'package:mudda/ui/screens/edit_profile/view/org_profile_update_screen.dart';
import 'package:mudda/ui/screens/edit_profile/view/user_profile_update_screen.dart';
import 'package:mudda/ui/screens/home_screen/view/home_screen.dart';
import 'package:mudda/ui/screens/home_screen/widget/share_mudda_screen.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/search_screen.dart';
import 'package:mudda/ui/screens/leader_board/view/follower_following_suggestion_screen.dart';
import 'package:mudda/ui/screens/leader_board/view/leader_board_approval_screen.dart';
import 'package:mudda/ui/screens/leader_board/view/leader_board_grid_view.dart';
import 'package:mudda/ui/screens/leader_board/view/leader_board_screen.dart';
import 'package:mudda/ui/screens/leader_board/view/new_request_screen.dart';
import 'package:mudda/ui/screens/login_screen/view/intro_screen.dart';
import 'package:mudda/ui/screens/login_screen/view/login_screen.dart';
import 'package:mudda/ui/screens/mudda/view/mudda_container_replies.dart';
import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/screens/mudda/widget/audio_stages.dart';
import 'package:mudda/ui/screens/mudda/widget/mudda_post_comment.dart';
import 'package:mudda/ui/screens/mudda/widget/stages_live_comments.dart';
import 'package:mudda/ui/screens/mudda/widget/upload_post.dart';
import 'package:mudda/ui/screens/mudda/widget/video_stages.dart';
import 'package:mudda/ui/screens/mudda/widget/video_stages_full_screen.dart';
import 'package:mudda/ui/screens/muddabuzz_screen/view/mudda_buzz.dart';
import 'package:mudda/ui/screens/muddabuzz_screen/view/mudda_buzz_feed.dart';
import 'package:mudda/ui/screens/notification/notification_screen.dart';
import 'package:mudda/ui/screens/other_user_profile/view/chat_page.dart';
import 'package:mudda/ui/screens/other_user_profile/view/other_org_profile.dart';
import 'package:mudda/ui/screens/other_user_profile/view/other_user_profile.dart';
import 'package:mudda/ui/screens/profile_screen/view/profile_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/follow_search_screen.dart';

import 'package:mudda/ui/screens/profile_screen/widget/follower_user_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/invite_org_search_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/invite_search_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/member_request_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/org_addtional_data_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/org_created_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/org_members_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/other_org_members_screen.dart';
import 'package:mudda/ui/screens/quotes_list/widget/comments_section_screen.dart';
import 'package:mudda/ui/screens/quotes_list/widget/single_activity_post.dart';
import 'package:mudda/ui/screens/quotes_list/widget/upload_quote_activity.dart';
import 'package:mudda/ui/screens/raising_mudda/view/raising_mudda_additional_information_screen.dart';
import 'package:mudda/ui/screens/raising_mudda/view/raising_mudda_chat_screen.dart';
import 'package:mudda/ui/screens/raising_mudda/view/raising_mudda_screen.dart';
import 'package:mudda/ui/screens/setting_screen/view/category_choice_screen.dart';
import 'package:mudda/ui/screens/setting_screen/view/improvement_feedback_screen.dart';
import 'package:mudda/ui/screens/setting_screen/view/notification_setting_screen.dart';
import 'package:mudda/ui/screens/setting_screen/view/support_register_user_screen.dart';
import 'package:mudda/ui/screens/setting_screen/view/verify_your_profile_screen.dart';
import 'package:mudda/ui/screens/sign_up_screen/view/sign_up_screen.dart';
import 'package:mudda/ui/screens/splash_screen/view/splash_screen.dart';
import 'package:mudda/ui/screens/support_register_screen/view/support_register_screen.dart';
import 'package:mudda/core/constant/route_constants.dart';
import '../../ui/screens/circle_chat/view/mudda_chat_page.dart';
import '../../ui/screens/home_screen/widget/component/invite_support_screen.dart';
import '../../ui/screens/leader_board/view/admin_leader_board.dart';
import '../../ui/screens/mudda/view/mudda_settings.dart';
import '../../ui/screens/mudda/view/see_all_replies.dart';
import '../../ui/screens/mudda/view/upload_reply.dart';
import '../../ui/screens/mudda/widget/edit_post.dart';

class RouteGenerator {
  List<GetPage> getAllRoute() {
    List<GetPage> pages = [
      getPageAnimationR2L(
          name: RouteConstants.splashScreen, page: SplashScreen()),
      getPageAnimationR2L(
          name: RouteConstants.loginScreen, page: LoginScreen()),
      getPageAnimationR2L(
          name: RouteConstants.introScreen, page: const IntroScreen()),
      getPageAnimationR2L(
          name: RouteConstants.homeScreen, page: const HomeScreen()),
      getPageAnimationR2L(
          name: RouteConstants.homeScreen1, page: const StageHome()),
      getPageAnimationR2L(
          name: RouteConstants.shareMuddaScreen, page: ShareMuddaScreen()),
      getPageAnimationR2L(
          name: RouteConstants.signupScreen, page: const SignUpScreen()),
      getPageAnimationR2L(
          name: RouteConstants.shareMuddaScreen, page: ShareMuddaScreen()),
      getPageAnimationR2L(
          name: RouteConstants.signupScreen, page: const SignUpScreen()),
      getPageAnimationR2L(
          name: RouteConstants.supportRegister,
          page: const SupportRegisterScreen()),
      getPageAnimationR2L(
          name: RouteConstants.userProfileEdit, page: UserProfileEditScreen()),
      getPageAnimationR2L(
          name: RouteConstants.orgProfileEdit, page: OrgProfileEditScreen()),
      getPageAnimationR2L(
          name: RouteConstants.orgBuilder, page: OrgBuilderScreen()),
      getPageAnimationR2L(
          name: RouteConstants.memberRequest,
          page: const MemberRequestScreen()),
      getPageAnimationR2L(
          name: RouteConstants.followerScreen,
          page: const FollowerFollowingSuggestionScreen()),
      getPageAnimationR2L(
          name: RouteConstants.orgCreated, page: OrgCreatedScreen()),
      getPageAnimationR2L(
          name: RouteConstants.orgMembers, page: OrgMembersScreen()),
      getPageAnimationR2L(
          name: RouteConstants.otherOrgMembers, page: OtherOrgMembersScreen()),
      getPageAnimationR2L(
          name: RouteConstants.commentSections,
          page: const CommentsSectionScreen()),
      getPageAnimationR2L(
          name: RouteConstants.singleActivityPost,
          page: const SingleQouteActivityPost()),
      getPageAnimationR2L(
          name: RouteConstants.orgAdditionalData,
          page: OrgAdditionalDataScreen()),
      getPageAnimationR2L(
          name: RouteConstants.invitedSearchScreen,
          page: InvitedSearchScreen()),
      getPageAnimationL2R(
          name: RouteConstants.searchScreen, page: const SearchScreen()),
      getPageAnimationR2L(
          name: RouteConstants.invitedSupportScreen,
          page: const InvitedSupportScreen()),
      getPageAnimationR2L(
          name: RouteConstants.followSearchScreen, page: FollowSearchScreen()),
      getPageAnimationR2L(
          name: RouteConstants.invitedOrgSearchScreen,
          page: InvitedOrgSearchScreen()),
      getPageAnimationR2L(
          name: RouteConstants.muddaDetailsScreen, page: MuddaDetailsScreen()),
      getPageAnimationR2L(
          name: RouteConstants.uploadPostScreen, page: UploadPostScreen()),
      getPageAnimationR2L(
          name: RouteConstants.uploadReplyScreen, page: UploadReplyScreen()),
      getPageAnimationR2L(
          name: RouteConstants.uploadChildReplyScreen,
          page: UploadChildReplyScreen()),
      getPageAnimationR2L(
          name: RouteConstants.seeAllRepliesScreen,
          page: SeeAllRepliesScreen()),
      getPageAnimationR2L(
          name: RouteConstants.uploadQuoteActivityScreen,
          page: const UploadQuoteActivityScreen()),
      getPageAnimationR2L(
          name: RouteConstants.muddaContainerReplies,
          page: const MuddaContainerReplies()),
      getPageAnimationR2L(
          name: RouteConstants.uploadQuoteActivityScreen,
          page: const UploadQuoteActivityScreen()),
      getPageAnimationR2L(
          name: RouteConstants.muddaPostCommentsScreen,
          page: MuddaPostCommentsScreen()),
      getPageAnimationR2L(
          name: RouteConstants.muddaSettings, page: const MuddaSettings()),
      getPageAnimationR2L(
          name: RouteConstants.audioStagesScreen,
          page: const AudioStagesScreen()),
      getPageAnimationL2R(
          name: RouteConstants.stageLiveCommentsScreen,
          page: const StagesLiveCommentsScreen()),
      getPageAnimationR2L(
          name: RouteConstants.otherUserProfileScreen,
          page: const OtherUserProfileScreen()),
      getPageAnimationR2L(
          name: RouteConstants.otherOrgProfileScreen,
          page: OtherOrgProfileScreen()),
      getPageAnimationR2L(
          name: RouteConstants.newRequestScreen, page: NewRequestScreen()),
      getPageAnimationR2L(
          name: RouteConstants.chatPage, page: const ChatPageScreen()),
      getPageAnimationR2L(
          name: RouteConstants.orgChatPage, page: const OrgChatPageScreen()),
      getPageAnimationR2L(
          name: RouteConstants.muddaChatPage, page: const MuddaChatPageScreen()),
      getPageAnimationR2L(
          name: RouteConstants.raisingMuddaChatPage,
          page: RaisingMuddaChatScreen()),
      getPageAnimationR2L(
          name: RouteConstants.profileScreen, page: const ProfileScreen()),
      getPageAnimationR2L(
          name: RouteConstants.notificationSetting,
          page: const NotificationSettingScreen()),
      getPageAnimationR2L(
          name: RouteConstants.categoryChoice,
          page: const CategoryChoiceScreen()),
      getPageAnimationR2L(
          name: RouteConstants.improvementFeedbacks,
          page: ImprovementFeedBackScreen()),
      getPageAnimationR2L(
          name: RouteConstants.supportRegisterUser,
          page: SupportRegisterUserScreen()),
      getPageAnimationR2L(
          name: RouteConstants.verifyYourProfile,
          page: const VerifyYourProfileScreen()),
      getPageAnimationR2L(
          name: RouteConstants.muddaBazScreen, page: const MuddabuzzScreen()),
      getPageAnimationL2R(
          name: RouteConstants.notificationScreen, page: NotificationScreen()),
      getPageAnimationR2L(
          name: RouteConstants.raisingMudda, page: RaisingMuddaScreen()),
      getPageAnimationR2L(
          name: RouteConstants.raisingMuddaAdditionalInformation,
          page: const RaisingMuddaAdditionalInformationScreen()),
      getPageAnimationR2L(
          name: RouteConstants.circleChat, page: const CircleChatScreen()),
      getPageAnimationR2L(
          name: RouteConstants.stageLiveCommentsLeaders,
          page: const StagesLiveCommentsLeaders()),
      getPageAnimationR2L(
          name: RouteConstants.channelWindowScreen,
          page: const ChannelWindowScreen()),
      getPageAnimationR2L(
          name: RouteConstants.videoStages, page: const VideoStagesScreen()),
      getPageAnimationR2L(
          name: RouteConstants.videoStagesFull,
          page: const VideoStagesFullScreen()),
      getPageAnimationR2L(
          name: RouteConstants.leaderBoard, page: const LeaderBoardScreen()),
      getPageAnimationR2L(
          name: RouteConstants.adminLeaderBoard,
          page: const AdminLeaderBoard()),
      getPageAnimationR2L(
          name: RouteConstants.leaderBoardApproval,
          page: const LeaderBoardApprovalScreen()),
      getPageAnimationR2L(
          name: RouteConstants.leaderBoardWithGridview,
          page: const LeaderBoardGridView()),
      getPageAnimationR2L(
          name: RouteConstants.muddaBuzzFeed,
          page: const MuddaBuzzFeedScreen()),
      getPageAnimationR2L(
          name: RouteConstants.createChannel,
          page: const CreateChannelScreen()),
      getPageAnimationR2L(
          name: RouteConstants.followerInfoScreen, page: FollowerUserScreen()),
      getPageAnimationR2L(
          name: RouteConstants.editPostScreen, page: EditPostScreen()),
    ];
    return pages;
  }

  GetPage getPageAnimationR2L({required String name, required Widget page}) {
    return GetPage(
      name: name,
      page: () => page,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  GetPage getPageAnimationL2R({required String name, required Widget page}) {
    return GetPage(
      name: name,
      page: () => page,
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
