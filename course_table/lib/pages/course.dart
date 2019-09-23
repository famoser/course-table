
import 'package:course_table/pages/settings.dart';
import 'package:course_table/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  int today = DateTime.now().weekday;
  int selectedDay = DateTime.now().weekday;

  final courseStorage = CourseStorage();

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
              _createWeekDayListTiles() +
              <Widget>[
                ListTile(
                  title: Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => new SettingsPage(courseStorage)));
                  },
                )
              ],
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