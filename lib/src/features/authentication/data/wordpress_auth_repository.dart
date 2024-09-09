import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:vanholst/src/exceptions/app_exception.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';
import 'package:vanholst/src/utils/get_impersonating_headers.dart';
import 'package:vanholst/src/utils/retrieve_between.dart';

class WordpressAuthRepository implements AuthRepository {
  WordpressAuthRepository(this.db);
  final Database db;
  final store = StoreRef<String, String>.main();
  static const _userKey = 'user';
  AppUser? _currentUser;

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<WordpressAuthRepository> makeDefault() async {
    final db = await createDatabase('auth.db');
    final repo = WordpressAuthRepository(db);
    repo._currentUser = await repo._fetchUser();
    return repo;
  }

  Future<AppUser?> _fetchUser() async {
    final record = await store.record(_userKey).get(db);
    if (record == null) {
      return null;
    }
    return AppUser.fromJson(record);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    final record = store.record(_userKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return AppUser.fromJson(snapshot.value);
      } else {
        return null;
      }
    });
  }

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<void> signInWithUsernameAndPassword(
      String username, String password) async {
    final (loginNonce, formID) = await _getNonceAndFormID();
    final (sec, loggedIn, hash) =
        await _signIn(username, password, loginNonce, formID);
    final user = AppUser(
      username: username,
      sec: sec,
      loggedIn: loggedIn,
      hash: hash,
    );
    _currentUser = user;
    await store.record(_userKey).put(db, user.toJson());
  }

  @override
  void signOut() {
    _currentUser = null;
    unawaited(store.record(_userKey).delete(db));
  }

  Future<(String, String)> _getNonceAndFormID() async {
    final response = await _getVanHolstLoginResponse();
    if (response.statusCode == 200) {
      final body = response.body;
      final nonce =
          RegExp(r'name="_wpnonce" value="(\w+)"').firstMatch(body)?.group(1);
      if (nonce == null) {
        throw ParseException();
      }
      final formID =
          RegExp(r'id="form_id_\d+" value="(\d+)"').firstMatch(body)?.group(1);
      if (formID == null) {
        throw ParseException();
      }
      return (nonce, formID);
    } else {
      throw PageLoadException();
    }
  }

  Future<(String, String, String)> _signIn(
    String username,
    String password,
    String loginNonce,
    String formID,
  ) async {
    final response = await http.post(
      Uri.parse("https://www.vanholstcoaching.nl/login/"),
      body: {
        'username-$formID': username,
        'user_password-$formID': password,
        'form_id': formID,
        "um_request": "",
        '_wpnonce': loginNonce,
        '_wp_http_referer': '/login/',
      },
    );

    if (response.statusCode != 302) {
      _checkInvalidPassword(response.body);
      throw PageLoadException();
    }

    final cookieHeader = response.headers['set-cookie'];

    if (cookieHeader == null) {
      throw MissingCookiesException();
    }

    if (!cookieHeader.contains('wordpress_sec') ||
        !cookieHeader.contains('wordpress_logged_in')) {
      throw MissingCookiesException();
    }

    final hash = cookieHeader.retrieveBetween("wordpress_sec_", "=");
    final sec = cookieHeader.retrieveBetween("wordpress_sec_$hash=", ";");
    final loggedIn =
        cookieHeader.retrieveBetween("wordpress_logged_in_$hash=", ";");

    return (sec, loggedIn, hash);
  }

  Future<http.Response> _getVanHolstLoginResponse() async {
    final headers = getImpersonatingHeaders();
    final params = {'redirect_to': 'https://www.vanholstcoaching.nl/account/'};
    final url = Uri.parse('https://www.vanholstcoaching.nl/login/')
        .replace(queryParameters: params);

    return http.get(url, headers: headers);
  }

  bool _checkInvalidPassword(String body) {
    if (body.contains('Wachtwoord is onjuist. Probeer het opnieuw.')) {
      throw WrongPasswordException();
    }
    return false;
  }
}
