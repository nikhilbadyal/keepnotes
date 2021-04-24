import 'dart:math';

import 'package:flutter/material.dart';

typedef PickerLayoutBuilder = Widget Function(
    BuildContext context, List<Color> colors, PickerItem child);
typedef PickerItem = Widget Function(Color color);
typedef PickerItemBuilder = Widget Function(
    Color color, void Function() changeColor,
    {required bool isCurrentColor});

class ColorPicker extends StatefulWidget {
  const ColorPicker(
      {required this.pickerColor,
      required this.onColorChanged,
      required this.availableColors,
      this.layoutBuilder = defaultLayoutBuilder,
      this.itemBuilder = defaultItemBuilder,
      Key? key})
      : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  static Widget defaultLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    final orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: orientation == Orientation.portrait ? 300 : 300,
      height: orientation == Orientation.portrait ? 360 : 200,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: colors.map((color) => child(color)).toList(),
      ),
    );
  }

  static Widget defaultItemBuilder(Color color, void Function() changeColor,
          {required bool isCurrentColor}) =>
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: changeColor,
            borderRadius: BorderRadius.circular(50),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 210),
              opacity: isCurrentColor ? 1 : 0,
              child: Icon(
                Icons.done,
                color: useWhiteForeground(color) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    _currentColor = widget.pickerColor;
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) => widget.layoutBuilder(
        context,
        widget.availableColors,
        (color, [_, __]) => widget.itemBuilder(
          color,
          () => changeColor(color),
          isCurrentColor: _currentColor.value == color.value,
        ),
      );
}

bool useWhiteForeground(Color color, {double bias = 1}) {
  final v = sqrt(pow(color.red, 2) * 0.299 +
          pow(color.green, 2) * 0.587 +
          pow(color.blue, 2) * 0.114)
      .round();
  if (v < 130 * bias) {
    return true;
  } else {
    return false;
  }
}
