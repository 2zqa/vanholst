import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:vanholst/src/features/settings/domain/settings.dart';

class SettingsRepository {
  SettingsRepository(this.db);
  final Database db;
  final store = StoreRef<String, String>.main();
  static const _settingsKey = 'settings';
  late Settings _currentSettings;

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SettingsRepository> makeDefault() async {
    final db = await createDatabase('settings.db');
    final repo = SettingsRepository(db);
    repo._currentSettings = await repo._fetchSettings();
    return repo;
  }

  Future<Settings> _fetchSettings() async {
    final record = await store.record(_settingsKey).get(db);
    if (record == null) {
      return const Settings();
    }
    return Settings.fromJson(record);
  }

  Stream<Settings> settingsStateChanges() {
    final record = store.record(_settingsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Settings.fromJson(snapshot.value);
      } else {
        return const Settings();
      }
    });
  }

  Settings get currentSettings => _currentSettings;

  Future<void> storeSettings(Settings settings) async {
    await store.record(_settingsKey).put(db, settings.toJson());
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError('Provider not overridden; see main.dart');
});

final settingsStateChangesProvider =
    StreamProvider.autoDispose<Settings>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return settingsRepository.settingsStateChanges();
});
