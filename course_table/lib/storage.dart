import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:yaml/yaml.dart';

import 'models.dart';

class CourseStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/courses.yml');
  }

  Future<String> get _localFileContent async {
    final file = await _localFile;
    return await file.readAsString();
  }

  Future<List<Course>> readCourses() async {
    try {
      var contents = await _localFileContent;
      return parseCourses(contents);
    } catch (e) {
      return List<Course>();
    }
  }

  List<Course> parseCourses(String contents) {
    try {
      var yml = loadYaml(contents);

      var courses = List<Course>();
      for (var course in yml["courses"]) {
        courses.add(Course.parse(course));
      }

      return courses;
    } catch (e) {
      return List<Course>();
    }
  }

  Future<File> writeCourses(String courses) async {
    final file = await _localFile;

    return file.writeAsString(courses);
  }
}
