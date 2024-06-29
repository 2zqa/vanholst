import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                "${'Program for'.hardcoded} ${entry.shortDayName} ${entry.date}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(entry.program, style: const TextStyle(fontSize: 20)),
            gapH24,
            Text('Performance'.hardcoded,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(entry.performance ?? 'Not provided'.hardcoded,
                style: TextStyle(
                    fontSize: 20,
                    fontStyle:
                        entry.performance != null ? null : FontStyle.italic)),
            gapH8,
            Text(
                '${'Circumstances'.hardcoded}: ${entry.circumstances ?? 'not provided'.hardcoded}',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle:
                        entry.circumstances != null ? null : FontStyle.italic)),
            gapH8,
            Text('Info for Coach'.hardcoded,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(entry.infoForCoach ?? 'Not provided'.hardcoded,
                style: TextStyle(
                    fontSize: 20,
                    fontStyle:
                        entry.infoForCoach != null ? null : FontStyle.italic)),
            gapH8,
            Text(
                '${'Sleep'.hardcoded}: ${entry.sleep ?? 'not provided'.hardcoded}',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: entry.sleep != null ? null : FontStyle.italic)),
            Text(
                '${'Timings'.hardcoded}: ${entry.timings ?? 'not provided'.hardcoded}',
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
