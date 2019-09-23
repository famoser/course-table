import 'pages/course.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Table',
      theme:
          ThemeData(primarySwatch: Colors.blue, accentColor: Colors.blueAccent),
      home: CoursePage(title: 'Courses'),
    );
  }
}
