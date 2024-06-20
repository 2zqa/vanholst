import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/common_widgets/error_message_widget.dart';

class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget(
      {super.key, required this.value, required this.data});
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator())),
      error: (e, _) => SliverToBoxAdapter(
        child: Center(child: ErrorMessageWidget(e.toString())),
      ),
    );
  }
}
