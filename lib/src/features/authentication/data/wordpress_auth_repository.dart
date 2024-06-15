import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';
import 'package:vanholst/src/utils/get_impersonating_headers.dart';
import 'package:vanholst/src/utils/retrieve_between.dart';

class WordpressAuthRepository implements AuthRepository {
  WordpressAuthRepository(this.db);
  final Database db;
  final store = StoreRef.main();
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
    final record = await store.record(_userKey).get(db) as String?;
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
        return AppUser.fromJson(snapshot.value as String);
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
        throw Exception('Failed to parse nonce');
      }
      final formID =
          RegExp(r'id="form_id_\d+" value="(\d+)"').firstMatch(body)?.group(1);
      if (formID == null) {
        throw Exception('Failed to parse formID');
      }
      return (nonce, formID);
    } else {
      throw Exception('Failed to load page');
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
      throw Exception("Page didn't load correctly");
    }

    final cookieHeader = response.headers['set-cookie'];

    if (cookieHeader == null) {
      throw Exception('No cookies in response');
    }

    if (!cookieHeader.contains('wordpress_sec') ||
        !cookieHeader.contains('wordpress_logged_in')) {
      throw Exception('Missing required cookies');
    }
    // wordpress_sec_b1d66a434e254744aeb0809336998e7b=marijnkok%7C1718576029%7CB4VUAqcPM5v2526ESVW2Y57sfM5pCSUiuGsgt9Ysepk%7C0b95d392736a4342ac0dd03097b68398349a1166d3730c621a4b518c50223f18; path=/wp-content/plugins; secure; HttpOnly,wordpress_sec_b1d66a434e254744aeb0809336998e7b=marijnkok%7C1718576029%7CB4VUAqcPM5v2526ESVW2Y57sfM5pCSUiuGsgt9Ysepk%7C0b95d392736a4342ac0dd03097b68398349a1166d3730c621a4b518c50223f18; path=/wp-admin; secure; HttpOnly,wordpress_logged_in_b1d66a434e254744aeb0809336998e7b=marijnkok%7C1718576029%7CB4VUAqcPM5v2526ESVW2Y57sfM5pCSUiuGsgt9Ysepk%7C17bf903d24f09b146e45177d6b2ed30aeaada4f0f592f25cf73e0bbe47c8f17f; path=/; secure; HttpOnly,mailpoet_subscriber=%7B%22subscriber_id%22%3A65%7D; expires=Mon, 12 Jun 2034 22:13:49 GMT; Max-Age=315360000; path=/
    final hash = cookieHeader.retrieveBetween("wordpress_sec_", "=");
    final sec = cookieHeader.retrieveBetween("wordpress_sec_$hash=", ";");
    final loggedIn =
        cookieHeader.retrieveBetween("wordpress_logged_in_$hash", ";");

    return (sec, loggedIn, hash);
  }

  Future<http.Response> _getVanHolstLoginResponse() async {
    final headers = getImpersonatingHeaders();
    final params = {'redirect_to': 'https://www.vanholstcoaching.nl/account/'};
    final url = Uri.parse('https://www.vanholstcoaching.nl/login/')
        .replace(queryParameters: params);

    return http.get(url, headers: headers);
  }
}
