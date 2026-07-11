import '../../data/models/settings_model.dart';

/// Immutable snapshot of the Settings screen.
///
/// `settings` is always the live, editable copy — every field edit goes
/// through [SettingsCubit] and produces a new [SettingsState] via
/// [copyWith]. `hasUnsavedChanges` is derived by the Cubit whenever
/// `settings` diverges from the last-saved snapshot, not recomputed here,
/// so the state itself stays a plain data holder.
class SettingsState {
  final SettingsModel settings;
  final bool hasUnsavedChanges;
  final bool isSaving;
  final String? successMessage;
  final String? errorMessage;

  const SettingsState({
    required this.settings,
    this.hasUnsavedChanges = false,
    this.isSaving = false,
    this.successMessage,
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingsModel? settings,
    bool? hasUnsavedChanges,
    bool? isSaving,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isSaving: isSaving ?? this.isSaving,
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
