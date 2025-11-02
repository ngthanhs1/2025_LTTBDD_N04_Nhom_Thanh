import 'package:flutter/material.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context).homeTitle),
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
                Text(
                  AppLocalizations.of(context).homeFunctions,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                      title: AppLocalizations.of(context).homeQuiz,
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
                      title: AppLocalizations.of(context).homeFlashcards,
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

                Text(
                  AppLocalizations.of(context).homeTodayStats,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _StatCard(
                      icon: Icons.timer_outlined,
                      title: AppLocalizations.of(context).statToday,
                      value: '${stats['studyTime']} phút',
                      color: Colors.grey.shade100,
                    ),
                    _StatCard(
                      icon: Icons.check_circle_outline,
                      title: AppLocalizations.of(context).statQuizzesDone,
                      value: '${stats['quizDone']}',
                      color: Colors.grey.shade100,
                    ),
                    _StatCard(
                      icon: Icons.speed_outlined,
                      title: AppLocalizations.of(context).statAverageScore,
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
                        Text(
                          AppLocalizations.of(context).quizStatsTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _KeyVal(
                                label: AppLocalizations.of(context).labelTopics,
                                value: '${stats['quizTopics']}',
                              ),
                            ),
                            Expanded(
                              child: _KeyVal(
                                label: AppLocalizations.of(
                                  context,
                                ).labelQuestions,
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
                                label: AppLocalizations.of(
                                  context,
                                ).labelSessions,
                                value: '${stats['quizDone']}',
                              ),
                            ),
                            Expanded(
                              child: _KeyVal(
                                label: AppLocalizations.of(
                                  context,
                                ).labelAccuracy,
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
                        Text(
                          AppLocalizations.of(context).flashStatsTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _KeyVal(
                                label: AppLocalizations.of(context).labelTopics,
                                value: '${stats['flashTopics']}',
                              ),
                            ),
                            Expanded(
                              child: _KeyVal(
                                label: AppLocalizations.of(
                                  context,
                                ).labelFlashTotalCards,
                                value: '${stats['flashTotal']}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _KeyVal(
                                label: AppLocalizations.of(
                                  context,
                                ).labelSessions,
                                value: '${stats['flashSessions']}',
                              ),
                            ),
                            Expanded(
                              child: _KeyVal(
                                label: AppLocalizations.of(
                                  context,
                                ).labelAccuracy,
                                value: '${stats['flashAccuracy']}%',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- HOẠT ĐỘNG THEO NGÀY (THÁNG NÀY) ---
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
    // Luôn tải mới nhưng dùng _cachedStats để hiển thị tạm thời khi chờ
    final results = await Future.wait([
      FirestoreService.instance.getQuizSummary(), // 0
      FirestoreService.instance.getFlashPracticeSummary(), // 1
      FirestoreService.instance.countQuizTopics(), // 2
      FirestoreService.instance.countAllQuestions(), // 3
      FirestoreService.instance.countFlashTopics(), // 4
      FirestoreService.instance.countAllFlashcards(), // 5
      FirestoreService.instance.getDailyActivityThisMonth(), // 6
    ]);

    final quizSummary = (results[0] as Map<String, dynamic>);
    final flashSummary = (results[1] as Map<String, dynamic>);
    final quizTopics = results[2] as int;
    final quizQuestions = results[3] as int;
    final flashTopics = results[4] as int;
    final flashTotal = results[5] as int;
    final dailyUsage = (results[6] as List).cast<int>();

    final quizDone = (quizSummary['done'] ?? 0) as int;
    final avgScore = (quizSummary['accuracy'] ?? 0) as int;
    final flashDone = (flashSummary['done'] ?? 0) as int;
    final flashAccuracy = (flashSummary['accuracy'] ?? 0) as int;

    _cachedStats = {
      'studyTime': (quizDone + flashDone) * 2, // ước lượng: 2 phút mỗi phiên
      'quizDone': quizDone,
      'avgScore': avgScore,
      'quizTopics': quizTopics,
      'quizQuestions': quizQuestions,
      'flashTopics': flashTopics,
      'flashTotal': flashTotal,
      'flashSessions': flashDone,
      'flashAccuracy': flashAccuracy,
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
          Text(
            AppLocalizations.of(context).dailyActivityThisMonth,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                maxY: maxValue == 0 ? 1 : maxValue + 1,
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
