//07-12-2021 11:37 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

bool useWhiteForeground(
  final Color backgroundColor,
) {
  final v = sqrt(
    pow(backgroundColor.red, 2) * 0.299 +
        pow(backgroundColor.green, 2) * 0.587 +
        pow(backgroundColor.blue, 2) * 0.114,
  ).round();
  return v < 130;
}

Widget defaultLayoutBuilder(
  final BuildContext context,
  final List<Color> colors,
  final PickerItem child,
) {
  final orientation = MediaQuery.of(context).orientation;

  return SizedBox(
    width: 300,
    height: orientation == Orientation.portrait ? 360 : 200,
    child: GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [for (Color color in colors) child(color)],
    ),
  );
}

Widget defaultItemBuilder(
  final Color color,
  final OnTap changeColor, {
  required final bool isCurrentColor,
}) {
  return Container(
    margin: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.8),
          offset: const Offset(1, 2),
          blurRadius: 5,
        )
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
}

class BlockPicker extends StatefulWidget {
  const BlockPicker({
    required this.pickerColor,
    required this.onColorChanged,
    required this.availableColors,
    this.layoutBuilder = defaultLayoutBuilder,
    this.itemBuilder = defaultItemBuilder,
    final Key? key,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() => _BlockPickerState();
}

class _BlockPickerState extends State<BlockPicker> {
  late Color _currentColor;

  @override
  void initState() {
    _currentColor = widget.pickerColor;
    super.initState();
  }

  void changeColor(final Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(final BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.availableColors,
      (final color, [final _, final __]) => widget.itemBuilder(
        color,
        () => changeColor(color),
        isCurrentColor: _currentColor.value == color.value,
      ),
    );
  }
}
