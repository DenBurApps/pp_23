import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final String label;
  const AppButton({
    super.key,
    required this.onPressed,
    this.isActive = true,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: isActive ? onPressed : null,
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(isActive ? 1 : 0.5),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withOpacity(isActive ? 1 : 0.5),
              ),
        ),
      ),
    );
  }
}
