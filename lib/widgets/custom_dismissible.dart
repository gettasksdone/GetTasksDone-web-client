import 'package:flutter/material.dart';

class CustomDismissible extends StatelessWidget {
  final DismissDirection _direction;
  final VoidCallback? onRightSwipe;
  final VoidCallback? onLeftSwipe;
  final ValueKey dimissibleKey;
  final bool _hasRightSwipe;
  final bool _hasLeftSwipe;
  final Widget child;

  const CustomDismissible({
    super.key,
    required this.dimissibleKey,
    required this.child,
    this.onRightSwipe,
    this.onLeftSwipe,
  })  : _hasRightSwipe = onRightSwipe != null,
        _hasLeftSwipe = onLeftSwipe != null,
        _direction = onRightSwipe != null && onLeftSwipe != null
            ? DismissDirection.horizontal
            : (onRightSwipe != null
                ? DismissDirection.startToEnd
                : (onLeftSwipe != null
                    ? DismissDirection.endToStart
                    : DismissDirection.horizontal));

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dimissibleKey,
      direction: _direction,
      confirmDismiss: (DismissDirection direction) async {
        if (_hasRightSwipe && (direction == DismissDirection.startToEnd)) {
          onRightSwipe!();

          return true;
        } else if (_hasLeftSwipe &&
            (direction == DismissDirection.endToStart)) {
          onLeftSwipe!();
        }

        return false;
      },
      child: child,
    );
  }
}
