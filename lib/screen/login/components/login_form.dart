//24-11-2021 09:02 PM
import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

class SignForm extends StatefulWidget {
  const SignForm({final Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  final List<String?> errors = [];

  void addError({final String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({final String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.forgotPasswordScreen),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                Language.of(context).forgotPassword,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: Language.of(context).login,
            press: () async {
              if (_formKey.currentState!.validate()) {
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
                _formKey.currentState!.save();
                hideKeyboard(context);
                final response = await Provider.of<Auth>(
                  context,
                  listen: false,
                ).signInWithPassword(
                  email: email,
                  password: password,
                );
                if (Provider.of<Auth>(
                  context,
                  listen: false,
                ).isLoggedIn) {
                  Utilities.initialize(context);
                  await Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.homeScreen, (final route) => false);
                } else {
                  Navigator.of(context).pop();
                  handleError(
                    response,
                    context,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void hideKeyboard(final BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (final newValue) => password = newValue ?? '',
      onChanged: (final value) {
        if (value.isNotEmpty) {
          removeError(error: Language.of(context).enterPassword);
        } else if (value.length >= 8) {
          removeError(error: Language.of(context).shortPassword);
        }
        return;
      },
      validator: (final value) {
        if (value!.isEmpty) {
          addError(error: Language.of(context).enterPassword);
          return '';
        } else if (value.length < 8) {
          addError(error: Language.of(context).shortPassword);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: Language.of(context).password,
        hintText: Language.of(context).enterPassword,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSuffixIcon(svgIcon: lockSvg),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (final newValue) => email = newValue ?? '',
      onChanged: (final value) {
        if (value.isNotEmpty) {
          removeError(error: Language.of(context).enterEmail);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: Language.of(context).invalidEmail);
        }
        return;
      },
      validator: (final value) {
        if (value!.isEmpty) {
          addError(error: Language.of(context).enterEmail);
          return '';
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: Language.of(context).invalidEmail);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: Language.of(context).email,
        hintText: Language.of(context).enterEmail,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSuffixIcon(svgIcon: mailSvg),
      ),
    );
  }
}

class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({
    required this.svgIcon,
    final Key? key,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenWidth(18),
      ),
    );
  }
}
