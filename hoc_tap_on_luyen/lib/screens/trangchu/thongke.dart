import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/firestore_service.dart';

class thongkeScreen extends StatefulWidget {
  const thongkeScreen({super.key});

  @override
  State<thongkeScreen> createState() => _thongkeScreenState();
}

class _thongkeScreenState extends State<thongkeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  late Map<String, dynamic> quizStats;
  late Map<String, dynamic> flashStats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStats();
  }

  Future<void> _loadStats() async {
    // 🔹 Quiz: lấy thống kê thật từ Firestore
    try {
      quizStats = await FirestoreService.instance.getQuizSummary();
    } catch (_) {
      quizStats = {
        'done': 0,
        'accuracy': 0,
        'correct': 0,
        'wrong': 0,
        'topics': const <Map<String, dynamic>>[],
      };
    }

    // 🔹 Flashcard: lấy thống kê thật từ Firestore
    try {
      flashStats = await FirestoreService.instance.getFlashPracticeSummary();
    } catch (_) {
      flashStats = {
        'done': 0,
        'accuracy': 0,
        'correct': 0,
        'wrong': 0,
        'topics': const <Map<String, dynamic>>[],
      };
    }

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isLoading = false);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildStatisticsView(quizStats, Colors.indigo),
                _buildStatisticsView(flashStats, Colors.teal),
              ],
            ),
    );
  }

  Widget _buildStatisticsView(Map<String, dynamic> data, Color mainColor) {
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
                    title: '${correctPercent}%',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              columns: const [
                DataColumn(label: Text('Chủ đề')),
                DataColumn(label: Text('Tỉ lệ đúng')),
                DataColumn(label: Text('Số bài làm')),
                DataColumn(label: Text('Ngày')),
              ],
              rows: (data['topics'] as List).map((t) {
                return DataRow(
                  cells: [
                    DataCell(Text(t['name'])),
                    DataCell(Text('${t['accuracy']}%')),
                    DataCell(Text('${t['done']}')),
                    DataCell(Text(t['date'])),
                    DataCell(
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              minimumSize: const Size(50, 30),
                            ),
                            child: const Text(
                              'Ôn tập',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 6),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(50, 30),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text(
                              'Làm bài',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
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
          color: color.withOpacity(0.1),
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
