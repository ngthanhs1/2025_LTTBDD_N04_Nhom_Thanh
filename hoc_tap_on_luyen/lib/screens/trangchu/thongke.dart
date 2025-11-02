import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/firestore_service.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';

class ThongKeScreen extends StatefulWidget {
  const ThongKeScreen({super.key});

  @override
  State<ThongKeScreen> createState() => _ThongKeScreenState();
}

class _ThongKeScreenState extends State<ThongKeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).statsTitle),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 226, 229, 240),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: const Icon(Icons.quiz_rounded),
              text: AppLocalizations.of(context).tabQuiz,
            ),
            Tab(
              icon: const Icon(Icons.style_rounded),
              text: AppLocalizations.of(context).tabFlashcard,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatisticsStream(isQuiz: true, mainColor: Colors.indigo),
          _buildStatisticsStream(isQuiz: false, mainColor: Colors.teal),
        ],
      ),
    );
  }

  Widget _buildStatisticsStream({
    required bool isQuiz,
    required Color mainColor,
  }) {
    final stream = isQuiz
        ? FirestoreService.instance.streamQuizSummary()
        : FirestoreService.instance.streamFlashPracticeSummary();
    return StreamBuilder<Map<String, dynamic>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(
                context,
              ).errorLoadingStatsWithMessage('${snap.error}'),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (!snap.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }
        final data = snap.data!;
        return _buildStatisticsView(data, mainColor, isQuiz: isQuiz);
      },
    );
  }

  Widget _buildStatisticsView(
    Map<String, dynamic> data,
    Color mainColor, {
    required bool isQuiz,
  }) {
    final total = data['correct'] + data['wrong'];
    final correctPercent = total == 0
        ? 0
        : (data['correct'] / total * 100).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).statsOverall,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatBox(
                label: AppLocalizations.of(context).boxTopicsDone,
                value: data['done'].toString(),
                color: mainColor,
              ),
              _StatBox(
                label: AppLocalizations.of(context).boxAvgAccuracy,
                value: '${data['accuracy']}%',
                color: mainColor,
              ),
              _StatBox(
                label: AppLocalizations.of(context).boxTotalCorrect,
                value: data['correct'].toString(),
                color: mainColor,
              ),
              _StatBox(
                label: AppLocalizations.of(context).boxTotalWrong,
                value: data['wrong'].toString(),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            AppLocalizations.of(context).correctWrongRatioTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    color: Color.fromARGB(255, 152, 240, 152),
                    value: data['correct'].toDouble(),
                    title: '$correctPercent%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    color: Color.fromARGB(255, 236, 176, 173),
                    value: data['wrong'].toDouble(),
                    title: '',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.circle,
                color: Color.fromARGB(255, 152, 240, 152),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(AppLocalizations.of(context).correctLabel),
              const SizedBox(width: 12),
              const Icon(
                Icons.circle,
                color: Color.fromARGB(255, 236, 176, 173),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(AppLocalizations.of(context).wrongLabel),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            AppLocalizations.of(context).perTopicTableTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // --- BẢNG THỐNG KÊ ---
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    dataTextStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                    columnSpacing: 28,
                    horizontalMargin: 8,
                    columns: [
                      DataColumn(
                        label: Center(
                          child: Text(AppLocalizations.of(context).columnTopic),
                        ),
                        numeric: false,
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            AppLocalizations.of(context).columnAccuracy,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(AppLocalizations.of(context).columnDone),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(AppLocalizations.of(context).columnDate),
                        ),
                      ),
                    ],
                    rows: (data['topics'] as List).map((t) {
                      final String name = (t['name'] ?? '').toString();
                      final int accuracy = (t['accuracy'] ?? 0) as int;
                      final int done = (t['done'] ?? 0) as int;
                      final String date = (t['date'] ?? '').toString();
                      return DataRow(
                        cells: [
                          DataCell(Center(child: Text(name))),
                          DataCell(Center(child: Text('$accuracy%'))),
                          DataCell(Center(child: Text(done.toString()))),
                          DataCell(Center(child: Text(date))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
