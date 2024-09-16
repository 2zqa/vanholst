import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vanholst/src/common_widgets/async_value_widget.dart';
import 'package:vanholst/src/common_widgets/empty_placeholder_widget.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/routing/app_router.dart';

/// Shows the product page for a given product ID.
class LogbookEntryScreen extends StatelessWidget {
  const LogbookEntryScreen({super.key, required this.entryId});
  final LogbookEntryID entryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      floatingActionButton: Consumer(
        child: const Icon(Icons.edit),
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () => context.goNamed(
              AppRoute.logbookEntryEdit.name,
              pathParameters: {'id': entryId},
            ),
            child: child,
          );
        },
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final logbookEntryValue = ref.watch(logbookEntryProvider(entryId));
          return AsyncValueWidget(
            value: logbookEntryValue,
            data: (entry) => entry == null
                ? EmptyPlaceholderWidget(message: 'Entry not found'.hardcoded)
                : LogbookEntryDetails(entry: entry),
          );
        },
      ),
    );
  }
}

class LogbookEntryDetails extends StatelessWidget {
  const LogbookEntryDetails({super.key, required this.entry});
  final LogbookEntry entry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(l.logbookProgramFor(entry.dateTime!),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              entry.program.isNotEmpty ? entry.program : l.logbookNoProgram,
              style: TextStyle(
                  fontSize: 20,
                  fontStyle:
                      entry.program.isNotEmpty ? null : FontStyle.italic),
            ),
            gapH24,
            Text(l.logbookPerformance,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(
                entry.performance ??
                    toBeginningOfSentenceCase(l.logbookNotProvided),
                style: TextStyle(
                    fontSize: 20,
                    fontStyle:
                        entry.performance != null ? null : FontStyle.italic)),
            gapH8,
            Text(
                l.logbookCircumstances(
                    entry.circumstances ?? l.logbookNotProvided),
                style: TextStyle(
                    fontSize: 16,
                    fontStyle:
                        entry.circumstances != null ? null : FontStyle.italic)),
            Text(
              l.logbookLink(
                  entry.link.isNotEmpty ? entry.link : l.logbookNotProvided),
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: entry.link.isNotEmpty ? null : FontStyle.italic),
            ),
            gapH8,
            Text(l.logbookInfoForCoach,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(
                entry.infoForCoach ??
                    toBeginningOfSentenceCase(l.logbookNotProvided),
                style: TextStyle(
                    fontSize: 20,
                    fontStyle:
                        entry.infoForCoach != null ? null : FontStyle.italic)),
            gapH8,
            Text(l.logbookSleep(entry.sleep ?? l.logbookNotProvided),
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: entry.sleep != null ? null : FontStyle.italic)),
            Text(l.logbookTimings(entry.timings ?? l.logbookNotProvided),
                style: TextStyle(
                    fontSize: 16,
                    fontStyle:
                        entry.timings != null ? null : FontStyle.italic)),
          ],
        )
      ],
    );
  }
}
