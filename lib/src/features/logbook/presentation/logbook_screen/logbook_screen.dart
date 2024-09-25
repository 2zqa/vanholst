import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/common_widgets/responsive_center.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';
import 'package:vanholst/src/features/logbook/presentation/logbook_screen/logbook_search_text_field.dart';
import 'package:vanholst/src/features/logbook/presentation/logbook_screen/logbook_view.dart';

/// Shows the list of products with a search field at the top.
class LogbookScreen extends ConsumerStatefulWidget {
  const LogbookScreen({super.key});

  @override
  ConsumerState<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends ConsumerState<LogbookScreen> {
  // * Use a [ScrollController] to register a listener that dismisses the
  // * on-screen keyboard when the user scrolls.
  // * This is needed because this page has a search field that the user can
  // * type into.
  final _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_dismissOnScreenKeyboard);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_dismissOnScreenKeyboard);
    super.dispose();
  }

  // When the search text field gets the focus, the keyboard appears on mobile.
  // This method is used to dismiss the keyboard when the user scrolls.
  void _dismissOnScreenKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(refreshKey: _refreshIndicatorKey.currentState),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => ref.refresh(logbookNotifierProvider.future),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: const [
            ResponsiveSliverCenter(
              padding: EdgeInsets.all(Sizes.p16),
              child: LogbookSearchTextField(),
            ),
            LogbookView(),
          ],
        ),
      ),
    );
  }
}
