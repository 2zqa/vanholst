import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/common_widgets/empty_placeholder_widget.dart';
import 'package:vanholst/src/common_widgets/error_message_widget.dart';
import 'package:vanholst/src/common_widgets/primary_button.dart';
import 'package:vanholst/src/common_widgets/responsive_scrollable_card.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';
import 'package:vanholst/src/features/logbook/presentation/product_screen/logbook_entry_edit_screen_controller.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/routing/app_router.dart';
import 'package:vanholst/src/utils/async_value_ui.dart';

final _filteringTextInputFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]'));

class LogbookEntryEditScreen extends ConsumerWidget {
  const LogbookEntryEditScreen({super.key, required this.entryId});
  final LogbookEntryID entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(logbookEntryProvider(entryId));
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: value.when(
          data: (entry) => entry == null
              ? EmptyPlaceholderWidget(message: 'Entry not found'.hardcoded)
              : LogbookEntryEditContents(
                  entry: entry,
                  onSubmitted: () => context.goNamed(
                    AppRoute.logbookEntry.name,
                    pathParameters: {'id': entryId},
                  ),
                ),
          error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class LogbookEntryEditContents extends ConsumerStatefulWidget {
  const LogbookEntryEditContents({
    super.key,
    required this.entry,
    this.onSubmitted,
  });
  final LogbookEntry entry;
  final VoidCallback? onSubmitted;

  @override
  ConsumerState<LogbookEntryEditContents> createState() =>
      _LogbookEntryEditContentsState();
}

class _LogbookEntryEditContentsState
    extends ConsumerState<LogbookEntryEditContents> /*with XYZValidators*/ {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _infoForCoachController = TextEditingController();
  final _sleepController = TextEditingController();
  final _timingsController = TextEditingController();
  final _performanceController = TextEditingController();
  final _circumstancesController = TextEditingController();
  final _kmController = TextEditingController();
  final _linkController = TextEditingController();

  String get infoForCoach => _infoForCoachController.text;
  String get sleep => _sleepController.text;
  String get timings => _timingsController.text;
  String get performance => _performanceController.text;
  String get circumstances => _circumstancesController.text;
  String get km => _kmController.text;
  String get link => _linkController.text;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _infoForCoachController.text = widget.entry.infoForCoach ?? '';
    _sleepController.text = widget.entry.sleep ?? '';
    _timingsController.text = widget.entry.timings ?? '';
    _performanceController.text = widget.entry.performance ?? '';
    _circumstancesController.text = widget.entry.circumstances ?? '';
    _kmController.text = widget.entry.km ?? '';
    _linkController.text = widget.entry.link;
  }

  @override
  void dispose() {
    _node.dispose();
    _infoForCoachController.dispose();
    _sleepController.dispose();
    _timingsController.dispose();
    _performanceController.dispose();
    _circumstancesController.dispose();
    _kmController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller =
          ref.read(logbookEntryEditScreenControllerProvider.notifier);
      final newEntry = widget.entry.copyWith(
        infoForCoach: () => infoForCoach,
        sleep: () => sleep,
        timings: () => timings,
        performance: () => performance,
        circumstances: () => circumstances,
        km: () => km,
        link: link,
      );

      final success = await controller.save(newEntry);
      if (success) {
        widget.onSubmitted?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      logbookEntryEditScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(logbookEntryEditScreenControllerProvider);
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              gapH8,
              // info for coach field
              TextFormField(
                controller: _infoForCoachController,
                maxLines: null,
                minLines: 2,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Info for coach'.hardcoded,
                  enabled: !state.isLoading,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => _node.nextFocus(),
              ),
              // TODO: implement decimal formatting https://stackoverflow.com/a/51739086
              // Or maybe use stepper buttons or draggable bar
              TextFormField(
                controller: _sleepController,
                keyboardType: TextInputType.number,
                inputFormatters: [_filteringTextInputFormatter],
                decoration: InputDecoration(
                  labelText: 'Sleep (hours)'.hardcoded,
                  enabled: !state.isLoading,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => _node.nextFocus(),
              ),
              TextFormField(
                controller: _timingsController,
                keyboardType: TextInputType.number,
                // inputFormatters: const [],
                decoration: InputDecoration(
                  labelText: 'Timings'.hardcoded,
                  enabled: !state.isLoading,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => _node.nextFocus(),
              ),
              TextFormField(
                controller: _performanceController,
                minLines: 2,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Performance'.hardcoded,
                  enabled: !state.isLoading,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => _node.nextFocus(),
              ),
              TextFormField(
                controller: _circumstancesController,
                decoration: InputDecoration(
                  labelText: 'Circumstances'.hardcoded,
                  enabled: !state.isLoading,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => _node.nextFocus(),
              ),
              TextFormField(
                controller: _kmController,
                keyboardType: TextInputType.number,
                inputFormatters: [_filteringTextInputFormatter],
                decoration: InputDecoration(
                  labelText: 'Distance (km)'.hardcoded,
                  enabled: !state.isLoading,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => _node.nextFocus(),
              ),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Link'.hardcoded,
                  enabled: !state.isLoading,
                ),
                textInputAction: TextInputAction.done,
              ),
              gapH8,
              PrimaryButton(
                text: 'Update'.hardcoded,
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : () => _submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
