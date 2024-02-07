import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_23/generated/assets.gen.dart';
import 'package:pp_23/presentation/modules/settings_view.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Assets.icons.settings
          .svg(color: Theme.of(context).colorScheme.onBackground),
      onPressed: () => showCupertinoModalPopup(
        context: context,
        builder: (context) => SettingsView(),
      ),
    );
  }
}
