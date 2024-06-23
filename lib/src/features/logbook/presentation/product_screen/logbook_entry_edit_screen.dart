import 'package:flutter/material.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';

class LogbookEntryEditScreen extends StatelessWidget {
  const LogbookEntryEditScreen({super.key, required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: Center(
        child: Text('(Not implemented yet)'),
      ),
    );
  }
}
