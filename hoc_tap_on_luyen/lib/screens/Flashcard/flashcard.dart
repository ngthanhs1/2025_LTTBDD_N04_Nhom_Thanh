import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/flashcard.dart';
import '../../services/firestore_service.dart';
import 'add_flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;
  int _index = 0;
  List<Flashcard> _cards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await FirestoreService.instance.getFlashcards();
    setState(() {
      _cards = cards;
      _loading = false;
    });
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  void _nextCard() {
    if (_index < _cards.length - 1) {
      setState(() {
        _index++;
        _isFront = true;
        _controller.reset();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🎉 Bạn đã xem hết các thẻ!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.indigo)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ôn tập Flashcard"),
        backgroundColor: const Color.fromARGB(255, 149, 163, 243),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Thêm thẻ mới",
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final added = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFlashcardScreen()),
              );
              if (added == true) _loadCards();
            },
          ),
        ],
      ),
      body: _cards.isEmpty
          ? const Center(
              child: Text(
                "Chưa có thẻ nào.\nNhấn + để thêm thẻ học mới!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thẻ ${_index + 1}/${_cards.length}",
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final angle = _controller.value * pi;
                      final transform = Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle);

                      final isFront = _controller.value < 0.5;
                      final card = _cards[_index];

                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: Container(
                          width: 320,
                          height: 220,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isFront
                                  ? [
                                      Colors.indigo.shade100,
                                      Colors.indigo.shade200,
                                    ]
                                  : [Colors.white, Colors.indigo.shade50],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(3, 4),
                              ),
                            ],
                          ),
                          child: isFront
                              ? Text(
                                  card.front,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(pi),
                                  child: Text(
                                    card.back,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _cards.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                label: const Text("Thẻ tiếp theo"),
                onPressed: _nextCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
