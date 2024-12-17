import 'package:flutter/material.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({super.key});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
        appBar: AppBar(
          title: Text("Action Screen 1"),
          backgroundColor: Colors.green,
        ),
        body:Container(),
    );
  }
}
