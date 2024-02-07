import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_23/generated/assets.gen.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Assets.icons.back
          .svg(color: Theme.of(context).colorScheme.onBackground),
      onPressed: onPressed ?? Navigator.of(context).pop,
    );
  }
}
