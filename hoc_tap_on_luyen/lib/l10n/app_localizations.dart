import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Study & Practice'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get tabQuiz;

  /// No description provided for @tabFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get tabFlashcard;

  /// No description provided for @tabStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get tabStats;

  /// No description provided for @tabAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get tabAccount;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'Study & Practice Vocabulary'**
  String get introTitle;

  /// No description provided for @introStart.
  ///
  /// In en, this message translates to:
  /// **'Start learning'**
  String get introStart;

  /// No description provided for @titleAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get titleAccount;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// No description provided for @menuAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account info'**
  String get menuAccountInfo;

  /// No description provided for @menuChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get menuChangePassword;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @menuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get menuPrivacy;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String versionLabel(Object version);

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @actionOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get actionOptions;

  /// No description provided for @labelCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get labelCreatedAt;

  /// No description provided for @labelQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String labelQuestionsCount(Object count);

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get errorLoading;

  /// No description provided for @noTopics.
  ///
  /// In en, this message translates to:
  /// **'No topics yet.\nTap + to create!'**
  String get noTopics;

  /// No description provided for @quizHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz - Topics'**
  String get quizHomeTitle;

  /// No description provided for @quizCreateNewTopic.
  ///
  /// In en, this message translates to:
  /// **'Create new topic'**
  String get quizCreateNewTopic;

  /// No description provided for @quizTopicAdded.
  ///
  /// In en, this message translates to:
  /// **'Topic added'**
  String get quizTopicAdded;

  /// No description provided for @quizPlay.
  ///
  /// In en, this message translates to:
  /// **'Take quiz'**
  String get quizPlay;

  /// No description provided for @quizTopicEmpty.
  ///
  /// In en, this message translates to:
  /// **'This topic has no questions.'**
  String get quizTopicEmpty;

  /// No description provided for @quizRenameTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename topic'**
  String get quizRenameTopicTitle;

  /// No description provided for @quizNewNameHint.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get quizNewNameHint;

  /// No description provided for @quizSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get quizSaved;

  /// No description provided for @quizDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get quizDeleted;

  /// No description provided for @quizDeleteTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete topic'**
  String get quizDeleteTopicTitle;

  /// No description provided for @quizDeleteTopicConfirm.
  ///
  /// In en, this message translates to:
  /// **'Deleting the topic will remove all its questions. Are you sure?'**
  String get quizDeleteTopicConfirm;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeFunctions.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get homeFunctions;

  /// No description provided for @homeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get homeQuiz;

  /// No description provided for @homeFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get homeFlashcards;

  /// No description provided for @homeTodayStats.
  ///
  /// In en, this message translates to:
  /// **'Today’s stats'**
  String get homeTodayStats;

  /// No description provided for @statToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statToday;

  /// No description provided for @statQuizzesDone.
  ///
  /// In en, this message translates to:
  /// **'Quizzes done'**
  String get statQuizzesDone;

  /// No description provided for @statAverageScore.
  ///
  /// In en, this message translates to:
  /// **'Average score'**
  String get statAverageScore;

  /// No description provided for @quizStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz overview'**
  String get quizStatsTitle;

  /// No description provided for @labelTopics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get labelTopics;

  /// No description provided for @labelQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get labelQuestions;

  /// No description provided for @labelSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get labelSessions;

  /// No description provided for @labelAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get labelAccuracy;

  /// No description provided for @flashStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards overview'**
  String get flashStatsTitle;

  /// No description provided for @labelFlashTotalCards.
  ///
  /// In en, this message translates to:
  /// **'Total cards'**
  String get labelFlashTotalCards;

  /// No description provided for @dailyActivityThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Daily activity (this month)'**
  String get dailyActivityThisMonth;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Study statistics'**
  String get statsTitle;

  /// No description provided for @statsOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall statistics'**
  String get statsOverall;

  /// No description provided for @correctWrongRatioTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall correct / wrong ratio'**
  String get correctWrongRatioTitle;

  /// No description provided for @correctLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correctLabel;

  /// No description provided for @wrongLabel.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrongLabel;

  /// No description provided for @perTopicTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Per-topic summary'**
  String get perTopicTableTitle;

  /// No description provided for @columnTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get columnTopic;

  /// No description provided for @columnAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get columnAccuracy;

  /// No description provided for @columnDone.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get columnDone;

  /// No description provided for @columnDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get columnDate;

  /// No description provided for @errorLoadingStatsWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load statistics: {error}'**
  String errorLoadingStatsWithMessage(Object error);

  /// No description provided for @boxTopicsDone.
  ///
  /// In en, this message translates to:
  /// **'Topics done'**
  String get boxTopicsDone;

  /// No description provided for @boxAvgAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Avg. accuracy'**
  String get boxAvgAccuracy;

  /// No description provided for @boxTotalCorrect.
  ///
  /// In en, this message translates to:
  /// **'Total correct'**
  String get boxTotalCorrect;

  /// No description provided for @boxTotalWrong.
  ///
  /// In en, this message translates to:
  /// **'Total wrong'**
  String get boxTotalWrong;

  /// No description provided for @flashTitleFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get flashTitleFolders;

  /// No description provided for @flashBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get flashBackup;

  /// No description provided for @flashChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get flashChecklist;

  /// No description provided for @flashSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get flashSearch;

  /// No description provided for @flashNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get flashNew;

  /// No description provided for @flashCreatedFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder created'**
  String get flashCreatedFolder;

  /// No description provided for @flashNoFolders.
  ///
  /// In en, this message translates to:
  /// **'No folders yet. Tap New to create'**
  String get flashNoFolders;

  /// No description provided for @flashPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get flashPractice;

  /// No description provided for @flashRenameFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get flashRenameFolderTitle;

  /// No description provided for @flashDeleteFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get flashDeleteFolderTitle;

  /// No description provided for @flashDeleteFolderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Deleting this folder will remove all its cards. Are you sure?'**
  String get flashDeleteFolderConfirm;

  /// No description provided for @flashCardsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String flashCardsCount(Object count);

  /// No description provided for @flashSpeak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get flashSpeak;

  /// No description provided for @flashColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get flashColor;

  /// No description provided for @flashEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get flashEdit;

  /// No description provided for @flashAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get flashAuto;

  /// No description provided for @flashStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get flashStop;

  /// No description provided for @flashPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get flashPrev;

  /// No description provided for @flashNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get flashNext;

  /// No description provided for @colorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick card background'**
  String get colorPickerTitle;

  /// No description provided for @addWordTitleNew.
  ///
  /// In en, this message translates to:
  /// **'Create card'**
  String get addWordTitleNew;

  /// No description provided for @addWordTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit card'**
  String get addWordTitleEdit;

  /// No description provided for @labelFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get labelFront;

  /// No description provided for @labelBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get labelBack;

  /// No description provided for @labelNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get labelNote;

  /// No description provided for @saveAndCreate.
  ///
  /// In en, this message translates to:
  /// **'Save & create'**
  String get saveAndCreate;

  /// No description provided for @validationFrontBackRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter both Front and Back'**
  String get validationFrontBackRequired;

  /// No description provided for @savedContinueAdding.
  ///
  /// In en, this message translates to:
  /// **'Saved – continue creating'**
  String get savedContinueAdding;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @topicDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Topic: {name}'**
  String topicDetailTitle(Object name);

  /// No description provided for @tooltipAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get tooltipAddQuestion;

  /// No description provided for @errorLoadingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions.'**
  String get errorLoadingQuestions;

  /// No description provided for @topicEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions in this topic yet.\nTap + to add!'**
  String get topicEmpty;

  /// No description provided for @addQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get addQuestionTitle;

  /// No description provided for @questionContent.
  ///
  /// In en, this message translates to:
  /// **'Question content'**
  String get questionContent;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter question...'**
  String get enterQuestion;

  /// No description provided for @answersLabel.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answersLabel;

  /// No description provided for @answerHint.
  ///
  /// In en, this message translates to:
  /// **'Answer {label}'**
  String answerHint(Object label);

  /// No description provided for @enterAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter answer'**
  String get enterAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswer;

  /// No description provided for @adding.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get adding;

  /// No description provided for @addedQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question added!'**
  String get addedQuestion;

  /// No description provided for @addTopicAndQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Create topic & questions'**
  String get addTopicAndQuestionsTitle;

  /// No description provided for @topicInfo.
  ///
  /// In en, this message translates to:
  /// **'Topic info'**
  String get topicInfo;

  /// No description provided for @topicNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic name'**
  String get topicNameLabel;

  /// No description provided for @topicNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Basic Dart programming'**
  String get topicNameHint;

  /// No description provided for @addedQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Added questions'**
  String get addedQuestionsTitle;

  /// No description provided for @composeQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Compose question'**
  String get composeQuestionTitle;

  /// No description provided for @savingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingEllipsis;

  /// No description provided for @saveTopic.
  ///
  /// In en, this message translates to:
  /// **'Save topic'**
  String get saveTopic;

  /// No description provided for @savedTopicAndQuestions.
  ///
  /// In en, this message translates to:
  /// **'Topic and questions saved!'**
  String get savedTopicAndQuestions;

  /// No description provided for @enterTopicAndOneQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter topic name and at least one question.'**
  String get enterTopicAndOneQuestion;

  /// No description provided for @errorSavingWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {message}'**
  String errorSavingWithMessage(Object message);

  /// No description provided for @quizResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result - {topic}'**
  String quizResultTitle(Object topic);

  /// No description provided for @quizResultSummary.
  ///
  /// In en, this message translates to:
  /// **'You answered {correct} / {total} correctly'**
  String quizResultSummary(Object correct, Object total);

  /// No description provided for @quizResultAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy: {percent}%'**
  String quizResultAccuracy(Object percent);

  /// No description provided for @quizBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get quizBackHome;

  /// No description provided for @quizQuestionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current}/{total}'**
  String quizQuestionProgress(Object current, Object total);

  /// No description provided for @flashEmptyCards.
  ///
  /// In en, this message translates to:
  /// **'No cards to display.\nPlease add new cards.'**
  String get flashEmptyCards;

  /// No description provided for @flashNewFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get flashNewFolderTitle;

  /// No description provided for @flashFolderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get flashFolderNameHint;

  /// No description provided for @flashFolderNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name'**
  String get flashFolderNameRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
