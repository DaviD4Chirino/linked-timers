import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';

class NumberScrollWheel extends StatefulWidget {
  const NumberScrollWheel({
    required this.count,
    required this.itemHeight,
    this.label,
    this.onItemTapCallback,
    this.zeroBased = false,
    super.key,
  });
  final double itemHeight;
  final int count;
  final bool zeroBased;

  final Widget? label;

  final dynamic Function(int)? onItemTapCallback;

  @override
  State<NumberScrollWheel> createState() => _NumberScrollWheelState();
}

class _NumberScrollWheelState extends State<NumberScrollWheel> {
  final _scrollController = FixedExtentScrollController();

  late final ThemeData theme = Theme.of(context);

  late List<Center> list = List.generate(widget.count, (index) {
    String text = widget.zeroBased ? "$index" : "${index + 1}";
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: theme.textTheme.headlineSmall!.fontSize,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  });

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.label != null)
          Positioned.fill(
            top: widget.itemHeight,
            child: IgnorePointer(child: Center(child: widget.label)),
          ),
        ClickableListWheelScrollView(
          loop: true,
          scrollController: _scrollController,
          itemCount: list.length,
          itemHeight: widget.itemHeight,
          onItemTapCallback: widget.onItemTapCallback,
          child: ListWheelScrollView(
            physics: const FixedExtentScrollPhysics(),
            controller: _scrollController,
            overAndUnderCenterOpacity: 0.2,
            itemExtent: widget.itemHeight,
            children: list,
          ),
        ),
      ],
    );
  }
}
