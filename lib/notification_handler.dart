import 'package:flutter/foundation.dart';

class NotificationHandler extends ValueNotifier<bool>{

  NotificationHandler(super.value);

  void initialise(){
    value = true;
    print('========> value $value');
  }
}