import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    final Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String? conformPassword;
  bool remember = false;
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
          buildConformPassFormField(),
          FormError(errors: errors),
          const SizedBox(
            height: 44,
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
                        color: Theme.of(context).colorScheme.secondary,
                        size: MediaQuery.of(context).size.height * 0.1,
                      );
                    },
                  ),
                );
                _formKey.currentState!.save();
                final response = await Provider.of<Auth>(
                  context,
                  listen: false,
                ).singUp(email: email, password: password);
                if (!mounted) {
                  return;
                }

                Navigator.of(context).pop();

                if (response == 'success') {
                  showSnackbar(context, Language.of(context).checkEmail);
                } else {
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
                shadowColor:
                    lighten(Theme.of(context).colorScheme.secondary, 20),
                color: Theme.of(context).colorScheme.secondary,
                elevation: 7,
                child: Center(
                  child: Text(
                    Language.of(context).signUp,
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

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (final newValue) => conformPassword = newValue,
      onChanged: (final value) {
        if (value.isNotEmpty) {
          removeError(error: Language.of(context).enterPassword);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: Language.of(context).passwordNotMatch);
        }
        conformPassword = value;
      },
      validator: (final value) {
        if (value!.isEmpty) {
          addError(error: Language.of(context).enterPassword);
          return '';
        } else if (password != value) {
          addError(error: Language.of(context).passwordNotMatch);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: Language.of(context).confirmPassword,
        hintText: Language.of(context).reEnterPassword,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSuffixIcon(svgIcon: lockSvg),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (final newValue) => password = newValue ?? '',
      onChanged: (final value) {
        if (value.isNotEmpty) {
          removeError(error: Language.of(context).enterPassword);
        } else if (value.length >= minPassword) {
          removeError(error: Language.of(context).shortPassword);
        }
        password = value;
      },
      validator: (final value) {
        if (value!.isEmpty) {
          addError(error: Language.of(context).enterPassword);
          return '';
        } else if (value.length < minPassword) {
          addError(error: Language.of(context).shortPassword);
          return '';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: lockSvg),
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
