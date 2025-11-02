import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../Quiz/quiz_home.dart';
import '../Flashcard/flashcard_home.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _cachedStats;

  @override
  void initState() {
    super.initState();
    // Hiển thị ngay dữ liệu mặc định để tránh trễ lần đầu
    _cachedStats = {
      'studyTime': 0,
      'quizDone': 0,
      'avgScore': 0,
      'quizTopics': 0,
      'quizQuestions': 0,
      'flashTopics': 0,
      'flashTotal': 0,
      'flashLearned': 0,
      'dailyUsage': List<int>.filled(30, 0),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FB),
      appBar: AppBar(
        title: const Text('Trang chủ'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadStats(),
        builder: (context, snapshot) {
          final stats = snapshot.data ?? _cachedStats;
          if (stats == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          }
          final dailyUsage = (stats['dailyUsage'] as List).cast<int>();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- CHỨC NĂNG ---
                const Text(
                  'Chức năng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _FeatureCard(
                      icon: Icons.quiz_rounded,
                      title: 'Quiz',
                      color: const Color(0xFFEFF3FF),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuizHomeScreen(),
                        ),
                      ),
                    ),
                    _FeatureCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Flashcard',
                      color: const Color(0xFFF3F7FF),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FlashcardHomeScreen(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- THỐNG KÊ NHANH ---
                const Text(
                  'Thống kê nhanh',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // --- 3 BOX NHANH ---
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _StatCard(
                      icon: Icons.timer_outlined,
                      title: 'Hôm nay',
                      value: '${stats['studyTime']} phút',
                      color: Colors.grey.shade100,
                    ),
                    _StatCard(
                      icon: Icons.check_circle_outline,
                      title: 'Quiz đã làm',
                      value: '${stats['quizDone']}',
                      color: Colors.grey.shade100,
                    ),
                    _StatCard(
                      icon: Icons.speed_outlined,
                      title: 'Điểm TB',
                      value: '${stats['avgScore']}%',
                      color: Colors.grey.shade100,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // --- TỔNG QUAN QUIZ ---
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thống kê Quiz',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _KeyVal(
                                label: 'Chủ đề',
                                value: '${stats['quizTopics']}',
                              ),
                            ),
                            Expanded(
                              child: _KeyVal(
                                label: 'Câu hỏi',
                                value: '${stats['quizQuestions']}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _KeyVal(
                                label: 'Đã làm',
                                value: '${stats['quizDone']}',
                              ),
                            ),
                            Expanded(
                              child: _KeyVal(
                                label: 'Điểm TB',
                                value: '${stats['avgScore']}%',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // --- TỔNG QUAN FLASHCARD ---
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thống kê Flashcard',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _KeyVal(
                                label: 'Chủ đề',
                                value: '${stats['flashTopics']}',
                              ),
                            ),
                            Expanded(
                              child: _KeyVal(
                                label: 'Tổng thẻ',
                                value: '${stats['flashTotal']}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _KeyVal(
                          label: 'Đã học',
                          value: '${stats['flashLearned']} thẻ',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- BIỂU ĐỒ THỜI GIAN THÁNG NÀY ---
                _UsageChartCard(dailyUsage: dailyUsage),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- LOAD DỮ LIỆU CÓ CACHE + CHẠY SONG SONG ---
  Future<Map<String, dynamic>> _loadStats() async {
    if (_cachedStats != null) return _cachedStats!;

    final results = await Future.wait([
      FirestoreService.instance.countQuizTopics(),
      FirestoreService.instance.countAllQuestions(),
      FirestoreService.instance.countFlashTopics(),
      FirestoreService.instance.countAllFlashcards(),
    ]);

    final quizTopics = results[0];
    final quizQuestions = results[1];
    final flashTopics = results[2];
    final flashTotal = results[3];

    // Giả lập dữ liệu biểu đồ (mỗi ngày trong tháng: 0–120 phút)
    final random = Random();
    final dailyUsage = List.generate(30, (_) => random.nextInt(120));

    _cachedStats = {
      'studyTime': 45,
      'quizDone': 8,
      'avgScore': 82,
      'quizTopics': quizTopics,
      'quizQuestions': quizQuestions,
      'flashTopics': flashTopics,
      'flashTotal': flashTotal,
      'flashLearned': (flashTotal / 2).round(),
      'dailyUsage': dailyUsage,
    };
    return _cachedStats!;
  }
}

// ==================== WIDGETS =====================

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.indigo),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _UsageChartCard extends StatelessWidget {
  final List<int> dailyUsage;

  const _UsageChartCard({required this.dailyUsage});

  @override
  Widget build(BuildContext context) {
    final days = List.generate(dailyUsage.length, (i) => i + 1);
    final maxValue = dailyUsage.isEmpty ? 0 : dailyUsage.reduce(max).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tổng thời lượng sử dụng (tháng này)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return Text(
                          day % 5 == 0 ? '$day' : '',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: days
                    .map(
                      (d) => BarChartGroupData(
                        x: d,
                        barRods: [
                          BarChartRodData(
                            toY: dailyUsage[d - 1].toDouble(),
                            color: Colors.indigo,
                            width: 6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                maxY: maxValue == 0 ? 10 : maxValue + 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Key-Value row inside cards ---
class _KeyVal extends StatelessWidget {
  const _KeyVal({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
