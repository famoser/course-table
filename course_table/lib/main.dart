import 'dart:io';

import 'package:course_table/models.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yaml/yaml.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Table',
      theme:
          ThemeData(primarySwatch: Colors.blue, accentColor: Colors.blueAccent),
      home: MyHomePage(title: 'Courses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CourseStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/courses.yml');
  }

  Future<List<Course>> readCourses() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();

      var yml = loadYaml(contents);

      var courses = List<Course>();
      for (var course in yml["courses"]) {
        courses.add(Course.parse(course));
      }

      return courses;
    } catch (e) {
      // If encountering an error, return 0
      return List<Course>();
    }
  }

  Future<File> writeCourses(String courses) async {
    final file = await _localFile;

    return file.writeAsString(courses);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int today = DateTime.now().weekday;
  int selectedDay = DateTime.now().weekday;

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
      if (weekday == today) {
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

  void selectDay(int day) {
    setState(() {
      selectedDay = day;
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
              _createWeekDayListTiles(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have selected ' + weekdays[selectedDay])
          ],
        ),
      ),
    );
  }
}
