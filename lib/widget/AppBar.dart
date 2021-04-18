import 'package:flutter/material.dart';
import 'package:notes/app.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar(
      {Key? key, required this.title, this.appBarWidget = const AppBarAvatar()})
      : super(key: key);

  final Widget title;
  final Widget appBarWidget;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  AppBar build(BuildContext context) {
    return AppBar(elevation: 0.6, title: widget.title, actions: [
      widget.appBarWidget,
    ]);
  }
}

class AppBarAvatar extends StatefulWidget {
  const AppBarAvatar({this.onWidgetTap});

  final Function()? onWidgetTap;

  @override
  _AppBarAvatarState createState() => _AppBarAvatarState();
}

class _AppBarAvatarState extends State<AppBarAvatar> {
  late Widget _animatedChild;

  @override
  void initState() {
    _animatedChild = child(Key(myNotes.lockChecker.gender));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onWidgetTap ?? defaultDoubleTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 25,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _animatedChild,
        ),
      ),
    );
  }

  void defaultDoubleTap() {
    setState(() {
      if (myNotes.lockChecker.gender == 'men') {
        myNotes.lockChecker.gender = 'women';
      } else {
        myNotes.lockChecker.gender = 'men';
      }
      _animatedChild = child(Key(myNotes.lockChecker.gender));
    });
    myNotes.lockChecker.addGenderToSf();
  }

  Widget child(Key key) {
    return CircleAvatar(
      key: key,
      radius: 22,
      backgroundColor: Colors.white,
      backgroundImage: AssetImage(
        'assets/images/${myNotes.lockChecker.gender}.png',
      ),
    );
  }
}
