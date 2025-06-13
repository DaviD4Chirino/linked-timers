import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NumberScrollWheel extends StatefulWidget {
  const NumberScrollWheel({
    required this.count,
    required this.itemHeight,
    this.label,
    this.onItemTap,
    this.onSelectedItemChanged,
    this.zeroBased = false,
    this.scrollController,
    super.key,
  });
  final double itemHeight;
  final int count;
  final bool zeroBased;

  final Widget? label;

  final FixedExtentScrollController? scrollController;

  final dynamic Function(int index)? onItemTap;
  final void Function(int index)? onSelectedItemChanged;

  @override
  State<NumberScrollWheel> createState() =>
      _NumberScrollWheelState();
}

class _NumberScrollWheelState extends State<NumberScrollWheel> {
  late final FixedExtentScrollController _scrollController =
      widget.scrollController ?? FixedExtentScrollController();

  late final ThemeData theme = Theme.of(context);

  late List<Center> list = List.generate(widget.count, (index) {
    String text =
        widget.zeroBased
            ? index.toString().padLeft(2, "0")
            : (index + 1).toString().padLeft(2, "0");
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: theme.textTheme.titleLarge!.fontSize,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  });

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.label != null)
          Positioned.fill(
            top: widget.itemHeight,
            child: IgnorePointer(
              child: Center(child: widget.label),
            ),
          ),
        ClickableListWheelScrollView(
          loop: true,
          scrollController: _scrollController,
          itemCount: list.length,
          itemHeight: widget.itemHeight,
          onItemTapCallback: widget.onItemTap,
          child: ListWheelScrollView.useDelegate(
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: widget.onSelectedItemChanged,
            controller: _scrollController,
            overAndUnderCenterOpacity: 0.2,
            diameterRatio: 3,
            perspective: 0.01,
            itemExtent: widget.itemHeight,
            childDelegate: ListWheelChildLoopingListDelegate(
              children: list,
            ),
          ),
        ),
      ],
    );
  }
}
