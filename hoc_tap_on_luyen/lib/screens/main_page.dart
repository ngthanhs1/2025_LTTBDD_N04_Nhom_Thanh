import 'package:flutter/material.dart';
import 'trangchu/home.dart';
import 'Quiz/quiz_home.dart';
import 'Flashcard/flashcard_home.dart';
import 'Taikhoan/profile.dart';
import 'trangchu/thongke.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    QuizHomeScreen(),
    FlashcardHomeScreen(),
    ThongKeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _index,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (i) => setState(() => _index = i),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: AppLocalizations.of(context).tabHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.quiz_outlined),
              activeIcon: const Icon(Icons.quiz),
              label: AppLocalizations.of(context).tabQuiz,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_outlined),
              activeIcon: const Icon(Icons.menu_book),
              label: AppLocalizations.of(context).tabFlashcard,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_rounded),
              label: AppLocalizations.of(context).tabStats,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: AppLocalizations.of(context).tabAccount,
            ),
          ],
        ),
      ),
    );
  }
}
