import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/common_widgets/alert_dialogs.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Error'.hardcoded,
        exception: error,
      );
    }
  }
}
