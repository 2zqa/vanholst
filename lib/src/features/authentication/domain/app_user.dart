import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'hash': hash,
      'sec': sec,
      'loggedIn': loggedIn,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      username: map['username'] ?? '',
      hash: map['hash'] ?? '',
      sec: map['sec'] ?? '',
      loggedIn: map['loggedIn'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(username: $username, hash: $hash, sec: $sec, loggedIn: $loggedIn)';
  }
}
