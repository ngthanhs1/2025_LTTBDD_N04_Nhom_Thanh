// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Học tập & Ôn luyện';

  @override
  String get tabHome => 'Trang chủ';

  @override
  String get tabQuiz => 'Câu đố';

  @override
  String get tabFlashcard => 'Thẻ ghi nhớ';

  @override
  String get tabStats => 'Thống kê';

  @override
  String get tabAccount => 'Tài khoản';

  @override
  String get introTitle => 'Học tập & Ôn luyện từ vựng';

  @override
  String get introStart => 'Bắt đầu học';

  @override
  String get titleAccount => 'Tài khoản';

  @override
  String get menuAbout => 'Giới thiệu cá nhân';

  @override
  String get menuAccountInfo => 'Thông tin tài khoản';

  @override
  String get menuChangePassword => 'Đổi mật khẩu';

  @override
  String get menuLanguage => 'Ngôn ngữ';

  @override
  String get menuPrivacy => 'Chính sách bảo mật';

  @override
  String get menuLogout => 'Đăng xuất';

  @override
  String versionLabel(Object version) {
    return 'Phiên bản: $version';
  }

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageChanged => 'Đã đổi ngôn ngữ';

  @override
  String get actionSave => 'Lưu';

  @override
  String get actionCancel => 'Hủy';

  @override
  String get actionDelete => 'Xóa';

  @override
  String get actionRename => 'Đổi tên';

  @override
  String get actionOptions => 'Tùy chọn';

  @override
  String get labelCreatedAt => 'Ngày tạo';

  @override
  String labelQuestionsCount(Object count) {
    return '$count câu hỏi';
  }

  @override
  String get errorLoading => 'Lỗi tải dữ liệu';

  @override
  String get noTopics => 'Chưa có chủ đề nào.\nNhấn nút + để bắt đầu tạo!';

  @override
  String get quizHomeTitle => 'Quiz - Chủ đề';

  @override
  String get quizCreateNewTopic => 'Tạo chủ đề mới';

  @override
  String get quizTopicAdded => 'Đã thêm chủ đề mới!';

  @override
  String get quizPlay => 'Làm bài';

  @override
  String get quizTopicEmpty => 'Chủ đề chưa có câu hỏi nào.';

  @override
  String get quizRenameTopicTitle => 'Đổi tên chủ đề';

  @override
  String get quizNewNameHint => 'Tên mới';

  @override
  String get quizSaved => 'Đã lưu';

  @override
  String get quizDeleted => 'Đã xóa';

  @override
  String get quizDeleteTopicTitle => 'Xóa chủ đề';

  @override
  String get quizDeleteTopicConfirm =>
      'Xóa chủ đề sẽ xóa toàn bộ câu hỏi bên trong. Bạn có chắc?';

  @override
  String get flashTitleFolders => 'Thư mục';

  @override
  String get flashBackup => 'Sao lưu';

  @override
  String get flashChecklist => 'Checklist';

  @override
  String get flashSearch => 'Tìm kiếm';

  @override
  String get flashNew => 'Mới';

  @override
  String get flashCreatedFolder => 'Đã tạo thư mục';

  @override
  String get flashNoFolders => 'Chưa có thư mục nào. Nhấn Mới để tạo';

  @override
  String get flashPractice => 'Ôn tập';

  @override
  String get flashRenameFolderTitle => 'Đổi tên thư mục';

  @override
  String get flashDeleteFolderTitle => 'Xóa';

  @override
  String get flashDeleteFolderConfirm =>
      'Xóa thư mục sẽ xóa toàn bộ thẻ bên trong. Bạn có chắc?';

  @override
  String flashCardsCount(Object count) {
    return '$count thẻ';
  }

  @override
  String get flashSpeak => 'Phát âm';

  @override
  String get flashColor => 'Màu';

  @override
  String get flashEdit => 'Chỉnh sửa';

  @override
  String get flashAuto => 'Tự động';

  @override
  String get flashStop => 'Dừng';

  @override
  String get flashPrev => 'Trước';

  @override
  String get flashNext => 'Sau';

  @override
  String get colorPickerTitle => 'Chọn màu nền thẻ';

  @override
  String get addWordTitleNew => 'Tạo thẻ mới';

  @override
  String get addWordTitleEdit => 'Chỉnh sửa thẻ';

  @override
  String get labelFront => 'Mặt trước';

  @override
  String get labelBack => 'Mặt sau';

  @override
  String get labelNote => 'Ghi chú';

  @override
  String get saveAndCreate => 'Lưu & tạo';

  @override
  String get validationFrontBackRequired =>
      'Vui lòng nhập Mặt trước và Mặt sau';

  @override
  String get savedContinueAdding => 'Đã lưu – tiếp tục tạo';

  @override
  String get changePasswordTitle => 'Đổi mật khẩu';

  @override
  String get oldPassword => 'Mật khẩu cũ';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get passwordChanged => 'Đổi mật khẩu thành công';

  @override
  String get passwordMismatch => 'Mật khẩu không trùng khớp';

  @override
  String topicDetailTitle(Object name) {
    return 'Chủ đề: $name';
  }

  @override
  String get tooltipAddQuestion => 'Thêm câu hỏi';

  @override
  String get errorLoadingQuestions => 'Lỗi tải dữ liệu câu hỏi.';

  @override
  String get topicEmpty =>
      'Chưa có câu hỏi nào trong chủ đề này.\nNhấn + để thêm mới!';

  @override
  String get addQuestionTitle => 'Thêm câu hỏi';

  @override
  String get questionContent => 'Nội dung câu hỏi';

  @override
  String get enterQuestion => 'Nhập câu hỏi...';

  @override
  String get answersLabel => 'Các đáp án';

  @override
  String answerHint(Object label) {
    return 'Đáp án $label';
  }

  @override
  String get enterAnswer => 'Nhập đáp án';

  @override
  String get correctAnswer => 'Đáp án đúng';

  @override
  String get adding => 'Đang lưu...';

  @override
  String get addedQuestion => 'Đã thêm câu hỏi!';

  @override
  String get addTopicAndQuestionsTitle => 'Tạo chủ đề & câu hỏi';

  @override
  String get topicInfo => 'Thông tin chủ đề';

  @override
  String get topicNameLabel => 'Tên chủ đề';

  @override
  String get topicNameHint => 'VD: Lập trình Dart cơ bản';

  @override
  String get addedQuestionsTitle => 'Câu hỏi đã thêm';

  @override
  String get composeQuestionTitle => 'Soạn câu hỏi';

  @override
  String get savingEllipsis => 'Đang lưu...';

  @override
  String get saveTopic => 'Lưu chủ đề';

  @override
  String get savedTopicAndQuestions => 'Đã lưu chủ đề và câu hỏi!';

  @override
  String get enterTopicAndOneQuestion =>
      'Nhập tên chủ đề và ít nhất 1 câu hỏi.';

  @override
  String errorSavingWithMessage(Object message) {
    return 'Lỗi khi lưu: $message';
  }

  @override
  String quizResultTitle(Object topic) {
    return 'Kết quả - $topic';
  }

  @override
  String quizResultSummary(Object correct, Object total) {
    return 'Bạn đã trả lời đúng $correct / $total câu';
  }

  @override
  String quizResultAccuracy(Object percent) {
    return 'Tỷ lệ chính xác: $percent%';
  }

  @override
  String get quizBackHome => 'Về trang chủ';

  @override
  String quizQuestionProgress(Object current, Object total) {
    return 'Câu $current/$total';
  }

  @override
  String get flashEmptyCards =>
      'Không có thẻ nào để hiển thị.\nVui lòng thêm thẻ mới.';

  @override
  String get flashNewFolderTitle => 'Thư mục mới';

  @override
  String get flashFolderNameHint => 'Tên thư mục';

  @override
  String get flashFolderNameRequired => 'Nhập tên thư mục';
}
