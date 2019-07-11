import 'package:intl/intl.dart';

class DateTemplateFiller {
  String fillStringWithDate(String input, DateTime date) {
    RegExp exp = new RegExp("\\{(.+?)\\}");

    Match match;
    while ((match = exp.firstMatch(input)) != null) {
      String variableName = match.group(1);

      String variableValue;
      try {
        variableValue = new DateFormat(variableName).format(date);
      } catch (e) {
        throw new DateFormatException();
      }

      input = input.replaceRange(match.start, match.end, variableValue);
    }

    return input;
  }
}

class DateFormatException with Exception {}
