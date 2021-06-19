import 'package:html/parser.dart';

class StringUtil {
  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  // d in second
  static String formatDurationHHmm(int durationInSecond) {
    if (durationInSecond == 0) return "0 sec";
    String result = "";
    int hour = durationInSecond ~/ 3600;
    int minute = durationInSecond % 3600 ~/ 60;
    int second = durationInSecond % 3600 % 60;

    if (hour > 0) {
      result += hour.toString() + " ";
      result += (hour > 1) ? "hours " : "hour ";
    }
    if (minute > 0) {
      result += minute.toString() + " ";
      result += (minute > 1) ? "mins " : "min ";
    }
    if (second > 0) {
      result += second.toString() + " ";
      result += (second > 1) ? "secs " : "sec";
    }
    return result;
  }
}
