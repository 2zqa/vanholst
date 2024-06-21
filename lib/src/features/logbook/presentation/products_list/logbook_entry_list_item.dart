import 'package:flutter/material.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';

/// Used to show a single product inside a card.
class LogbookEntryListItem extends StatelessWidget {
  const LogbookEntryListItem({super.key, required this.entry, this.onPressed});
  final LogbookEntry entry;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final program = entry.program;
    final isBike = entry.program.contains('fiets');
    return ListTile(
      leading: program.isEmpty
          ? const SizedBox.shrink()
          : isBike
              ? const Icon(Icons.directions_bike)
              : const Icon(Icons.directions_run),
      onTap: onPressed,
      title: program.isEmpty
          ? Text('No program'.hardcoded,
              style: const TextStyle(fontStyle: FontStyle.italic))
          : Text(program),
      subtitle: Text(entry.date),
    );
  }
}
