import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'en_translations.dart';
import 'zh_translations.dart';
import 'ja_translations.dart';

part 'en_translations.dart';
part 'zh_translations.dart';
part 'ja_translations.dart';

class LocalizationService {
  static const LocalizationsDelegate<LocalizationService> delegate = _LocalizationDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('zh', 'CN'),
    Locale('ja', 'JP'),
  ];

  static final Map<String, Map<String, String>> _all = {
    'en': enTranslations,
    'zh': zhTranslations,
    'ja': jaTranslations,
  };

  final Locale locale;
  LocalizationService(this.locale);

  static Future<void> ensureInitialized() async {}

  String tr(String key, {List<String>? args}) {
    final map = _all[locale.languageCode] ?? _all['en']!;
    var text = map[key] ?? _all['en']?[key] ?? key;
    if (args != null) {
      for (var i = 0; i < args.length; i++) {
        text = text.replaceAll('{$i}', args[i]);
      }
    }
    return text;
  }

  static LocalizationService of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService)!;
  }
}

class _LocalizationDelegate extends LocalizationsDelegate<LocalizationService> {
  const _LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => LocalizationService.supportedLocales.contains(locale);

  @override
  Future<LocalizationService> load(Locale locale) async => LocalizationService(locale);

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}

/// Extension for easy access
extension LocaleX on BuildContext {
  String tr(String key, {List<String>? args}) => LocalizationService.of(this).tr(key, args: args);
}
