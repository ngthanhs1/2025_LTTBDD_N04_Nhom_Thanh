import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Hello World App')),
        body: Center(child: Text('Hello, World!')),
      ),
    ),
  );
}
