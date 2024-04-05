import 'dart:math';
import 'dart:ui';

class Constants {
  Constants._();

  static final Random _random = Random();
  static const int _maxColor = 256;

  static const int hoursADay = 24;
  static const int minutesADay = 1440;

  static final List<String> weekTitles = ["月", "火", "水", "木", "金", "土", "日"];

  static const Color defaultLiveTimeIndicatorColor = Color(0xff444444);
  static const Color defaultBorderColor = Color(0xffdddddd);
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color offWhite = Color(0xfff0f0f0);
  static const Color headerBackground = Color(0xFFDCF0FF);
  static Color get randomColor {
    return Color.fromRGBO(_random.nextInt(_maxColor),
        _random.nextInt(_maxColor), _random.nextInt(_maxColor), 1);
  }
}
