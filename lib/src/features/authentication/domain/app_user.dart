import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  final String username;
  final String hash;
  final String sec;
  final String loggedIn;

  const AppUser({
    required this.username,
    required this.hash,
    required this.sec,
    required this.loggedIn,
  });

  // TODO: remove this
  const AppUser.demo()
      : username = 'john.doe@example.com',
        hash = 'af260975066dfcbf287cb2ec9cfe729b',
        sec = 'demo-sec',
        loggedIn = 'demo-loggedIn';
}
