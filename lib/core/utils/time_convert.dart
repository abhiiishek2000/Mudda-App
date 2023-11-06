 import 'package:jiffy/jiffy.dart';

class TimeConvert{
  static String Ttime (String time){
    String ctime = Jiffy(time).Hm;
    return ctime;
  }
  static String Dtime (String time){
    String ctime = Jiffy(time).yMMMdjm;
    return ctime;
  }
}