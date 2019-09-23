import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class Course {
  Course({
    @required this.name,
    @required this.lecturer,
    @required this.urls,
    @required this.assessment,
    @required this.description,
  });

  final String name;
  final String lecturer;

  final Map<String, String> urls;

  final Assessment assessment;

  final String description;

  List<Weekly> weeklies = List<Weekly>();

  void _addWeekly(Weekly weekly) {
    weeklies.add(weekly);
  }

  static Course parse(YamlMap course) {
    var urls = Map<String, String>();
    for (String key in course.keys) {
      if (key.endsWith("-url")) {
        urls[key.substring(0, key.indexOf("-url"))] = course[key];
      }
    }

    var assessment = Assessment.parse(course["assessment"]);

    var result = Course(
      name: course["name"],
      lecturer: course["lecturer"],
      description: course["description"],
      urls: urls,
      assessment: assessment,
    );

    for (var weekly in course["weekly"]) {
      result._addWeekly(Weekly.parse(weekly, result));
    }

    return result;
  }
}

class Assessment {
  Assessment({
    @required this.credits,
    @required this.type,
  });

  static Assessment parse(YamlMap map) {
    return Assessment(
      credits: map["credits"],
      type: map["type"],
    );
  }

  final int credits;
  final String type;
}

class Weekly {
  Weekly({
    @required this.course,
    @required this.weekday,
    @required this.start,
    @required this.end,
    @required this.place,
    @required this.description,
  });

  final int weekday;
  final TimeOfDay start;
  final TimeOfDay end;
  final String place;
  final String description;
  final Course course;

  static const weekdayMapping = {
    "Monday": 1,
    "Tuesday": 2,
    "Wednesday": 3,
    "Thursday": 4,
    "Friday": 5,
    "Saturday": 6,
    "Sunday": 7
  };

  static Weekly parse(YamlMap map, Course course) {
    var timeArray = map["time"].split(" - ");
    return Weekly(
      course: course,
      weekday: weekdayMapping[map["day"]],
      start: _parseTimeOfDay(timeArray[0]),
      end: _parseTimeOfDay(timeArray[1]),
      place: map["place"],
      description: map["description"],
    );
  }

  static TimeOfDay _parseTimeOfDay(String timeOfDay) {
    if (timeOfDay.contains(":")) {
      var split = timeOfDay.split(":");
      return TimeOfDay(
        hour: int.parse(split[0]),
        minute: int.parse(split[1]),
      );
    } else {
      return TimeOfDay(
        hour: int.parse(timeOfDay),
        minute: 0,
      );
    }
  }
}
