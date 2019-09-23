import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(this._courseStorage, {Key key}) : super(key: key);

  final CourseStorage _courseStorage;

  @override
  _SettingsPageState createState() =>
      _SettingsPageState(_courseStorage);
}

class _SettingsPageState extends State<SettingsPage> {
  final _editCoursesController = TextEditingController();
  final CourseStorage _courseStorage;

  int _parsedCoursesCount = 0;

  _SettingsPageState(this._courseStorage) {
    this._courseStorage.readFileContent.then((onValue) {
      _editCoursesController.text = onValue;
      _tryParse();
    });
  }

  @override
  void dispose() {
    _editCoursesController.dispose();
    super.dispose();
  }

  void _tryParse() {
    var text = _editCoursesController.text;
    var parsedCourses = this._courseStorage.parseCourses(text).length;

    setState(() {
      _parsedCoursesCount = parsedCourses;
    });
  }

  void _save() {
    this._courseStorage.writeCourses(_editCoursesController.text);
    Navigator.pop(context);
  }

  void _clear() {
    _editCoursesController.text = "";

    setState(() {
      _parsedCoursesCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _editCoursesController,
              onSubmitted: (_) {
                _tryParse();
              },
              onChanged: (text) {
                print("changed to " + text);
                _tryParse();
              },
              minLines: 10,
              maxLines: 16,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  onPressed: _clear,
                  child: Text("Clear"),
                ),
                FlatButton(
                  onPressed: _parsedCoursesCount == 0 ? null : _save,
                  child: Text("Save"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
