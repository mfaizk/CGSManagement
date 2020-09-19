import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  final String studentClass;
  final String studentId;
  InfoScreen({Key key, @required this.studentClass, @required this.studentId})
      : super(key: key);

  static const String id = 'chat';
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.studentClass);
    print(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
