import 'package:flutter/material.dart';
import 'package:test_tapped/other/styles.dart';
import 'package:test_tapped/pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tapped Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Builder(
        builder: (context) {
          Style.init(context); // block size initialization
          return const MyHomePage();
        },
      ),
    );
  }
}
