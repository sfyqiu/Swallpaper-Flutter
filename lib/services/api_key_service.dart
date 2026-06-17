import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyService {
  static final ApiKeyService _instance = ApiKeyService._();
  factory ApiKeyService() => _instance;
  ApiKeyService._();

  final Map<String, String> _keys = {};

  /// Load API keys from bundled json (CI builds) or shared preferences
  Future<void> initialize() async {
    // Try loading from bundled file (CI injects this)
    try {
      final jsonStr = await rootBundle.loadString('assets/api_keys.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          _keys[key] = value.toString();
        }
      });
    } catch (_) {
      // File not available in dev - check shared preferences instead
    }

    // Load user-set keys from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedKeys = prefs.getStringList('api_keys') ?? [];
    for (final entry in savedKeys) {
      final parts = entry.split(':');
      if (parts.length == 2 && parts[1].isNotEmpty) {
        _keys.putIfAbsent(parts[0], () => parts[1]);
      }
    }
  }

  String? getKey(String source) => _keys[source.toLowerCase()];

  bool hasKey(String source) => _keys.containsKey(source.toLowerCase());

  Future<void> setKey(String source, String key) async {
    _keys[source.toLowerCase()] = key;
    final prefs = await SharedPreferences.getInstance();
    final list = _keys.entries.map((e) => '${e.key}:${e.value}').toList();
    await prefs.setStringList('api_keys', list);
  }

  bool get hasAnyKeys => _keys.isNotEmpty;
}
