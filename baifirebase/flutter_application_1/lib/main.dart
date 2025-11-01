import 'package:flutter/material.dart';
import 'package:flutter_application_1/listpage.dart';
import 'package:flutter_application_1/display_text_image.dart';
import 'package:flutter_application_1/input_text_passwork.dart';
import 'package:flutter_application_1/Row_Column.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Components Demo',

      home: const ListPage(),

      // 🔗 Danh sách các route
      routes: {
        '/text': (context) => const TextPage(),
        '/image': (context) => const ImagePage(),
        '/textfield': (context) => const TextFieldPage(),
        '/password': (context) => const PasswordFieldPage(),
        '/column': (context) => const ColumnLayoutPage(),
        '/row': (context) => const RowLayoutPage(),
      },
    );
  }
}
