import 'package:intl/intl.dart';

class DateTemplateFiller {

  ///
  /// Fills the given string with the given date. A date format
  /// can be embedded in the string using { }
  ///
  /// Throws a DateFormatException when it can not parse the format
  ///
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
