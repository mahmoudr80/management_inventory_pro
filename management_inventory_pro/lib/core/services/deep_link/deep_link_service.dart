import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:win32_registry/win32_registry.dart';
import '../../logger/logger.dart';

import '../../constants/deep_link_constants.dart';

/// Owns two things and nothing else:
///  1. Registering `managementinventory://` in the Windows registry so the
///     OS knows to launch this .exe when that scheme is opened.
///  2. Surfacing every incoming link (cold-start and while-running) as a
///     broadcast [Stream<Uri>].
///
/// Deliberately has zero knowledge of Supabase or navigation — that
/// decision-making belongs to the Cubit / a root-level listener. This
/// class is pure "how do links get to us" infrastructure.
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();

  Stream<Uri> get uriStream => _controller.stream;

  /// Writes the protocol registration under HKEY_CURRENT_USER, which
  /// requires no admin rights and works for unpackaged debug/release
  /// builds. Safe to call on every app launch — re-writing identical
  /// registry values is a no-op for Windows.
  ///
  /// For a packaged installer distribution later on, Supabase/app_links'
  /// own docs recommend registering via an MSIX manifest instead (it
  /// cleans itself up on uninstall). This registry-based approach is the
  /// one that works without that packaging step.
  ///
  /// Pinned to win32_registry ^2.1.0 (to stay on win32 ^5.9.0 and keep
  /// file_picker resolvable). This version predates the 3.0.0 rewrite,
  /// so it uses `Registry.currentUser` instead of the top-level
  /// `CURRENT_USER` constant, `createKey()`/`createValue()` instead of
  /// `create()`/`setValue()`, and `RegistryValue(name, type, data)` /
  /// `RegistryValue.string(name, data)` still take the value name as an
  /// argument rather than having it passed to `setValue()` separately.
  Future<void> registerWindowsProtocol() async {
    if (!Platform.isWindows) return;

    final appPath = Platform.resolvedExecutable;
    final protocolRegKey = 'Software\\Classes\\${DeepLinkConstants.scheme}';

    final regKey = Registry.currentUser.createKey(protocolRegKey);
    regKey.createValue(
      RegistryValue.string('', 'URL:Management Inventory Auth Callback'),
    );
    regKey.createValue(RegistryValue.string('URL Protocol', ''));

    final commandKey = regKey.createKey('shell\\open\\command');
    commandKey.createValue(RegistryValue.string('', '"$appPath" "%1"'));

    commandKey.close();
    regKey.close();
  }

  /// Start listening. Emits the link that cold-started the app exactly
  /// once (if any), then every subsequent link received while running —
  /// including ones forwarded from a second, short-lived instance via
  /// `SendAppLinkToInstance()` in `windows/runner/main.cpp`.
  Future<void> init() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      await DebugLogger.log("INITIAL URI = $initialUri");
      print('INITIAL URI: $initialUri');
      if (initialUri != null) _controller.add(initialUri);
    } catch (_) {
      // No initial link on a normal cold start — expected, not an error.
    }

    _subscription = _appLinks.uriLinkStream.listen(
          (uri) async {
            await DebugLogger.log("STREAM URI = $uri");
            print('STREAM URI: $uri');
            _controller.add(uri);
          }
        ,
      onError: (_) {
        // Malformed link from the OS — nothing actionable, drop it.
      },
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}