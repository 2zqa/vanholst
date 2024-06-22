import 'dart:convert';

import 'package:flutter/foundation.dart';

/// * The logbook entry identifier is an important concept and can have its own type.
typedef LogbookEntryID = String;

/// Class representing a logbook entry.
@immutable
class LogbookEntry {
  final String userId;
  final LogbookEntryID id;
  final String? infoForCoach;
  final String date;
  final String shortDayName;
  final String program;
  final String? sleep;
  final String? timings;
  final String? performance;
  final String? circumstances;
  final String? km;
  final String link;
  final String? feedbackCoach;
  final String timestamp;

  const LogbookEntry({
    required this.userId,
    required this.id,
    this.infoForCoach,
    required this.date, // in format 'dd/mm/yyyy'
    required this.shortDayName, // short day name, e.g. 'ma'
    required this.program,
    this.sleep,
    this.timings,
    this.performance,
    this.circumstances,
    this.km,
    required this.link,
    this.feedbackCoach,
    required this.timestamp,
  });

  DateTime? get dateTime {
    final parts = date.split('/');
    if (parts.length != 3) {
      return null;
    }
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  /// link is in format "<a href='https://connect.garmin.com/modern/activity/88888888888' rel='nofollow' target='_blank'><button class=''>GPS</button></a>", or a blank string. Parses the link to get the actual URL.
  Uri get linkUri {
    final match = RegExp(r"href='(.*?)'").firstMatch(link);
    if (match == null) {
      return Uri();
    }
    return Uri.parse(match.group(1)!);
  }

  /// Creates a [LogbookEntry] object from the given [schema].
  ///
  /// The [schema] parameter is a list of thirteen elements returned by the
  /// API.
  LogbookEntry.fromSchema(List<dynamic> schema)
      // comments are the column names in the schema on the website
      : userId = schema[0]!,
        id = schema[1]!,
        infoForCoach = schema[2], // info_voor_coach
        date = schema[3]!, // dag
        shortDayName = schema[4]!, // d
        program = schema[5], // programma
        sleep = schema[6], // Slaap
        timings = schema[7], // tijden
        performance = schema[8], // uitvoering
        circumstances = schema[9], // omstandigheden
        km = schema[10], // km // CAN BE NULL
        link = schema[11], // link
        feedbackCoach = schema[12], // Feedback_coach
        timestamp = schema[13];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'infoForCoach': infoForCoach,
      'date': date,
      'shortDayName': shortDayName,
      'program': program,
      'sleep': sleep,
      'timings': timings,
      'performance': performance,
      'circumstances': circumstances,
      'km': km,
      'link': link,
      'feedbackCoach': feedbackCoach,
    };
  }

  factory LogbookEntry.fromMap(Map<String, dynamic> map) {
    return LogbookEntry(
      userId: map['userId'] ?? '',
      id: map['id'] ?? '',
      infoForCoach: map['infoForCoach'] ?? '',
      date: map['date'] ?? '',
      shortDayName: map['shortDayName'] ?? '',
      program: map['program'] ?? '',
      sleep: map['sleep'] ?? '',
      timings: map['timings'] ?? '',
      performance: map['performance'] ?? '',
      circumstances: map['circumstances'] ?? '',
      km: map['km'] ?? '',
      link: map['link'] ?? '',
      feedbackCoach: map['feedbackCoach'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LogbookEntry.fromJson(String source) =>
      LogbookEntry.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LogbookEntry &&
        other.userId == userId &&
        other.id == id &&
        other.infoForCoach == infoForCoach &&
        other.date == date &&
        other.shortDayName == shortDayName &&
        other.program == program &&
        other.sleep == sleep &&
        other.timings == timings &&
        other.performance == performance &&
        other.circumstances == circumstances &&
        other.km == km &&
        other.link == link &&
        other.feedbackCoach == feedbackCoach &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        id.hashCode ^
        infoForCoach.hashCode ^
        date.hashCode ^
        shortDayName.hashCode ^
        program.hashCode ^
        sleep.hashCode ^
        timings.hashCode ^
        performance.hashCode ^
        circumstances.hashCode ^
        km.hashCode ^
        link.hashCode ^
        feedbackCoach.hashCode ^
        timestamp.hashCode;
  }
}
