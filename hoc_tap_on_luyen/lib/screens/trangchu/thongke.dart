import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/firestore_service.dart';

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
        title: const Text('Thống kê học tập'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.quiz_rounded), text: 'Quiz'),
            Tab(icon: Icon(Icons.style_rounded), text: 'Flashcard'),
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
              'Lỗi tải thống kê: ${snap.error}',
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
          const Text(
            'Thống kê tổng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatBox(
                label: 'Số chủ đề đã làm',
                value: data['done'].toString(),
                color: mainColor,
              ),
              _StatBox(
                label: 'Độ chính xác TB',
                value: '${data['accuracy']}%',
                color: mainColor,
              ),
              _StatBox(
                label: 'Tổng đúng',
                value: data['correct'].toString(),
                color: mainColor,
              ),
              _StatBox(
                label: 'Tổng sai',
                value: data['wrong'].toString(),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Tỉ lệ đúng / sai tổng thể',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                    color: Colors.green,
                    value: data['correct'].toDouble(),
                    title: '$correctPercent%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
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
            children: const [
              Icon(Icons.circle, color: Colors.green, size: 12),
              SizedBox(width: 4),
              Text('Đúng'),
              SizedBox(width: 12),
              Icon(Icons.circle, color: Colors.red, size: 12),
              SizedBox(width: 4),
              Text('Sai'),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Bảng thống kê theo chủ đề',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                    columns: const [
                      DataColumn(
                        label: Center(child: Text('Chủ đề')),
                        numeric: false,
                      ),
                      DataColumn(label: Center(child: Text('Tỉ lệ đúng'))),
                      DataColumn(label: Center(child: Text('Số bài làm'))),
                      DataColumn(label: Center(child: Text('Ngày'))),
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
