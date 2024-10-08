import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/common_widgets/async_sliver_value_widget.dart';
import 'package:vanholst/src/common_widgets/responsive_center.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';
import 'package:vanholst/src/features/logbook/presentation/logbook_screen/logbook_entry_list_item.dart';
import 'package:vanholst/src/features/logbook/presentation/logbook_screen/logbook_search_state_provider.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/routing/app_router.dart';
import 'package:vanholst/src/utils/is_today.dart';

/// A widget that displays the list of products that match the search query.
class LogbookView extends ConsumerWidget {
  const LogbookView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logbookValue = ref.watch(logbookSearchResultsProvider);
    return AsyncValueSliverWidget(
      value: logbookValue,
      data: (entries) => entries.isEmpty
          ? ResponsiveSliverCenter(
              child: Text(
                'No logbook entries found'.hardcoded,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : LogbookEntryList(entries: entries),
    );
  }
}

class LogbookEntryList extends StatelessWidget {
  final List<LogbookEntry> entries;
  const LogbookEntryList({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: entries.length,
      separatorBuilder: (context, index) => const ResponsiveCenter(
          child: Divider(indent: Sizes.p16, endIndent: Sizes.p16)),
      itemBuilder: (_, index) {
        final entry = entries[index];
        return ResponsiveCenter(
          child: LogbookEntryListItem(
            entry: entry,
            selected: entry.dateTime?.isToday == true,
            isFilledIn: entry.isFilledIn,
            onEditPressed: () => context.goNamed(
              AppRoute.logbookEntryEdit.name,
              pathParameters: {'id': entry.id},
            ),
            onPressed: () => context.goNamed(
              AppRoute.logbookEntry.name,
              pathParameters: {'id': entry.id},
            ),
          ),
        );
      },
    );
  }
}
