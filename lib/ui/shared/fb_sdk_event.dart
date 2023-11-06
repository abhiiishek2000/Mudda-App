import 'package:facebook_app_events/facebook_app_events.dart';

class FaceBookSdk{
  static final facebookAppEvents = FacebookAppEvents();
  static void init(){
    facebookAppEvents.setAdvertiserTracking(enabled: true);
  }
}