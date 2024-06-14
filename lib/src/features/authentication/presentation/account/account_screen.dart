import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/common_widgets/action_text_button.dart';
import 'package:vanholst/src/common_widgets/alert_dialogs.dart';
import 'package:vanholst/src/common_widgets/responsive_center.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'.hardcoded),
        actions: [
          ActionTextButton(
            text: 'Logout'.hardcoded,
            onPressed: () async {
              // * Get the navigator beforehand to prevent this warning:
              // * Don't use 'BuildContext's across async gaps.
              // * More info here: https://youtu.be/bzWaMpD1LHY
              final logout = await showAlertDialog(
                context: context,
                title: 'Are you sure?'.hardcoded,
                cancelActionText: 'Cancel'.hardcoded,
                defaultActionText: 'Logout'.hardcoded,
              );
              if (logout == true) {
                ref.read(accountScreenControllerProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
      body: const ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: UserDataTable(),
      ),
    );
  }
}

/// Simple user data table showing the uid and email
class UserDataTable extends ConsumerWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.titleSmall!;
    final user = ref.watch(authStateChangesProvider).value;
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Field'.hardcoded,
            style: style,
          ),
        ),
        DataColumn(
          label: Text(
            'Value'.hardcoded,
            style: style,
          ),
        ),
      ],
      rows: [
        _makeDataRow(
          'username'.hardcoded,
          user?.username ?? '',
          style,
        )
      ],
    );
  }

  DataRow _makeDataRow(String name, String value, TextStyle style) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            style: style,
          ),
        ),
        DataCell(
          Text(
            value,
            style: style,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
