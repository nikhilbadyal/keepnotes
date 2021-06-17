import 'package:flutter/cupertino.dart';
import 'package:notes/_appPackages.dart';
import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _pageState = 0;
  final loginKey = GlobalKey<FormState>();
  final signupKey = GlobalKey<FormState>();
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
    onChangeSub = keyboardVisibilityController.onChange.listen((visible) {
      if (mounted) {
        setState(() {
          _keyboardVisible = visible;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          home(context, _backgroundColor, onScreenTap, onGetStartTap,
              _headingTop, _headingColor),
          login(
              context,
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
          signup(context, _registerHeight, _registerYOffset, signupKey, user,
              passwordRegEx, createAccountOnTap, goToLoginOnTap),
        ],
      ),
    );
  }

  void onScreenTap() {
    setState(() {
      if (_pageState != 0) {
        _pageState = 0;
      }
    });
  }

  void goToSignupTap() {
    setState(() {
      _pageState = 2;
    });
  }

  void goToLoginOnTap() {
    setState(() {
      _pageState = 1;
    });
  }

  void onGetStartTap() {
    setState(() {
      if (_pageState != 0) {
        _pageState = 0;
      } else {
        _pageState = 1;
      }
    });
  }

  String passwordRegEx() {
    return '^(?=.*[A-Z].*[A-Z])(?=.'
        r'*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$';
  }

  Future<void> createAccountOnTap() async {
    if (signupKey.currentState?.validate() ?? false) {
      final spinkit = SpinKitCubeGrid(
        color: Theme.of(context).accentColor,
        size: MediaQuery.of(context).size.height * 0.1,
      );
      unawaited(
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
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
        Utilities.showSnackbar(
            context,
            'Registration '
            'successful. Please check your '
            'email to confirm your account');
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
      Utilities.showSnackbar(context, 'Please fill details properly');
    }
  }

  Future<void> loginOnTap() async {
    if (loginKey.currentState!.validate()) {
      final spinkit = SpinKitCubeGrid(
        color: Theme.of(context).accentColor,
        size: MediaQuery.of(context).size.height * 0.1,
      );

      unawaited(showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
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
        await Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (_) => const ScreenContainer(
                topScreen: ScreenTypes.Home,
              ),
            ),
            (route) => false);
      } else {
        Navigator.of(context).pop();
        handleError(
          response,
          context,
        );
      }
    } else {
      Utilities.showSnackbar(context, 'Please see errors above');
    }
  }

  void setCase0() {
    _backgroundColor = Theme.of(context).canvasColor;
    _headingColor = Theme.of(context).accentColor;
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
    _backgroundColor = Theme.of(context).accentColor;

    _headingTop = 90;

    _loginWidth = windowWidth;
    _loginOpacity = 1;

    _loginYOffset = _keyboardVisible ? 40 : 270;
    _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
    _loginXOffset = 0;
    _registerYOffset = windowHeight;
  }

  void setCase2() {
    _backgroundColor = Theme.of(context).accentColor;
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
    required this.hint,
    required this.textFormField,
    Key? key,
  }) : super(
          key: key,
        );
  final IconData icon;
  final String hint;
  final TextFormField textFormField;

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
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

void handleError(String response, BuildContext context) {
  logger.wtf(response);
  if (response == 'user-not-found' || response == 'auth/user-not-found') {
    Utilities.showSnackbar(context, 'Please Sign up first');
  } else if (response == 'invalid-email' || response == 'auth/invalid-email') {
    Utilities.showSnackbar(context, 'Check your email');
  } else if (response == 'wrong-password') {
    Utilities.showSnackbar(context, 'Wrong password');
  } else if (response == 'account-exists-with-different-credential') {
    Utilities.showSnackbar(context, 'Account already exist ');
  } else if (response == 'email-already-in-use') {
    Utilities.showSnackbar(context, 'Email Already in use');
  } else if (response == 'invalid-email') {
    Utilities.showSnackbar(context, 'Invalid Email id');
  } else if (response == 'email-not-verified') {
    Utilities.showSnackbar(context, 'Verify email first');
  } else if (response == 'weak-password') {
    Utilities.showSnackbar(context, 'Please choose a strong password');
  } else if (response == 'too-many-requests') {
    Utilities.showSnackbar(context, 'Too may requests. Try again later');
  } else {
    Utilities.showSnackbar(
        context, 'Something bad happened. Please contact us');
  }
}
