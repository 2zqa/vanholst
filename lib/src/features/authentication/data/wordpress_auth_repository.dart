import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';

class WordpressAuthRepository implements AuthRepository {
  WordpressAuthRepository(this.db);
  final Database db;

  // TODO: finish this
  // static Future<Database> createDatabase(String filename) async {
  //   if (!kIsWeb) {
  //     final appDocDir = await getApplicationDocumentsDirectory();
  //     return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
  //   } else {
  //     return databaseFactoryWeb.openDatabase(filename);
  //   }
  // }

  static Future<WordpressAuthRepository> makeDefault() async {
    final db = await createDatabase('auth.db');
    return WordpressAuthRepository(db);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AppUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> signInWithUsernameAndPassword(String username, String password) {
    // TODO: implement signInWithUsernameAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
