import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/flashcard.dart';
import '../../services/firestore_service.dart';

class TestFlashcardScreen extends StatefulWidget {
  const TestFlashcardScreen({super.key, required this.topic});
  final ChuDe topic;

  @override
  State<TestFlashcardScreen> createState() => _TestFlashcardScreenState();
}

enum ReviewSide { frontToBack, backToFront }

class _TestFlashcardScreenState extends State<TestFlashcardScreen>
    with SingleTickerProviderStateMixin {
  final _answerCtr = TextEditingController();
  int _index = 0;
  int _correct = 0;
  int _total = 0;
  List<Flashcard> _sessionCards = const [];
  ReviewSide _mode = ReviewSide.frontToBack;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _shuffle = true;
  bool _started = false; // chọn mặt trước khi bắt đầu

  late final AnimationController _flipController; // 0..1 => 0..pi

  @override
  void dispose() {
    _answerCtr.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _next(int len) {
    if (_index >= len - 1) {
      _showSummaryAndMaybeSave();
      return;
    }
    setState(() {
      _index += 1;
      _answerCtr.clear();
      _showResult = false;
      _isCorrect = false;
      _flipController.value = 0; // trở về mặt trước cho thẻ tiếp theo
    });
  }

  void _check(Flashcard card) {
    final user = _answerCtr.text.trim();
    final expected = _mode == ReviewSide.frontToBack
        ? card.back.trim()
        : card.front.trim();
    final ok = user.toLowerCase() == expected.toLowerCase();
    setState(() {
      _isCorrect = ok;
      _showResult = true;
      _total += 1;
      if (ok) _correct += 1;
    });
    if (ok) {
      // lật thẻ như trang topic khi trả lời đúng
      _flipController.forward(from: 0);
    }
  }

  void _resetSession() {
    _answerCtr.clear();
    _index = 0;
    _correct = 0;
    _total = 0;
    _showResult = false;
    _isCorrect = false;
    _flipController.value = 0;
  }

  Future<void> _saveSession() async {
    final totalAnswered = _total;
    final wrong = (_total - _correct).clamp(0, _total);
    try {
      await FirestoreService.instance.addFlashPracticeSession(
        topicId: widget.topic.id,
        topicName: widget.topic.name,
        total: totalAnswered,
        correct: _correct,
        wrong: wrong,
      );
    } catch (_) {}
  }

  Future<void> _showSummaryAndMaybeSave() async {
    final wrong = (_total - _correct).clamp(0, _total);
    final accuracy = _total == 0 ? 0 : ((_correct / _total) * 100).round();
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kết quả ôn tập'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chủ đề: ${widget.topic.name}'),
            const SizedBox(height: 8),
            Text('Đã kiểm tra: $_total'),
            Text('Đúng: $_correct'),
            Text('Sai: $wrong'),
            Text('Độ chính xác: $accuracy%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'close'),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'restart'),
            child: const Text('Học lại'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, 'save'),
            icon: const Icon(Icons.save_alt_rounded),
            label: const Text('Lưu thống kê'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (action == 'save') {
      await _saveSession();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu kết quả vào Thống kê')),
      );
    }
    if (action == 'restart') {
      setState(() {
        _resetSession();
        // Giữ nguyên danh sách _sessionCards nhưng random lại nếu đang bật xáo trộn
        if (_shuffle) {
          _sessionCards = List<Flashcard>.from(_sessionCards)
            ..shuffle(Random());
        }
      });
    } else {
      // quay về màn chọn chế độ
      setState(() {
        _started = false;
      });
    }
  }

  Widget _buildModePicker(List<Flashcard> cards) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Chọn chế độ ôn tập',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              SegmentedButton<ReviewSide>(
                segments: const [
                  ButtonSegment(
                    value: ReviewSide.frontToBack,
                    label: Text('Mặt trước → sau'),
                  ),
                  ButtonSegment(
                    value: ReviewSide.backToFront,
                    label: Text('Mặt sau → trước'),
                  ),
                ],
                selected: <ReviewSide>{_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: FilterChip(
                  label: const Text('Xáo trộn thẻ'),
                  selected: _shuffle,
                  onSelected: (v) => setState(() => _shuffle = v),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _resetSession();
                    _sessionCards = List<Flashcard>.from(cards);
                    if (_shuffle) {
                      _sessionCards.shuffle(Random());
                    }
                    _started = true;
                  });
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Bắt đầu ôn tập'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlipCard({required String prompt, required String answer}) {
    return SizedBox(
      height: 180,
      child: AnimatedBuilder(
        animation: _flipController,
        builder: (context, child) {
          final angle = _flipController.value * pi; // 0..pi
          final isFront = angle < pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? _cardFace(title: 'Gợi ý', text: prompt)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _cardFace(
                      title: 'Đáp án',
                      text: answer,
                      color: Colors.green.shade50,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _cardFace({
    required String title,
    required String text,
    Color? color,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ôn tập - ${widget.topic.name}'),
        actions: [
          IconButton(
            tooltip: 'Chọn mặt ôn tập',
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () => setState(() => _started = false),
          ),
        ],
      ),
      body: StreamBuilder<List<Flashcard>>(
        stream: FirestoreService.instance.streamCards(widget.topic.id),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var cards = snap.data ?? [];
          if (cards.isEmpty) {
            return const Center(
              child: Text('Chưa có thẻ nào trong chủ đề này.'),
            );
          }
          if (!_started) {
            return _buildModePicker(cards);
          }
          // Dùng danh sách snapshot của phiên để cố định thứ tự
          if (_sessionCards.isEmpty) {
            _sessionCards = List<Flashcard>.from(cards);
            if (_shuffle) {
              _sessionCards.shuffle(Random());
            }
          }
          final cur = _sessionCards[_index.clamp(0, _sessionCards.length - 1)];
          final prompt = _mode == ReviewSide.frontToBack ? cur.front : cur.back;
          final answer = _mode == ReviewSide.frontToBack ? cur.back : cur.front;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header: tùy chọn nhỏ + stats
              Row(
                children: [
                  FilterChip(
                    label: const Text('Xáo trộn'),
                    selected: _shuffle,
                    onSelected: (v) => setState(() => _shuffle = v),
                  ),
                  const Spacer(),
                  Text('Đúng: $_correct/$_total'),
                ],
              ),

              const SizedBox(height: 12),

              // Thẻ lật: đúng thì lật để hiện đáp án
              _buildFlipCard(prompt: prompt, answer: answer),

              const SizedBox(height: 12),

              // Answer input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _answerCtr,
                        minLines: 1,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Nhập câu trả lời của bạn',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _check(cur),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Kiểm tra'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => _next(_sessionCards.length),
                            icon: const Icon(Icons.skip_next_rounded),
                            label: const Text('Bỏ qua'),
                          ),
                        ],
                      ),
                      if (_showResult) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              _isCorrect ? Icons.check_circle : Icons.cancel,
                              color: _isCorrect ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _isCorrect
                                    ? 'Chính xác!'
                                    : 'Chưa đúng. Đáp án: $answer',
                                style: TextStyle(
                                  color: _isCorrect ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _next(_sessionCards.length),
                              child: const Text('Tiếp theo'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Footer stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Thẻ: ${_index + 1}/${_sessionCards.length}'),
                  Text('Đúng: $_correct/$_total'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
