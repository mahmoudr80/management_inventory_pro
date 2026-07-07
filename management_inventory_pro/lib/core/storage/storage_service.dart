import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import '../../features/auth/data/models/local_user_model.dart';

/// Handles local persistence for user profiles.
///
/// All data — the Hive database files AND a copy of every picked
/// image — lives in a folder named "personal" placed right next to
/// the running executable (not in AppData/Documents), so the whole
/// app stays portable as a single folder.
///
/// This is a plain instance class (not static) so it can be registered
/// with GetIt and injected wherever it's needed. See `locator.dart`.
class StorageService {
  static const String _boxName = 'usersBox';
  static const String _folderName = 'personal';

  Directory? _personalDir;
  Box<User>? _box;

  /// Returns the "personal" folder next to the .exe, creating it if needed.
  Future<Directory> getPersonalDirectory() async {
    if (_personalDir != null) return _personalDir!;

    // Platform.resolvedExecutable points at the running .exe (or binary
    // on other desktop platforms). Its parent folder is where we anchor
    // the "personal" data folder.
    final exeDir = File(Platform.resolvedExecutable).parent;
    final dir = Directory(p.join(exeDir.path, _folderName));

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    _personalDir = dir;
    return dir;
  }

  /// Initializes Hive with storage pointed at the personal folder,
  /// registers the User adapter, and opens the users box.
  /// Call this once at app startup, before runApp (see `locator.dart`).
  Future<void> init() async {
    final dir = await getPersonalDirectory();
    Hive.init(dir.path);

    if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
      Hive.registerAdapter(UserAdapter());
    }

    _box = await Hive.openBox<User>(_boxName);
  }

  Box<User> get _usersBox {
    final box = _box;
    if (box == null) {
      throw StateError('StorageService.init() must be called before use.');
    }
    return box;
  }

  /// True if a user with [name] (case-insensitive, trimmed) already exists.
  bool isUserRegistered(String name) {
    final target = name.trim().toLowerCase();
    return _usersBox.values
        .any((user) => user.name.trim().toLowerCase() == target);
  }

  /// True if at least one user is registered at all.
  bool hasAnyUser() => _usersBox.isNotEmpty;

  List<User> getAllUsers() => _usersBox.values.toList();

  /// Copies [imageFile] into the personal folder and stores a
  /// [User] record in Hive.
  Future<User> saveUser({
    required String name,
    required File imageFile,
  }) async {
    final dir = await getPersonalDirectory();

    final ext = p.extension(imageFile.path);
    final safeName = name.trim().replaceAll(RegExp(r'[^\w\-]'), '_');
    final fileName =
        '${safeName}_${DateTime.now().millisecondsSinceEpoch}$ext';
    final savedImage = File(p.join(dir.path, fileName));

    await imageFile.copy(savedImage.path);

    final user = User(
      name: name.trim(),
      imagePath: savedImage.path,
      createdAt: DateTime.now(),
    );

    await _usersBox.add(user);
    return user;
  }
  Future<void> clearUsers() async {
    // Delete copied images first.
    for (final user in _usersBox.values) {
      final file = File(user.imagePath);

      if (await file.exists()) {
        await file.delete();
      }
    }

    // Close the box.
    await _usersBox.close();

    // Delete the box from disk.
    await Hive.deleteBoxFromDisk(_boxName);

    // Reopen it if the app will continue using it.
    _box = await Hive.openBox<User>(_boxName);
  }
}
