import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoverBuilder extends StatelessWidget {
  final Size? size;
  final String url;
  const CoverBuilder({
    super.key,
    this.size,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size?.width,
      height: size?.height,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            frame != null
                ? child
                : Container(
                    color: Colors.grey[200]
                  ),
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200], 
                    child: CupertinoActivityIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200]
        ),
      ),
    );
  }
}