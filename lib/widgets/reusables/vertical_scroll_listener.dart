import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VerticalScrollController extends ChangeNotifier {
  bool _scrollingDown = false;

  bool get scrollingDown => _scrollingDown;

  set scrollingDown(bool value) {
    if (_scrollingDown != value) {
      _scrollingDown = value;
      notifyListeners();
    }
  }
}

class VerticalScrollListener extends StatefulWidget {
  const VerticalScrollListener({
    super.key,
    required this.child,
    this.controller,
  });

  final VerticalScrollController? controller;
  final Widget child;

  @override
  State<VerticalScrollListener> createState() =>
      _VerticalScrollListenerState();
}

class _VerticalScrollListenerState
    extends State<VerticalScrollListener> {
  @override
  /*  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(
    covariant VerticalScrollListener oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  } */
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification &&
            widget.controller != null) {
          final direction = notification.direction;
          if (direction == ScrollDirection.forward) {
            // scrolling up
            widget.controller!.scrollingDown = false;
          } else if (direction == ScrollDirection.reverse) {
            // scrolling down
            widget.controller!.scrollingDown = true;
          }
        }
        return false;
      },
      child: widget.child,
    );
  }
}
