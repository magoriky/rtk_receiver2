String utc2kst(String utcTime) {
  String hour = utcTime.substring(0, 2);
  int hourInt = int.parse(hour);
  hourInt += 9;
  if (hourInt >= 24) {
    hourInt -= 24;
  }
  hour = hourInt.toString();
  String minutes = utcTime.substring(2, 4);
  String seconds = utcTime.substring(4, 6);
  String miliseconds = utcTime.substring(7, 9);

  String time = "$hour : $minutes : $seconds : $miliseconds";

  return time;
}
