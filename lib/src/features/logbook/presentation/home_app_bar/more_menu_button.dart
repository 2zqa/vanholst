import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/routing/app_router.dart';

/// A Simple Cascading Menu example using the [MenuAnchor] Widget.
class MyCascadingMenu extends StatefulWidget {
  const MyCascadingMenu({super.key});

  @override
  State<MyCascadingMenu> createState() => _MyCascadingMenuState();
}

class _MyCascadingMenuState extends State<MyCascadingMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        MenuItemButton(
          onPressed: () => context.goNamed(AppRoute.account.name),
          child: Text('Account'.hardcoded),
        ),
        MenuItemButton(
          onPressed: () {},
          child: Text('Settings'.hardcoded),
        )
      ],
      builder: (_, MenuController controller, Widget? child) {
        return IconButton(
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  }
}
