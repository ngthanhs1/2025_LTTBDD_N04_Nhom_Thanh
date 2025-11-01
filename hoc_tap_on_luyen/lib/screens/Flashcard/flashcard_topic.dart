import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/flashcard.dart';
import '../../services/firestore_service.dart';
import 'add_tu.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashcardTopicScreen extends StatefulWidget {
  const FlashcardTopicScreen({super.key, required this.topic});
  final ChuDe topic;

  @override
  State<FlashcardTopicScreen> createState() => _FlashcardTopicScreenState();
}

class _FlashcardTopicScreenState extends State<FlashcardTopicScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late FlutterTts _tts;

  bool _front = true;
  int _index = 0;
  bool _autoMode = false;
  Timer? _timer;
  Color _cardColor = const Color(0xFFB0B7BF);

  final List<Color> _colorOptions = [
    const Color(0xFFB0B7BF),
    Colors.teal,
    Colors.amber,
    Colors.deepOrangeAccent,
    Colors.lightGreen,
    Colors.indigo,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    //Khởi tạo TTS
    _tts = FlutterTts();
    _tts.setLanguage("en-US"); // bạn có thể đổi thành "vi-VN"
    _tts.setSpeechRate(0.4);
    _tts.setPitch(1.0);
  }

  void _flip() {
    if (_front) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _front = !_front;
    setState(() {});
  }

  void _next(int len) {
    if (_index < len - 1) setState(() => _index++);
  }

  void _prev() {
    if (_index > 0) setState(() => _index--);
  }

  /// 🔁 Bật / tắt chế độ tự động
  void _toggleAuto(List<Flashcard> cards) {
    if (_autoMode) {
      _timer?.cancel();
      setState(() => _autoMode = false);
      return;
    }

    _autoMode = true;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!mounted) return;
      _flip();

      // Nếu đang ở mặt trước thì đọc nội dung
      final textToSpeak = _front ? cards[_index].front : cards[_index].back;
      await _tts.speak(textToSpeak);

      Future.delayed(const Duration(seconds: 2), () {
        if (_front && _index < cards.length - 1) {
          setState(() => _index++);
        } else if (_front && _index == cards.length - 1) {
          setState(() => _index = 0);
        }
      });
    });
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _tts.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.topic.name;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C4CE3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTuScreen(topic: widget.topic),
                ),
              );
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Flashcard>>(
        stream: FirestoreService.instance.streamCards(widget.topic.id),
        builder: (context, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cards = s.data!;
          if (cards.isEmpty) return _emptyView(context);

          final card = cards[_index];
          return Column(
            children: [
              const SizedBox(height: 12),

              // --- Thẻ lật ---
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _flip,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final angle = _controller.value * pi;
                        final isFront = angle < pi / 2;
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.86,
                            height: MediaQuery.of(context).size.width * 0.58,
                            decoration: BoxDecoration(
                              color: _cardColor,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: isFront
                                  ? Matrix4.identity()
                                  : Matrix4.rotationY(pi),
                              child: Text(
                                isFront ? card.front : card.back,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  color: isFront
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // --- 4 nút bên dưới ---
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 🎤 Nút phát âm
                    _BottomControl(
                      icon: Icons.volume_up_rounded,
                      label: 'Phát âm',
                      onTap: () async {
                        final textToSpeak = _front ? card.front : card.back;
                        await _tts.speak(textToSpeak);
                      },
                    ),
                    // 🎨 Đổi màu thẻ
                    _BottomControl(
                      icon: Icons.color_lens_rounded,
                      label: 'Màu',
                      onTap: () async {
                        final color = await showDialog<Color>(
                          context: context,
                          builder: (_) =>
                              _ColorPickerDialog(colors: _colorOptions),
                        );
                        if (color != null) setState(() => _cardColor = color);
                      },
                    ),
                    // ✏️ Chỉnh sửa thẻ
                    _BottomControl(
                      icon: Icons.edit_rounded,
                      label: 'Chỉnh sửa',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddTuScreen(topic: widget.topic, card: card),
                          ),
                        );
                      },
                    ),
                    // 🔁 Tự động đọc và lật
                    _BottomControl(
                      icon: Icons.autorenew_rounded,
                      label: _autoMode ? 'Dừng' : 'Tự động',
                      onTap: () => _toggleAuto(cards),
                    ),
                  ],
                ),
              ),

              // --- Điều hướng trước/sau ---
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _index == 0 ? null : _prev,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        label: const Text('Trước'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _index == cards.length - 1
                            ? null
                            : () => _next(cards.length),
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        label: const Text('Sau'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CE3),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.layers_outlined, color: Colors.grey, size: 48),
        const SizedBox(height: 10),
        Text(
          'Không có thẻ nào để hiển thị.\nVui lòng thêm thẻ mới.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

// --- Widget chọn màu ---
class _ColorPickerDialog extends StatelessWidget {
  final List<Color> colors;
  const _ColorPickerDialog({required this.colors});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chọn màu nền thẻ'),
      content: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: colors
            .map(
              (c) => GestureDetector(
                onTap: () => Navigator.pop(context, c),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// --- Nút điều khiển dưới cùng ---
class _BottomControl extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _BottomControl({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
