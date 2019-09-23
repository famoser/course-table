import 'package:course_table/pages/settings.dart';
import 'package:course_table/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models.dart';

class CoursePage extends StatefulWidget {
  CoursePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int _today = DateTime.now().weekday;
  int _selectedDay = DateTime.now().weekday;

  final _courseStorage = CourseStorage();

  Map<int, List<Weekly>> _weeklies = getWeekliesDefault();

  static Map<int, List<Weekly>> getWeekliesDefault() {
    return {
      1: List<Weekly>(),
      2: List<Weekly>(),
      3: List<Weekly>(),
      4: List<Weekly>(),
      5: List<Weekly>(),
      6: List<Weekly>(),
      7: List<Weekly>(),
    };
  }

  _CoursePageState() {
    _courseStorage.readCourses().then((courses) {
      var weeklies = courses.map((course) {
        return course.weeklies;
      }).expand((i) => i);

      var newWeeklies = getWeekliesDefault();

      for (var weekly in weeklies) {
        newWeeklies[weekly.weekday].add(weekly);
      }

      // sort that earlier weeklies appear before later
      for (var weekDay in newWeeklies.keys) {
        newWeeklies[weekDay].sort((a, b) {
          return a.start.periodOffset - b.start.periodOffset;
        });
      }

      setState(() {
        _weeklies = newWeeklies;
      });
    });
  }

  static const weekdays = {
    DateTime.monday: "Monday",
    DateTime.tuesday: "Tuesday",
    DateTime.wednesday: "Wednesday",
    DateTime.thursday: "Thursday",
    DateTime.friday: "Friday",
    DateTime.saturday: "Saturday",
    DateTime.sunday: "Sunday"
  };

  List<Widget> _createWeekDayListTiles() {
    var result = List<ListTile>();
    for (var weekday in weekdays.keys) {
      var text = weekdays[weekday];
      if (weekday == _today) {
        text += " (today)";
      }

      result.add(ListTile(
        title: Text(text),
        onTap: () {
          selectDay(weekday);
          Navigator.pop(context);
        },
      ));
    }

    return result;
  }

  List<Card> _displayWeeklies() {
    var weeklies = _weeklies[_selectedDay];

    var result = List<Card>();
    for (var weekly in weeklies) {
      result.add(Card(
        child: Column(
          children: <Widget>[Text(weekly.course.name)],
        ),
      ));
    }

    return result;
  }

  void selectDay(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'Weekdays',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(color: Colors.blue),
                )
              ] +
              _createWeekDayListTiles() +
              <Widget>[
                ListTile(
                  title: Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new SettingsPage(_courseStorage)));
                  },
                )
              ],
        ),
      ),
      body: Center(
          child: ListView(
        children: _displayWeeklies(),
      )),
    );
  }
}
