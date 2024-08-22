import 'package:flutter/material.dart';
import 'package:note_app_may/view/note_list_screen/note_list_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NoteListScreen(),
    );
  }
}
