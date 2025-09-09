import 'package:intl/intl.dart';

class TimeFormatter {
  String returnDate(String time) {
    DateTime parseDate = DateFormat("hh:mm").parse(time);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    //print(outputDate);
    return outputDate.toString();
  }

  String durationFormatter(String time) {
    DateTime parseDate = DateFormat("HH:mm").parse(time);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputHourFormat = DateFormat('HH');
    var outputHour = outputHourFormat.format(inputDate);
    var outputMinFormat = DateFormat('mm');
    var outputMin = outputMinFormat.format(inputDate);

    return "${outputHour}H" " ${outputMin}M";
  }

  bool avgColor(String time) {
    DateTime parseDate = DateFormat("HH:mm").parse(time);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputHourFormat = DateFormat('HH');
    var outputHour = outputHourFormat.format(inputDate);
    if (int.parse(outputHour) < 08) {
      return true;
    } else {
      return false;
    }
  }

  bool inTimeColor(String time) {
    DateTime parseDate = DateFormat("hh:mm").parse(time);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputHourFormat = DateFormat('HH');
    var outputHour = outputHourFormat.format(inputDate);
    if (int.parse(outputHour) > 09) {
      return true;
    } else {
      return false;
    }
  }

  bool outTimeColor(String time) {
    DateTime parseDate = DateFormat("hh:mm").parse(time);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputHourFormat = DateFormat('HH');
    var outputHour = outputHourFormat.format(inputDate);
    if (int.parse(outputHour) < 06) {
      return true;
    } else {
      return false;
    }
  }
}
