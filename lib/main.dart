import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/localization_service.dart';
import 'services/api_key_service.dart';
import 'services/source_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow both orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize services
  await LocalizationService.ensureInitialized();
  await ApiKeyService().initialize();
  await SourceManager().initialize();

  runApp(
    const ProviderScope(
      child: SwallpaperApp(),
    ),
  );
}
