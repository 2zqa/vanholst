import 'package:intl/intl.dart';

final _cookieDateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

/// Returns a map of headers that make the request look like it's coming from a real browser.
///
/// The [cookie] parameter can be used to add additional cookies to the request.
/// Example of adding two cookies: 'session_id=abc123; another_cookie=def456'
Map<String, String> getImpersonatingHeaders({String cookie = ''}) {
  final firstVisitDate = DateTime.now().subtract(const Duration(seconds: 5));
  final formattedTime = _cookieDateFormatter.format(firstVisitDate);
  final encodedTime = Uri.encodeComponent(formattedTime);

  if (cookie.isNotEmpty) {
    cookie = '; $cookie';
  }

  // Note the use of $encodedTime and $cookie in the cookie string.
  return {
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'accept-language': 'nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7',
    'cookie':
        'sbjs_migrations=1418474375998%3D1; sbjs_current_add=fd%3D$encodedTime%7C%7C%7Cep%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2F%7C%7C%7Crf%3Dhttps%3A%2F%2Fwww.google.com%2F; sbjs_first_add=fd%3D$encodedTime%7C%7C%7Cep%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2F%7C%7C%7Crf%3Dhttps%3A%2F%2Fwww.google.com%2F; sbjs_current=typ%3Dorganic%7C%7C%7Csrc%3Dgoogle%7C%7C%7Cmdm%3Dorganic%7C%7C%7Ccmp%3D%28none%29%7C%7C%7Ccnt%3D%28none%29%7C%7C%7Ctrm%3D%28none%29%7C%7C%7Cid%3D%28none%29; sbjs_first=typ%3Dorganic%7C%7C%7Csrc%3Dgoogle%7C%7C%7Cmdm%3Dorganic%7C%7C%7Ccmp%3D%28none%29%7C%7C%7Ccnt%3D%28none%29%7C%7C%7Ctrm%3D%28none%29%7C%7C%7Cid%3D%28none%29; sbjs_udata=vst%3D1%7C%7C%7Cuip%3D%28none%29%7C%7C%7Cuag%3DMozilla%2F5.0%20%28X11%3B%20Linux%20x86_64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F125.0.0.0%20Safari%2F537.36; sbjs_session=pgs%3D4%7C%7C%7Ccpg%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2F$cookie',
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
}

Map<String, String> getImpersonatingSchemaHeaders(
    {required String authCookie}) {
  final firstVisitDate = DateTime.now().subtract(const Duration(seconds: 5));
  final formattedTime = _cookieDateFormatter.format(firstVisitDate);
  final encodedTime = Uri.encodeComponent(formattedTime);

  return {
    'accept': 'application/json, text/javascript, */*; q=0.01',
    'accept-language': 'nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7',
    'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'cookie':
        '$authCookie; sbjs_migrations=1418474375998%3D1; sbjs_current_add=fd%3D$encodedTime%7C%7C%7Cep%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2Fschema-en-logboek%2F%7C%7C%7Crf%3D%28none%29; sbjs_first_add=fd%3D$encodedTime%7C%7C%7Cep%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2Fschema-en-logboek%2F%7C%7C%7Crf%3D%28none%29; sbjs_current=typ%3Dtypein%7C%7C%7Csrc%3D%28direct%29%7C%7C%7Cmdm%3D%28none%29%7C%7C%7Ccmp%3D%28none%29%7C%7C%7Ccnt%3D%28none%29%7C%7C%7Ctrm%3D%28none%29%7C%7C%7Cid%3D%28none%29; sbjs_first=typ%3Dtypein%7C%7C%7Csrc%3D%28direct%29%7C%7C%7Cmdm%3D%28none%29%7C%7C%7Ccmp%3D%28none%29%7C%7C%7Ccnt%3D%28none%29%7C%7C%7Ctrm%3D%28none%29%7C%7C%7Cid%3D%28none%29; sbjs_udata=vst%3D1%7C%7C%7Cuip%3D%28none%29%7C%7C%7Cuag%3DMozilla%2F5.0%20%28X11%3B%20Linux%20x86_64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F125.0.0.0%20Safari%2F537.36; sbjs_session=pgs%3D4%7C%7C%7Ccpg%3Dhttps%3A%2F%2Fwww.vanholstcoaching.nl%2Fschema-en-logboek%2F',
    'origin': 'https://www.vanholstcoaching.nl',
    'priority': 'u=1, i',
    'referer': 'https://www.vanholstcoaching.nl/schema-en-logboek/',
    'sec-ch-ua':
        '"Google Chrome";v="125", "Chromium";v="125", "Not.A/Brand";v="24"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Linux"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'user-agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
    'x-requested-with': 'XMLHttpRequest',
  };
}
