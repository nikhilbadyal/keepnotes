//24-11-2021 11:53 PM
import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class AppBarAvatar extends StatefulWidget {
  const AppBarAvatar({this.onWidgetTap, final Key? key}) : super(key: key);

  final Function()? onWidgetTap;

  @override
  _AppBarAvatarState createState() => _AppBarAvatarState();
}

class _AppBarAvatarState extends State<AppBarAvatar> {
  late Widget _animatedChild;
  var gender = getStringFromSF('gender') ?? 'men';

  @override
  void initState() {
    _animatedChild = child(Key(gender));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
    onDoubleTap: widget.onWidgetTap ?? defaultDoubleTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 6, top: 4),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 22,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _animatedChild,
        ),
      ),
    ),
  );

  void defaultDoubleTap() {
    setState(() {
      if (gender == 'men') {
        gender = 'women';
      } else {
        gender = 'men';
      }
      _animatedChild = child(Key(gender));
    });
    addStringToSF('gender', gender);
  }

  Widget child(final Key key) {
    return CircleAvatar(
      key: key,
      radius: 20,
      backgroundColor: Colors.white,
      backgroundImage: AssetImage(
        'assets/images/$gender.png',
      ),
    );
  }
}
