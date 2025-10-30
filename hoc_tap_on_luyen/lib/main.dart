import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HocTapOnLuyenApp());
}

class HocTapOnLuyenApp extends StatelessWidget {
  const HocTapOnLuyenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Học tập & Ôn luyện',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const IntroScreen(),
    );
  }
}
