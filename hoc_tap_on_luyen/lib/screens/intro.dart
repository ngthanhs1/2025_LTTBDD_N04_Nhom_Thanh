import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'home.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorScheme.primaryContainer.withOpacity(0.1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo hoặc icon app
                Icon(
                  Icons.school_rounded,
                  color: kColorScheme.primary,
                  size: 100,
                ),
                const SizedBox(height: 20),
                // Tên ứng dụng
                Text(
                  "Học tập & Ôn luyện",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: kColorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Luyện tập từ vựng và làm quiz mỗi ngày để giỏi hơn!",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                ),
                const Spacer(),
                // Nút bắt đầu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "BẮT ĐẦU HỌC",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
