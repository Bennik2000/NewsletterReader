class NetworkUtils {
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
}
