import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/common_widgets/error_message_widget.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';

class LogbookEntryEditScreen extends ConsumerWidget {
  const LogbookEntryEditScreen({super.key, required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(logbookEntryProvider(entryId));
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: value.when(
          data: (entry) => entry != null
              ? LogbookEntryEditContents(entry: entry)
              : const LogbookEntryNotFoundContents(),
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
      final newEntry = widget.entry.copyWith(
        infoForCoach: () => infoForCoach,
        sleep: () => sleep,
        timings: () => timings,
        performance: () => performance,
        circumstances: () => circumstances,
        km: () => km,
        link: link,
      );
      debugPrint(newEntry.toString());
      // final controller = ref.read(logbookEntryEditControllerProvider.notifier);

      // final success = await controller.submit();
      // if (success) {
      //   widget.onSubmitted?.call();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Edit logbook entry');
  }
}

// TODO: implement logbook entry not found widget
class LogbookEntryNotFoundContents extends StatelessWidget {
  const LogbookEntryNotFoundContents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
