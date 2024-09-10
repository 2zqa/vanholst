import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vanholst/src/exceptions/app_exception.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';
import 'package:vanholst/src/features/authentication/domain/app_user_cookie.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';
import 'package:vanholst/src/utils/get_impersonating_headers.dart';

const _vanholstAdminUri =
    'https://www.vanholstcoaching.nl/wp-admin/admin-ajax.php';
const _defaultFormData = {
  'draw': '1',
  'columns[0][data]': '0',
  'columns[0][name]': 'userid',
  'columns[0][searchable]': 'true',
  'columns[0][orderable]': 'false',
  'columns[0][search][value]': '',
  'columns[0][search][regex]': 'false',
  'columns[1][data]': '1',
  'columns[1][name]': 'wdt_ID',
  'columns[1][searchable]': 'true',
  'columns[1][orderable]': 'false',
  'columns[1][search][value]': '',
  'columns[1][search][regex]': 'false',
  'columns[2][data]': '2',
  'columns[2][name]': 'info_voor_coach',
  'columns[2][searchable]': 'true',
  'columns[2][orderable]': 'true',
  'columns[2][search][value]': '',
  'columns[2][search][regex]': 'false',
  'columns[3][data]': '3',
  'columns[3][name]': 'dag',
  'columns[3][searchable]': 'true',
  'columns[3][orderable]': 'true',
  'columns[3][search][value]': '',
  'columns[3][search][regex]': 'false',
  'columns[4][data]': '4',
  'columns[4][name]': 'd',
  'columns[4][searchable]': 'false',
  'columns[4][orderable]': 'false',
  'columns[4][search][value]': '',
  'columns[4][search][regex]': 'false',
  'columns[5][data]': '5',
  'columns[5][name]': 'programma',
  'columns[5][searchable]': 'true',
  'columns[5][orderable]': 'true',
  'columns[5][search][value]': '',
  'columns[5][search][regex]': 'false',
  'columns[6][data]': '6',
  'columns[6][name]': 'Slaap',
  'columns[6][searchable]': 'true',
  'columns[6][orderable]': 'false',
  'columns[6][search][value]': '',
  'columns[6][search][regex]': 'false',
  'columns[7][data]': '7',
  'columns[7][name]': 'tijden',
  'columns[7][searchable]': 'true',
  'columns[7][orderable]': 'false',
  'columns[7][search][value]': '',
  'columns[7][search][regex]': 'false',
  'columns[8][data]': '8',
  'columns[8][name]': 'uitvoering',
  'columns[8][searchable]': 'true',
  'columns[8][orderable]': 'true',
  'columns[8][search][value]': '',
  'columns[8][search][regex]': 'false',
  'columns[9][data]': '9',
  'columns[9][name]': 'omstandigheden',
  'columns[9][searchable]': 'true',
  'columns[9][orderable]': 'true',
  'columns[9][search][value]': '',
  'columns[9][search][regex]': 'false',
  'columns[10][data]': '10',
  'columns[10][name]': 'km',
  'columns[10][searchable]': 'true',
  'columns[10][orderable]': 'true',
  'columns[10][search][value]': '',
  'columns[10][search][regex]': 'false',
  'columns[11][data]': '11',
  'columns[11][name]': 'link',
  'columns[11][searchable]': 'false',
  'columns[11][orderable]': 'false',
  'columns[11][search][value]': '',
  'columns[11][search][regex]': 'false',
  'columns[12][data]': '12',
  'columns[12][name]': 'Feedback_coach',
  'columns[12][searchable]': 'true',
  'columns[12][orderable]': 'false',
  'columns[12][search][value]': '',
  'columns[12][search][regex]': 'false',
  'columns[13][data]': '13',
  'columns[13][name]': 'timestamp',
  'columns[13][searchable]': 'true',
  'columns[13][orderable]': 'false',
  'columns[13][search][value]': '',
  'columns[13][search][regex]': 'false',
  'order[0][column]': '3',
  'order[0][dir]': 'asc',
  'start': '0',
  'search[value]': '',
  'search[regex]': 'false',
};

class WordpressLogbookRepository implements LogbookRepository {
  WordpressLogbookRepository(this.appUser);
  final AppUser? appUser;
  static const _queryCount = 25;
  static const tableId = 352;
  Map<LogbookEntryID, LogbookEntry> cache = {};

  @override
  Future<List<LogbookEntry>> getLogbookEntryList() async {
    final user = appUser;
    if (user == null) {
      throw NotLoggedInException();
    }
    final (tableNonce, tableId) = await _getNonceAndTableID(user);
    final json = await _getRowJson(user, tableNonce, tableId);

    _updateCache(json);
    return cache.values.toList();
  }

  @override
  Future<LogbookEntry?> getLogbookEntry(String id) async {
    if (cache.isEmpty) {
      await getLogbookEntryList();
    }
    return cache[id];
  }

  @override
  Future<void> updateLogbookEntry(LogbookEntry entry) async {
    final user = appUser;
    if (user == null) {
      throw NotLoggedInException();
    }
    final (tableNonce, tableId) = await _getNonceAndTableID(user);
    final url = Uri.parse(_vanholstAdminUri);
    final String formData = entry.toFormData(tableNonce, tableId);
    final headers = getImpersonatingSchemaHeaders(authCookie: user.cookie);
    final response = await http.post(
      url,
      body: formData,
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw PageLoadException();
    }
  }

  Future<(String, String)> _getNonceAndTableID(AppUser appUser) async {
    final response = await _getVanHolstLogbookResponse(appUser);
    if (response.statusCode == 200) {
      final body = response.body;
      final match = RegExp(r'name="wdtNonceFrontendEdit_(\d+)" value="(\w+)"')
          .firstMatch(body);
      if (match == null) {
        throw ParseException();
      }
      final tableId = match.group(1);
      final nonce = match.group(2);
      if (nonce == null || tableId == null) {
        throw ParseException();
      }
      return (nonce, tableId);
    } else {
      throw ParseException();
    }
  }

  void _updateCache(List<dynamic> json) {
    cache = {};
    for (final row in json) {
      final entry = LogbookEntry.fromSchema(row);
      cache[entry.id] = entry;
    }
  }

  Future<http.Response> _getVanHolstLogbookResponse(AppUser user) {
    final url = Uri.parse("https://www.vanholstcoaching.nl/schema-en-logboek/");
    final headers = getImpersonatingHeaders(cookie: user.cookie);
    // TODO: check if 404, then re-authenticate
    return http.get(url, headers: headers);
  }

  Future<List<dynamic>> _getRowJson(
      AppUser user, String tableNonce, String tableId) async {
    final url =
        Uri.parse("$_vanholstAdminUri?action=get_wdtable&table_id=$tableId");
    final formData = {
      ..._defaultFormData,
      'length': _queryCount.toString(),
      'wdtNonce': tableNonce,
    };
    final requestBody = formData.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    final headers = getImpersonatingSchemaHeaders(authCookie: user.cookie);
    final response = await http.post(
      url,
      body: requestBody,
      headers: headers,
    );
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw PageLoadException();
      }
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['data'];
    } else {
      throw PageLoadException();
    }
  }
}
