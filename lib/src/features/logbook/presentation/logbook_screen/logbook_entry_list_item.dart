import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

/// Used to show a single product inside a card.
class LogbookEntryListItem extends StatelessWidget {
  const LogbookEntryListItem({
    super.key,
    required this.entry,
    this.onPressed,
    this.onEditPressed,
    this.isFilledIn = false,
    this.selected = false,
  });
  final LogbookEntry entry;
  final VoidCallback? onPressed;
  final VoidCallback? onEditPressed;
  final bool isFilledIn;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final program = entry.program;
    final isBike = entry.program.contains('fiets');
    return ListTile(
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      selectedColor: Theme.of(context).colorScheme.onPrimaryContainer,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              isFilledIn ? Icons.check_circle : Icons.circle,
              size: 24,
              color: isFilledIn
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.5),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withOpacity(0.5),
            onPressed: onEditPressed,
          ),
        ],
      ),
      leading: program.isEmpty
          ? const SizedBox.shrink()
          : isBike
              ? const Icon(Icons.directions_bike)
              : const Icon(Icons.directions_run),
      onTap: onPressed,
      title: program.isEmpty
          ? Text(l.logbookNoProgramBrief,
              style: const TextStyle(fontStyle: FontStyle.italic))
          : Text(program),
      subtitle: Text("${entry.shortDayName} ${entry.date}"),
    );
  }
}
