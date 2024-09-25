import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/logbook/presentation/logbook_screen/logbook_search_state_provider.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';

/// Search field used to filter products by name
class LogbookSearchTextField extends ConsumerStatefulWidget {
  const LogbookSearchTextField({super.key});

  @override
  ConsumerState<LogbookSearchTextField> createState() =>
      _LogbookSearchTextFieldState();
}

class _LogbookSearchTextFieldState
    extends ConsumerState<LogbookSearchTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // See this article for more info about how to use [ValueListenableBuilder]
    // with TextField:
    // https://codewithandrea.com/articles/flutter-text-field-form-validation/
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
          controller: _controller,
          autofocus: false,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: 'Search performances'.hardcoded,
            icon: const Icon(Icons.search),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _controller.clear();
                      ref.read(logbookSearchQueryStateProvider.notifier).state =
                          '';
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          onChanged: (value) {
            ref.read(logbookSearchQueryStateProvider.notifier).state = value;
          },
        );
      },
    );
  }
}
