import 'dart:async';
import 'dart:io';

class DebugLogger {
  static final File _file = File(r'C:\temp\deep_link_debug.txt');

  /// Every call to [log] chains its write onto this future instead of
  /// firing `File.writeAsString` directly. `writeAsString(mode: append)`
  /// opens, seeks to end, writes, and closes the file on EVERY call — if
  /// two calls overlap (very common here, since most call sites don't
  /// `await` inside `initState`/sync callbacks), their open/seek/write
  /// cycles interleave and corrupt or drop each other's line. Chaining
  /// through `_writeQueue` forces every write to wait for the previous
  /// one to fully complete, so writes land strictly one after another
  /// regardless of how many callers fire `log()` concurrently.
  static Future<void> _writeQueue = Future.value();

  static Future<void> init() async {
    await _file.create(recursive: true);
    await _writeQueue; // let any in-flight writes finish first
    await _file.writeAsString('');
  }

  static Future<void> log(String message) {
    final entry = '[${DateTime.now()}] $message\n';
    final result = _writeQueue.then(
          (_) => _file.writeAsString(entry, mode: FileMode.append),
    );
    // Swallow errors on the queue itself so one failed write doesn't
    // permanently wedge every log call after it; the error is still
    // visible to whoever awaited this particular call's returned future.
    _writeQueue = result.catchError((_) {});
    return result;
  }
}