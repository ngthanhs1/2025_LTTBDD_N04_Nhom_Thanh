// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Study & Practice';

  @override
  String get tabHome => 'Home';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabFlashcard => 'Flashcards';

  @override
  String get tabStats => 'Statistics';

  @override
  String get tabAccount => 'Account';

  @override
  String get introTitle => 'Study & Practice Vocabulary';

  @override
  String get introStart => 'Start learning';

  @override
  String get titleAccount => 'Account';

  @override
  String get menuAbout => 'About';

  @override
  String get menuAccountInfo => 'Account info';

  @override
  String get menuChangePassword => 'Change password';

  @override
  String get menuLanguage => 'Language';

  @override
  String get menuPrivacy => 'Privacy policy';

  @override
  String get menuLogout => 'Logout';

  @override
  String versionLabel(Object version) {
    return 'Version: $version';
  }

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionOptions => 'Options';

  @override
  String get labelCreatedAt => 'Created at';

  @override
  String labelQuestionsCount(Object count) {
    return '$count questions';
  }

  @override
  String get errorLoading => 'Failed to load data';

  @override
  String get noTopics => 'No topics yet.\nTap + to create!';

  @override
  String get quizHomeTitle => 'Quiz - Topics';

  @override
  String get quizCreateNewTopic => 'Create new topic';

  @override
  String get quizTopicAdded => 'Topic added';

  @override
  String get quizPlay => 'Take quiz';

  @override
  String get quizTopicEmpty => 'This topic has no questions.';

  @override
  String get quizRenameTopicTitle => 'Rename topic';

  @override
  String get quizNewNameHint => 'New name';

  @override
  String get quizSaved => 'Saved';

  @override
  String get quizDeleted => 'Deleted';

  @override
  String get quizDeleteTopicTitle => 'Delete topic';

  @override
  String get quizDeleteTopicConfirm =>
      'Deleting the topic will remove all its questions. Are you sure?';

  @override
  String get flashTitleFolders => 'Folders';

  @override
  String get flashBackup => 'Backup';

  @override
  String get flashChecklist => 'Checklist';

  @override
  String get flashSearch => 'Search';

  @override
  String get flashNew => 'New';

  @override
  String get flashCreatedFolder => 'Folder created';

  @override
  String get flashNoFolders => 'No folders yet. Tap New to create';

  @override
  String get flashPractice => 'Practice';

  @override
  String get flashRenameFolderTitle => 'Rename folder';

  @override
  String get flashDeleteFolderTitle => 'Delete';

  @override
  String get flashDeleteFolderConfirm =>
      'Deleting this folder will remove all its cards. Are you sure?';

  @override
  String flashCardsCount(Object count) {
    return '$count cards';
  }

  @override
  String get flashSpeak => 'Speak';

  @override
  String get flashColor => 'Color';

  @override
  String get flashEdit => 'Edit';

  @override
  String get flashAuto => 'Auto';

  @override
  String get flashStop => 'Stop';

  @override
  String get flashPrev => 'Previous';

  @override
  String get flashNext => 'Next';

  @override
  String get colorPickerTitle => 'Pick card background';

  @override
  String get addWordTitleNew => 'Create card';

  @override
  String get addWordTitleEdit => 'Edit card';

  @override
  String get labelFront => 'Front';

  @override
  String get labelBack => 'Back';

  @override
  String get labelNote => 'Note';

  @override
  String get saveAndCreate => 'Save & create';

  @override
  String get validationFrontBackRequired => 'Please enter both Front and Back';

  @override
  String get savedContinueAdding => 'Saved – continue creating';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String topicDetailTitle(Object name) {
    return 'Topic: $name';
  }

  @override
  String get tooltipAddQuestion => 'Add question';

  @override
  String get errorLoadingQuestions => 'Failed to load questions.';

  @override
  String get topicEmpty => 'No questions in this topic yet.\nTap + to add!';

  @override
  String get addQuestionTitle => 'Add question';

  @override
  String get questionContent => 'Question content';

  @override
  String get enterQuestion => 'Enter question...';

  @override
  String get answersLabel => 'Answers';

  @override
  String answerHint(Object label) {
    return 'Answer $label';
  }

  @override
  String get enterAnswer => 'Enter answer';

  @override
  String get correctAnswer => 'Correct answer';

  @override
  String get adding => 'Saving...';

  @override
  String get addedQuestion => 'Question added!';

  @override
  String get addTopicAndQuestionsTitle => 'Create topic & questions';

  @override
  String get topicInfo => 'Topic info';

  @override
  String get topicNameLabel => 'Topic name';

  @override
  String get topicNameHint => 'e.g. Basic Dart programming';

  @override
  String get addedQuestionsTitle => 'Added questions';

  @override
  String get composeQuestionTitle => 'Compose question';

  @override
  String get savingEllipsis => 'Saving...';

  @override
  String get saveTopic => 'Save topic';

  @override
  String get savedTopicAndQuestions => 'Topic and questions saved!';

  @override
  String get enterTopicAndOneQuestion =>
      'Enter topic name and at least one question.';

  @override
  String errorSavingWithMessage(Object message) {
    return 'Error saving: $message';
  }

  @override
  String quizResultTitle(Object topic) {
    return 'Result - $topic';
  }

  @override
  String quizResultSummary(Object correct, Object total) {
    return 'You answered $correct / $total correctly';
  }

  @override
  String quizResultAccuracy(Object percent) {
    return 'Accuracy: $percent%';
  }

  @override
  String get quizBackHome => 'Back to home';

  @override
  String quizQuestionProgress(Object current, Object total) {
    return 'Question $current/$total';
  }

  @override
  String get flashEmptyCards => 'No cards to display.\nPlease add new cards.';

  @override
  String get flashNewFolderTitle => 'New folder';

  @override
  String get flashFolderNameHint => 'Folder name';

  @override
  String get flashFolderNameRequired => 'Enter folder name';
}
