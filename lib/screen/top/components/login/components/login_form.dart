//24-11-2021 09:02 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

final RegExp emailValidatorRegExp =
    RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

class SignForm extends StatefulWidget {
  const SignForm({
    final Key? key,
  }) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  final List<String?> errors = [];

  void addError({
    final String? error,
  }) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({
    final String? error,
  }) {
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
          const SizedBox(
            height: 25,
          ),
          buildPasswordFormField(),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () => context.nextPage(AppRoutes.forgotPasswordScreen),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                context.language.forgotPassword,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                unawaited(
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (final context) {
                      return SpinKitCubeGrid(
                        color: context.theme.colorScheme.secondary,
                        size: context.mq.size.height * 0.1,
                      );
                    },
                  ),
                );
                _formKey.currentState!.save();
                hideKeyboard(context);
                final response = await Provider.of<Auth>(
                  context,
                  listen: false,
                ).signInWithPassword(
                  email: email,
                  password: password,
                );
                if (!mounted) {
                  return;
                }

                if (Provider.of<Auth>(
                  context,
                  listen: false,
                ).isLoggedIn) {
                  Provider.of<AppConfiguration>(context, listen: false)
                      .password = initialize(
                    Provider.of<Auth>(context, listen: false).auth.currentUser,
                  );
                  await Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.homeScreen,
                    (final route) => false,
                  );
                } else {
                  context.previousPage();
                  handleFirebaseError(
                    response,
                    context,
                  );
                }
              }
            },
            child: SizedBox(
              height: 53,
              child: Material(
                borderRadius: BorderRadius.circular(25),
                shadowColor: lighten(context.theme.colorScheme.secondary, 20),
                color: context.theme.colorScheme.secondary,
                elevation: 7,
                child: Center(
                  child: Text(
                    context.language.login,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Trueno',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (final newValue) => password = newValue ?? '',
      onChanged: (final value) {
        if (value.isNotEmpty) {
          removeError(error: context.language.enterPassword);
        } else if (value.length >= minPassword) {
          removeError(error: context.language.shortPassword);
        }
        return;
      },
      validator: (final value) {
        if (value!.isEmpty) {
          addError(error: context.language.enterPassword);
          return '';
        } else if (value.length < minPassword) {
          addError(error: context.language.shortPassword);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: context.language.password,
        hintText: context.language.enterPassword,
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
          removeError(error: context.language.enterEmail);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: context.language.invalidEmail);
        }
        return;
      },
      validator: (final value) {
        if (value!.isEmpty) {
          addError(error: context.language.enterEmail);
          return '';
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: context.language.invalidEmail);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: context.language.email,
        hintText: context.language.enterEmail,
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
      padding: const EdgeInsets.fromLTRB(
        0,
        28,
        28,
        28,
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: 28,
      ),
    );
  }
}
