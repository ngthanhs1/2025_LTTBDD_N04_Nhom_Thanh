import 'package:flutter/material.dart';

class ChinhSachScreen extends StatelessWidget {
  const ChinhSachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chính sách bảo mật')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Cam kết bảo mật',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ứng dụng cam kết bảo mật thông tin người dùng. Dữ liệu cá nhân chỉ được dùng cho mục đích học tập và không chia sẻ cho bên thứ ba.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const _PolicySection(
            title: '1. Thu thập dữ liệu',
            items: [
              'Email và tên tài khoản để đăng nhập/đồng bộ dữ liệu.',
              'Chủ đề, câu hỏi và flashcard do bạn tạo để phục vụ việc học.',
              'Dữ liệu thống kê học tập (ẩn danh) nhằm cải thiện trải nghiệm.',
            ],
          ),
          const SizedBox(height: 8),
          const _PolicySection(
            title: '2. Lưu trữ & bảo vệ',
            items: [
              'Dữ liệu được lưu trữ an toàn trên hạ tầng đám mây.',
              'Chỉ bạn mới có quyền truy cập dữ liệu cá nhân của mình.',
              'Mọi truy cập đều yêu cầu xác thực hợp lệ.',
            ],
          ),
          const SizedBox(height: 8),
          const _PolicySection(
            title: '3. Quyền của bạn',
            items: [
              'Xem, chỉnh sửa hoặc xoá dữ liệu flashcard/quiz do bạn tạo.',
              'Yêu cầu hỗ trợ xuất dữ liệu học tập khi cần.',
              'Liên hệ để được giải đáp các vấn đề về quyền riêng tư.',
            ],
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Cập nhật lần cuối: 02/11/2025',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.title, required this.items});
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            for (final line in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(line)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
