import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../storage/sidebar_preference_service.dart';

part 'sidebar_state.dart';

/// Owns ONLY how the sidebar is displayed (expanded vs collapsed).
/// It knows nothing about which page is selected, navigation, theme, or
/// auth — that all stays in HomeCubit / SettingsCubit / AuthCubit.
class SidebarCubit extends Cubit<SidebarState> {
  final SidebarPreferenceService _preferenceService;

  /// The user's manually-chosen preference, as last persisted. Kept
  /// separate from [state.expanded] so a temporary responsive
  /// auto-collapse never overwrites what the user actually asked for.
  bool _userExpanded = true;

  /// True while the current collapsed state is due to the viewport being
  /// too narrow, not because the user chose to collapse.
  bool _autoCollapsed = false;

  SidebarCubit(this._preferenceService) : super(const SidebarState(expanded: true)) {
    _loadPersisted();
  }

  Future<void> _loadPersisted() async {
    final expanded = await _preferenceService.getExpanded();
    _userExpanded = expanded;
    if (!_autoCollapsed) {
      emit(SidebarState(expanded: expanded));
    }
  }

  void expand() {
    _userExpanded = true;
    _autoCollapsed = false;
    emit(const SidebarState(expanded: true));
    unawaited(_preferenceService.saveExpanded(true));
  }

  void collapse() {
    _userExpanded = false;
    _autoCollapsed = false;
    emit(const SidebarState(expanded: false));
    unawaited(_preferenceService.saveExpanded(false));
  }

  void toggle() => state.expanded ? collapse() : expand();

  /// Called by [SideBarLayout] whenever the available width changes.
  /// Never persists anything — purely a temporary visual override for
  /// narrow desktop windows, distinct from the user's saved preference.
  void applyResponsiveOverride({required bool isNarrow}) {
    if (isNarrow && state.expanded) {
      _autoCollapsed = true;
      emit(const SidebarState(expanded: false));
    } else if (!isNarrow && _autoCollapsed) {
      _autoCollapsed = false;
      emit(SidebarState(expanded: _userExpanded));
    }
  }
}