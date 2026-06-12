import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_model.dart';

class StorageService {
  static const String _historyKey = 'agix_history';
  static const String _apiKeyKey = 'agix_api_key';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Save API Key
  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  // Load API Key
  Future<String?> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  // Save content to history
  Future<void> saveContent(ContentModel content) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await loadHistory();
    history.insert(0, content);

    // Keep only last 100 items
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }

    final jsonList = history.map((c) => c.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  // Load history
  Future<List<ContentModel>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((j) => ContentModel.fromJson(j)).toList();
    } catch (e) {
      return [];
    }
  }

  // Delete content from history
  Future<void> deleteContent(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await loadHistory();
    history.removeWhere((c) => c.id == id);
    final jsonList = history.map((c) => c.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  // Toggle favorite
  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await loadHistory();
    final index = history.indexWhere((c) => c.id == id);
    if (index != -1) {
      history[index].isFavorite = !history[index].isFavorite;
      final jsonList = history.map((c) => c.toJson()).toList();
      await prefs.setString(_historyKey, jsonEncode(jsonList));
    }
  }

  // Clear all history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  // Update content
  Future<void> updateContent(ContentModel updated) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await loadHistory();
    final index = history.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      history[index] = updated;
      final jsonList = history.map((c) => c.toJson()).toList();
      await prefs.setString(_historyKey, jsonEncode(jsonList));
    }
  }
}
