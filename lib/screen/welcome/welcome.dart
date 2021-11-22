import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Welcome extends StatefulWidget {
  const Welcome({final Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _pageState = 0;
  var loginKey = GlobalKey<FormState>();
  var signupKey = GlobalKey<FormState>();
  final user = NotesUser(
    name: '',
    email: '',
    password: '',
  );

  late Color _backgroundColor;
  late Color _headingColor;

  double _headingTop = 100;

  double _loginWidth = 0;
  KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  late StreamSubscription onChangeSub;

  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;

  @override
  void dispose() {
    super.dispose();
    onChangeSub.cancel();
  }

  @override
  void initState() {
    super.initState();
    onChangeSub = keyboardVisibilityController.onChange.listen((final visible) {
      if (mounted) {
        setState(() {
          _keyboardVisible = visible;
        });
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    _backgroundColor = Theme.of(context).canvasColor;
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;
    switch (_pageState) {
      case 0:
        setCase0();
        break;
      case 1:
        setCase1();
        break;
      case 2:
        setCase2();
        break;
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Home(_backgroundColor, onHomeTap, onGetStartTap, _headingTop,
              _headingColor),
          Login(
              _loginWidth,
              _loginHeight,
              _loginYOffset,
              _loginXOffset,
              _loginOpacity,
              loginKey,
              user,
              passwordRegEx,
              loginOnTap,
              goToSignupTap),
          SignUp(_registerHeight, _registerYOffset, signupKey, user,
              passwordRegEx, createAccountOnTap, goToLoginOnTap),
        ],
      ),
    );
  }

  void onHomeTap() {
    setState(() {
      signupKey = GlobalKey<FormState>();
      loginKey = GlobalKey<FormState>();
      if (_pageState != 0) {
        _pageState = 0;
      }
    });
  }

  void goToSignupTap() {
    setState(() {
      signupKey = GlobalKey<FormState>();
      loginKey = GlobalKey<FormState>();
      _pageState = 2;
    });
  }

  void goToLoginOnTap() {
    setState(() {
      signupKey = GlobalKey<FormState>();
      loginKey = GlobalKey<FormState>();
      _pageState = 1;
    });
  }

  void onGetStartTap() {
    setState(() {
      signupKey = GlobalKey<FormState>();
      loginKey = GlobalKey<FormState>();
      if (_pageState != 0) {
        _pageState = 0;
      } else {
        _pageState = 1;
      }
    });
  }

  String passwordRegEx() {
    return r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])\S{8,}$';
  }

  Future<void> createAccountOnTap() async {
    if (signupKey.currentState?.validate() ?? false) {
      final spinkit = SpinKitCubeGrid(
        color: Theme.of(context).colorScheme.secondary,
        size: MediaQuery.of(context).size.height * 0.1,
      );
      unawaited(
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (final _) {
            return spinkit;
          },
        ),
      );
      signupKey.currentState?.save();
      final response = await Provider.of<Auth>(
        context,
        listen: false,
      ).singUp(
        user: user,
      );
      Navigator.of(context).pop();

      if (response == 'success') {
        Utilities.showSnackbar(context, Language.of(context).checkEmail);
        setState(() {
          _pageState = 1;
        });
      } else {
        handleError(
          response,
          context,
        );
      }
    } else {
      Utilities.showSnackbar(context, Language.of(context).insufficientData);
    }
  }

  Future<void> loginOnTap() async {
    if (loginKey.currentState!.validate() || true) {
      final spinkit = SpinKitCubeGrid(
        color: Theme.of(context).colorScheme.secondary,
        size: MediaQuery.of(context).size.height * 0.1,
      );

      unawaited(showDialog(
        barrierDismissible: false,
        context: context,
        builder: (final _) {
          return spinkit;
        },
      ));
      loginKey.currentState?.save();
      final response = await Provider.of<Auth>(
        context,
        listen: false,
      ).signInWithPassword(
        email: user.email,
        password: user.password,
      );
      if (Provider.of<Auth>(
        context,
        listen: false,
      ).isLoggedIn) {
        Utilities.initialize(context);
        // unawaited(syncNotes(context));
        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.homeScreen, (final route) => false);
      } else {
        Navigator.of(context).pop();
        handleError(
          response,
          context,
        );
      }
      // ignore: dead_code
    } else {
      Utilities.showSnackbar(context, Language.of(context).insufficientData);
    }
  }

  void setCase0() {
    _backgroundColor = Theme.of(context).canvasColor;
    _headingColor = Theme.of(context).colorScheme.secondary;
    _headingTop = windowHeight * 0.1;
    _loginWidth = windowWidth;
    _loginOpacity = 1;
    _loginYOffset = windowHeight;
    _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

    _loginXOffset = 0;
    _registerYOffset = windowHeight;
  }

  void setCase1() {
    _headingColor = Theme.of(context).canvasColor;
    _backgroundColor = Theme.of(context).colorScheme.secondary;

    _headingTop = 90;

    _loginWidth = windowWidth;
    _loginOpacity = 1;

    _loginYOffset = _keyboardVisible ? 40 : 270;
    _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
    _loginXOffset = 0;
    _registerYOffset = windowHeight;
  }

  void setCase2() {
    _backgroundColor = Theme.of(context).colorScheme.secondary;
    _headingColor = Theme.of(context).canvasColor;
    _headingTop = 80;
    _loginWidth = windowWidth - 40;
    _loginOpacity = 0.7;

    _loginYOffset = _keyboardVisible ? 30 : 240;
    _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

    _loginXOffset = 20;
    _registerYOffset = _keyboardVisible ? 55 : 270;
    _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
  }
}

class InputWithIcon extends StatefulWidget {
  const InputWithIcon({
    required this.icon,
    required this.textFormField,
    final Key? key,
  }) : super(
          key: key,
        );
  final IconData icon;
  final TextFormField textFormField;

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          SizedBox(
              width: 60,
              child: Icon(
                widget.icon,
                size: 20,
                color: Colors.grey[400] ?? Colors.grey,
              )),
          Expanded(
            child: widget.textFormField,
          )
        ],
      ),
    );
  }
}

void handleError(final String response, final BuildContext context) {
  if (response == 'user-not-found' || response == 'auth/user-not-found') {
    Utilities.showSnackbar(context, Language.of(context).signUp);
  } else if (response == 'invalid-email' || response == 'auth/invalid-email') {
    Utilities.showSnackbar(context, Language.of(context).checkEmail);
  } else if (response == 'wrong-password') {
    Utilities.showSnackbar(context, Language.of(context).wrongPassword);
  } else if (response == 'account-exists-with-different-credential') {
    Utilities.showSnackbar(context, Language.of(context).accountAlreadyExist);
  } else if (response == 'email-already-in-use') {
    Utilities.showSnackbar(context, Language.of(context).emailAlreadyExist);
  } else if (response == 'invalid-email') {
    Utilities.showSnackbar(context, Language.of(context).invalidEmail);
  } else if (response == 'email-not-verified') {
    Utilities.showSnackbar(context, Language.of(context).verifyEmail);
  } else if (response == 'weak-password') {
    Utilities.showSnackbar(context, Language.of(context).weakPassword);
  } else if (response == 'too-many-requests') {
    Utilities.showSnackbar(context, Language.of(context).tryAgainLater);
  } else {
    Utilities.showSnackbar(context, Language.of(context).contactUs);
  }
}
