import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mudda/model/NotificationModel.dart';

class NotificationController extends GetxController{

  RxList<NotificationData> notificationList = List<NotificationData>.from([]).obs;
}