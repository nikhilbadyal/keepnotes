import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class Circle extends StatefulWidget {
  const Circle({
    required this.isFilled,
    required this.size,
    final Key? key,
  }) : super(key: key);

  final bool isFilled;
  final double size;

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(final BuildContext context) {
    final primaryColor =
        Color(getIntFromSF('primaryColor') ?? defaultPrimary.value);
    final appTheme = AppTheme.values[getIntFromSF('appTheme') ?? 0];
    return Container(
      margin: EdgeInsets.only(bottom: widget.size),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: widget.isFilled
            ? appTheme == AppTheme.light
                ? primaryColor
                : Colors.white
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
            color: appTheme == AppTheme.light ? primaryColor : Colors.white,
            width: 2),
      ),
    );
  }
}
