import 'package:flutter/material.dart';

class DateTimeUtil {
  static List<TimeOfDay> generateTimeRange({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    bool isHalfHour = false,
  }) {
    List<TimeOfDay> timeIntervals = [];
    TimeOfDay currentTime =
        TimeOfDay(hour: startTime.hour, minute: startTime.minute);

    TimeOfDay addMinutesToTime(TimeOfDay time, int minutes) {
      int totalMinutes = time.hour * 60 + time.minute + minutes;
      int newHour = totalMinutes ~/ 60;
      int newMinute = totalMinutes % 60;
      return TimeOfDay(hour: newHour, minute: newMinute);
    }

    TimeOfDay addHoursToTime(TimeOfDay time, int hours) {
      int totalMinutes = time.hour * 60 + time.minute + (hours * 60);
      int newHour = totalMinutes ~/ 60;
      int newMinute = totalMinutes % 60;
      return TimeOfDay(hour: newHour, minute: newMinute);
    }

    while (currentTime.hour < endTime.hour ||
        (currentTime.hour == endTime.hour &&
            currentTime.minute <= endTime.minute)) {
      timeIntervals.add(currentTime);

      if (isHalfHour) {
        // Increment by 30 minutes
        currentTime = addMinutesToTime(currentTime, 30);
      } else {
        // Increment by 1 hour
        currentTime = addHoursToTime(currentTime, 1);
      }
    }

    return timeIntervals;
  }
}
