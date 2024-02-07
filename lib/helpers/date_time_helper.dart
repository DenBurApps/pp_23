class DateTimeHelper {
  static String getHours(DateTime dateTime) =>
      dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour.toString();

  static String getMinutes(DateTime dateTime) =>
      dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute.toString();
}