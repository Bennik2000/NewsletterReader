import 'dart:io';

import 'package:dio/dio.dart';

class HttpUtils {
  static String formatDateForHeader(DateTime date) {
    DateTime utc = date.toUtc();

    var dayNames = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];
    String dayName = dayNames[utc.weekday - 1];

    var monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    String monthName = monthNames[utc.month - 1];

    String day = utc.day.toString().padLeft(2, '0');
    String year = utc.year.toString();
    String hour = utc.hour.toString().padLeft(2, '0');
    String minute = utc.minute.toString().padLeft(2, '0');
    String second = utc.second.toString().padLeft(2, '0');

    return "$dayName, $day $monthName $year $hour:$minute:$second GMT";
  }

  static DateTime parseDateOfHeader(String dateHeader) {
    var exp = RegExp("([A-z]{3}), ([0-9]{2}) ([A-z]{3}) ([0-9]{4}) ([0-9]{2}):([0-9]{2}):([0-9]{2}) GMT");

    var match = exp.firstMatch(dateHeader);

    if (match == null) return null;

    var monthNames = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12,
    };

    int year = int.tryParse(match.group(4));
    int month = monthNames[match.group(3)];
    int day = int.tryParse(match.group(2));
    int hour = int.tryParse(match.group(5));
    int minute = int.tryParse(match.group(6));
    int second = int.tryParse(match.group(7));

    return new DateTime.utc(year, month, day, hour, minute, second, 0, 0);
  }

  static DateTime getCreationDateOrNull(Map<String, String> headers) {
    var lastModified = headers['last-modified'];

    if (lastModified != null) {
      return HttpUtils.parseDateOfHeader(lastModified);
    }

    return null;
  }

  static String getFilenameOfResponseHeader(Map<String, String> headers) {
    if (headers.containsKey("content-disposition")) {
      var contentDisposition = headers["content-disposition"];

      RegExp regExp = new RegExp('filename[*]?=\\"(.*)\\"');
      var matches = regExp.allMatches(contentDisposition).toList();

      if (matches.length > 0) {
        return matches[0].group(1);
      }
    }

    return null;
  }

  static getEtagOrNull(Map<String, String> headers) {
    if (headers.containsKey(HttpHeaders.etagHeader)) {
      return headers[HttpHeaders.etagHeader];
    }

    return null;
  }

}


class HttpRequestHelper{
  final String url;
  Map<String, String> _headers;

  HttpRequestHelper(this.url);

  HttpRequestHelper withHeaders(Map<String, String> headers){
    _headers = headers;

    return this;
  }

  Future<HttpResponse> doGetRequest() async {
    try {
      var response = await Dio().get(
        url,
        options: Options(
          headers: _headers,
        ),
      );

      return HttpResponse(
        response.statusCode,
        _dioHeadersToMap(response),
        true
      );
    } on DioError catch (e) {
      if (e.response != null) {

        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.

        return HttpResponse(
            e.response.statusCode,
            _dioHeadersToMap(e.response),
            false
        );
      } else {
        // Something else went wrong

        return HttpResponse(null, null, false);
      }
    }
  }

  static Map<String, String> _dioHeadersToMap(Response response){
    Map<String, String> headers = {};

    for (var header in response.headers.map.entries) {
      String value = "";

      for (var v in header.value) {
        value += v + " ";
      }

      headers.addAll({header.key: value});
    }

    return headers;
  }
}


class HttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final bool success;
  bool get failed => !success;

  HttpResponse(this.statusCode, this.headers, this.success);
}
