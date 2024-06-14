import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';

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
    return store
        .record(_userKey)
        .onSnapshot(db)
        .map((snapshot) => snapshot?.value as AppUser?);
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
    final uri = Uri.parse("https://www.vanholstcoaching.nl/login/");
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

    final cookies = cookieHeader.split(RegExp(r'\s*,\s*'));

    final secSplit = cookies
        .firstWhere((cookie) => cookie.startsWith('wordpress_sec'))
        .split('=');
    final hash = secSplit[0].split('_').last;
    final loggedIn = cookies
        .firstWhere((cookie) => cookie.startsWith('wordpress_logged_in'))
        .split('=')[1];

    return (secSplit[1], loggedIn, hash);
  }

  Future<http.Response> _getVanHolstLoginResponse() async {
    final now = DateTime.now().subtract(const Duration(seconds: 5));
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final encodedTime = Uri.encodeComponent(formattedTime);
    final headers = {
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
      'accept-language': 'nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7',
      'cookie':
          'sbjs_migrations=1418474375998%3D1; sbjs_current_add=fd%3D$encodedTime%7C%7C%7Cep%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2F%7C%7C%7Crf%3Dhttps%3A%2F%2Fwww.google.com%2F; sbjs_first_add=fd%3D$encodedTime%7C%7C%7Cep%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2F%7C%7C%7Crf%3Dhttps%3A%2F%2Fwww.google.com%2F; sbjs_current=typ%3Dorganic%7C%7C%7Csrc%3Dgoogle%7C%7C%7Cmdm%3Dorganic%7C%7C%7Ccmp%3D%28none%29%7C%7C%7Ccnt%3D%28none%29%7C%7C%7Ctrm%3D%28none%29%7C%7C%7Cid%3D%28none%29; sbjs_first=typ%3Dorganic%7C%7C%7Csrc%3Dgoogle%7C%7C%7Cmdm%3Dorganic%7C%7C%7Ccmp%3D%28none%29%7C%7C%7Ccnt%3D%28none%29%7C%7C%7Ctrm%3D%28none%29%7C%7C%7Cid%3D%28none%29; sbjs_udata=vst%3D1%7C%7C%7Cuip%3D%28none%29%7C%7C%7Cuag%3DMozilla%2F5.0%20%28X11%3B%20Linux%20x86_64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F125.0.0.0%20Safari%2F537.36; sbjs_session=pgs%3D4%7C%7C%7Ccpg%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2F',
      'priority': 'u=0, i',
      'referer': 'https://www.vanholstcoaching.nl/',
      'sec-ch-ua':
          '"Google Chrome";v="125", "Chromium";v="125", "Not.A/Brand";v="24"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Linux"',
      'sec-fetch-dest': 'document',
      'sec-fetch-mode': 'navigate',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-user': '?1',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
    };

    final params = {'redirect_to': 'https://www.vanholstcoaching.nl/account/'};

    final url = Uri.parse('https://www.vanholstcoaching.nl/login/')
        .replace(queryParameters: params);

    return http.get(url, headers: headers);
  }
}
