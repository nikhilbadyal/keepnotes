import 'package:notes/util/_util.dart';
import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';

class Circle extends StatefulWidget {
  const Circle({
    required this.isFilled,
    required this.size,
    Key? key,
  }) : super(key: key);

  final bool isFilled;
  final double size;

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: widget.size),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: widget.isFilled
              ? Provider.of<AppConfiguration>(context, listen: false)
                          .appTheme ==
                      AppTheme.Light
                  ? Provider.of<AppConfiguration>(context, listen: false)
                      .primaryColor
                  : Colors.white
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: Provider.of<AppConfiguration>(context, listen: false)
                          .appTheme ==
                      AppTheme.Light
                  ? Provider.of<AppConfiguration>(context, listen: false)
                      .primaryColor
                  : Colors.white,
              width: 2),
        ),
      );
  }
}
