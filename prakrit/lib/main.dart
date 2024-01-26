// main.dart

import 'package:flutter/material.dart';
import 'package:gdsc/pages/Chat_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}
