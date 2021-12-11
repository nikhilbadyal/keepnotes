import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    final Key? key,
  }) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  bool checkFields() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.41 * widthMultiplier),
          child: ListView(
            children: [
              const SizedBox(height: 75),
              SizedBox(
                height: 125,
                width: 200,
                child: Stack(
                  children: [
                    Text(
                      Language.of(context).hello,
                      style: TextStyle(
                        fontFamily: 'Trueno',
                        fontSize: 7.1 * textMultiplier,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      child: Text(
                        Language.of(context).there,
                        style: TextStyle(
                          fontFamily: 'Trueno',
                          fontSize: 7.1 * textMultiplier,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 97,
                      left: 175,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Language.of(context).email,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 1.79 * textMultiplier,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (final val) {
                  email = val ?? '';
                },
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  labelText: Language.of(context).email,
                  labelStyle: TextStyle(
                    fontFamily: 'Trueno',
                    fontSize: 1.44 * textMultiplier,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                validator: Validators.compose([
                  Validators.email(Language.of(context).checkEmail),
                  Validators.required(Language.of(context).required),
                ]),
              ),
              SizedBox(height: 5.88 * heightMultiplier),
              GestureDetector(
                onTap: () async {
                  if (checkFields()) {
                    final response =
                        await Provider.of<Auth>(context, listen: false)
                            .forgetPassword(email: email ?? '');
                    if (!mounted) {
                      return;
                    }

                    if (response != 'success') {
                      handleFirebaseError(response, context);
                    } else {
                      showSnackbar(context, Language.of(context).checkEmail);
                    }
                    await navigate(
                      AppRoutes.forgotPasswordScreen,
                      context,
                      AppRoutes.welcomeScreen,
                    );
                  }
                },
                child: SizedBox(
                  height: 5.88 * heightMultiplier,
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    shadowColor:
                        lighten(Theme.of(context).colorScheme.secondary, 20),
                    color: Theme.of(context).colorScheme.secondary,
                    elevation: 7,
                    child: Center(
                      child: Text(
                        Language.of(context).resetPassword,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Trueno',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

void handleFirebaseError(final String response, final BuildContext context) {
  debugPrint(response);
  if (response == 'user-not-found' || response == 'auth/user-not-found') {
    showSnackbar(context, Language.of(context).signUp);
  } else if (response == 'invalid-email' || response == 'auth/invalid-email') {
    showSnackbar(context, Language.of(context).checkEmail);
  } else if (response == 'wrong-password') {
    showSnackbar(context, Language.of(context).wrongPassword);
  } else if (response == 'account-exists-with-different-credential') {
    showSnackbar(context, Language.of(context).accountAlreadyExist);
  } else if (response == 'email-already-in-use') {
    showSnackbar(context, Language.of(context).emailAlreadyExist);
  } else if (response == 'invalid-email') {
    showSnackbar(context, Language.of(context).invalidEmail);
  } else if (response == 'email-not-verified') {
    showSnackbar(context, Language.of(context).verifyEmail);
  } else if (response == 'weak-password') {
    showSnackbar(context, Language.of(context).weakPassword);
  } else if (response == 'too-many-requests') {
    showSnackbar(context, Language.of(context).tryAgainLater);
  } else {
    showSnackbar(context, Language.of(context).contactUs);
  }
}
