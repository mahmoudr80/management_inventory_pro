import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's manual sidebar collapse/expand preference.
///
/// Deliberately separate from [StorageService]: that service is
/// Windows-only, Hive-backed, and scoped to user profiles. This is a
/// single primitive value that needs to work on every platform Flutter
/// targets, so shared_preferences is the right fit — same reasoning as
/// ThemePreferenceService.
class SidebarPreferenceService {
  static const String _key = 'sidebar_expanded';

  Future<bool> getExpanded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  Future<void> saveExpanded(bool expanded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, expanded);
  }
}