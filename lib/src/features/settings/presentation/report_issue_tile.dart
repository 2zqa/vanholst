import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vanholst/src/constants/uris.dart';

class ReportIssueTile extends AbstractSettingsTile {
  const ReportIssueTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Consumer(builder: (context, ref, child) {
      return SettingsTile(
        leading: const Icon(Icons.mail_outline),
        title: Text(l.settingsReportIssue),
        onPressed: (context) async {
          await showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                icon: const Icon(Icons.bug_report_outlined),
                title: Text(l.settingsReportIssue),
                content: Text(l.settingsReportIssueDescription(
                    l.settingsSend.toLowerCase())),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      unawaited(launchUrl(Uris.supportMail));
                    },
                    child: Text(l.settingsSend),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }
}
