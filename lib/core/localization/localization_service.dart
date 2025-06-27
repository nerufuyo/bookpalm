import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static LocalizationService? _instance;
  static LocalizationService get instance =>
      _instance ??= LocalizationService._();

  LocalizationService._();

  Map<String, dynamic> _localizedStrings = {};
  String _currentLanguage = 'en';

  Future<void> loadLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/translations/$languageCode.json',
      );
      _localizedStrings = json.decode(jsonString);
    } catch (e) {
      // Fallback to English if the language file doesn't exist
      final String jsonString = await rootBundle.loadString(
        'assets/translations/en.json',
      );
      _localizedStrings = json.decode(jsonString);
    }
  }

  String translate(String key) {
    final keys = key.split('.');
    dynamic value = _localizedStrings;

    for (final k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return key; // Return the key if translation is not found
      }
    }

    return value.toString();
  }

  String get currentLanguage => _currentLanguage;
}

// Extension for easier usage
extension LocalizationExtension on String {
  String get tr => LocalizationService.instance.translate(this);
}

// Generated constants for type safety
class AppStrings {
  // Book Detail
  static const String bookDetailLoading = 'bookDetail.loading';
  static const String bookDetailErrorTitle = 'bookDetail.errorTitle';
  static const String bookDetailErrorMessage = 'bookDetail.errorMessage';
  static const String bookDetailRetryButton = 'bookDetail.retryButton';
  static const String bookDetailNotFoundTitle = 'bookDetail.notFoundTitle';
  static const String bookDetailNotFoundMessage = 'bookDetail.notFoundMessage';
  static const String bookDetailAboutThisBook = 'bookDetail.aboutThisBook';
  static const String bookDetailAuthorDetails = 'bookDetail.authorDetails';
  static const String bookDetailAuthors = 'bookDetail.authors';
  static const String bookDetailAuthor = 'bookDetail.author';
  static const String bookDetailPublicationInformation =
      'bookDetail.publicationInformation';
  static const String bookDetailBookId = 'bookDetail.bookId';
  static const String bookDetailMediaType = 'bookDetail.mediaType';
  static const String bookDetailDownloads = 'bookDetail.downloads';
  static const String bookDetailDownloadsTimes = 'bookDetail.downloadsTimes';
  static const String bookDetailCopyrightStatus = 'bookDetail.copyrightStatus';
  static const String bookDetailCopyrighted = 'bookDetail.copyrighted';
  static const String bookDetailPublicDomain = 'bookDetail.publicDomain';
  static const String bookDetailLanguages = 'bookDetail.languages';
  static const String bookDetailKeyThemesTopics = 'bookDetail.keyThemesTopics';
  static const String bookDetailCulturalHeritage =
      'bookDetail.culturalHeritage';
  static const String bookDetailCulturalHeritageDescription =
      'bookDetail.culturalHeritageDescription';
  static const String bookDetailAvailableFormats =
      'bookDetail.availableFormats';
  static const String bookDetailFormatRecommendations =
      'bookDetail.formatRecommendations';
  static const String bookDetailFormatRecommendationText =
      'bookDetail.formatRecommendationText';
  static const String bookDetailReadingStatistics =
      'bookDetail.readingStatistics';
  static const String bookDetailTotalDownloads = 'bookDetail.totalDownloads';
  static const String bookDetailPopularityRank = 'bookDetail.popularityRank';
  static const String bookDetailReadingInformation =
      'bookDetail.readingInformation';
  static const String bookDetailBookmarkAdd = 'bookDetail.bookmarkAdd';
  static const String bookDetailBookmarkRemove = 'bookDetail.bookmarkRemove';
  static const String bookDetailBookmarkAdded = 'bookDetail.bookmarkAdded';
  static const String bookDetailBookmarkRemoved = 'bookDetail.bookmarkRemoved';

  // Genres
  static const String genresFiction = 'genres.fiction';
  static const String genresFantasy = 'genres.fantasy';
  static const String genresScienceFiction = 'genres.scienceFiction';
  static const String genresRomance = 'genres.romance';
  static const String genresMystery = 'genres.mystery';
  static const String genresAdventure = 'genres.adventure';
  static const String genresHistorical = 'genres.historical';
  static const String genresBiography = 'genres.biography';
  static const String genresPhilosophy = 'genres.philosophy';
  static const String genresPoetry = 'genres.poetry';
  static const String genresDefault = 'genres.default';

  // Author Eras
  static const String authorErasClassical = 'authorEras.classical';
  static const String authorErasNineteenth = 'authorEras.nineteenth';
  static const String authorErasEarlyTwentieth = 'authorEras.earlyTwentieth';
  static const String authorErasContemporary = 'authorEras.contemporary';

  // Popularity Ranks
  static const String popularityRanksExtremelyPopular =
      'popularityRanks.extremelyPopular';
  static const String popularityRanksVeryPopular =
      'popularityRanks.veryPopular';
  static const String popularityRanksPopular = 'popularityRanks.popular';
  static const String popularityRanksWellLiked = 'popularityRanks.wellLiked';
  static const String popularityRanksModeratelyPopular =
      'popularityRanks.moderatelyPopular';
  static const String popularityRanksGrowingAudience =
      'popularityRanks.growingAudience';

  // Reading Time Estimates
  static const String readingTimeEstimatesPoetry =
      'readingTimeEstimates.poetry';
  static const String readingTimeEstimatesShort = 'readingTimeEstimates.short';
  static const String readingTimeEstimatesNovel = 'readingTimeEstimates.novel';
  static const String readingTimeEstimatesTypical =
      'readingTimeEstimates.typical';
  static const String readingTimeEstimatesSuffix =
      'readingTimeEstimates.suffix';

  // Format Descriptions
  static const String formatDescriptionsTextHtml =
      'formatDescriptions.textHtml';
  static const String formatDescriptionsApplicationEpubZip =
      'formatDescriptions.applicationEpubZip';
  static const String formatDescriptionsTextPlain =
      'formatDescriptions.textPlain';
  static const String formatDescriptionsApplicationRdfXml =
      'formatDescriptions.applicationRdfXml';
  static const String formatDescriptionsImageJpeg =
      'formatDescriptions.imageJpeg';
  static const String formatDescriptionsApplicationXMobipocketEbook =
      'formatDescriptions.applicationXMobipocketEbook';
  static const String formatDescriptionsApplicationPdf =
      'formatDescriptions.applicationPdf';
  static const String formatDescriptionsDefault = 'formatDescriptions.default';
}
