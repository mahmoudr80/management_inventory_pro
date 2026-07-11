import 'package:shared_preferences/shared_preferences.dart';
import '../../features/settings/data/models/settings_model.dart';

/// Persists the user's chosen appearance theme mode (light / dark /
/// system) across app restarts.
///
/// Deliberately separate from [StorageService]: that service is
/// Windows-only, Hive-backed, and scoped to user profiles. Theme mode
/// needs to work on every platform Flutter targets, and it's a single
/// primitive value, so `shared_preferences` is a better fit than opening
/// a Hive box for it.
class ThemePreferenceService {
  static const String _key = 'appearance_theme_mode';

  /// Returns the persisted mode, or [ThemeModeOption.system] if nothing
  /// has been saved yet (first launch, or storage was cleared).
  Future<ThemeModeOption> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    return ThemeModeOption.values.firstWhere(
          (option) => option.name == stored,
      orElse: () => ThemeModeOption.system,
    );
  }

  Future<void> saveThemeMode(ThemeModeOption mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}