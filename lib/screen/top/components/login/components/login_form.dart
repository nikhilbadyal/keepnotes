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
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            buildEmailFormField(),
            const SizedBox(
              height: 15,
            ),
            buildPasswordFormField(),
            const SizedBox(
              height: 25,
            ),
            InkWell(
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
            InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  unawaited(
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (final context) {
                        return SpinKitCubeGrid(
                          color: context.secondaryColor,
                          size: context.mq.size.height * 0.1,
                        );
                      },
                    ),
                  );
                  _formKey.currentState!.save();
                  hideKeyboard(context);
                  final response =
                      await context.firebaseAuth.signInWithPassword(
                    email: email,
                    password: password,
                  );
                  if (!mounted) {
                    return;
                  }

                  if (context.firebaseAuth.isLoggedIn) {
                    context.appConfig.password = initialize(
                      context.firebaseAuth.auth.currentUser,
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
                  shadowColor: lighten(context.secondaryColor, 20),
                  color: context.secondaryColor,
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
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      onSaved: (final newValue) => password = newValue ?? '',
      onChanged: (final value) {
        if (value.isNotEmpty) {
          removeError(error: context.language.enterPassword);
        } else if (value.length >= minPassword) {
          removeError(error: context.language.shortPassword);
        }
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
        border: InputBorder.none,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      onSaved: (final newValue) => email = newValue ?? '',
      onChanged: (final value) {
        if (value.isNotEmpty) {
          removeError(error: context.language.enterEmail);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: context.language.invalidEmail);
        }
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
        labelText: context.language.enterEmail,
        hintText: context.language.email,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: InputBorder.none,
      ),
    );
  }
}
