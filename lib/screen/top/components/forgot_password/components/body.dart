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
      height: context.mq.size.height,
      width: context.mq.size.width,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: ListView(
            children: [
              const SizedBox(height: 75),
              SizedBox(
                height: 125,
                width: 200,
                child: Stack(
                  children: [
                    Text(
                      context.language.hello,
                      style: const TextStyle(
                        fontFamily: 'Trueno',
                        fontSize: 63,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      child: Text(
                        context.language.there,
                        style: const TextStyle(
                          fontFamily: 'Trueno',
                          fontSize: 63,
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
                          color: context.secondaryColor,
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
                      context.language.email,
                      style: TextStyle(
                        color: context.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
                  labelText: context.language.email,
                  labelStyle: TextStyle(
                    fontFamily: 'Trueno',
                    fontSize: 12,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.secondaryColor,
                    ),
                  ),
                ),
                validator: Validators.compose([
                  Validators.email(context.language.checkEmail),
                  Validators.required(context.language.required),
                ]),
              ),
              const SizedBox(height: 52),
              InkWell(
                onTap: () async {
                  if (checkFields()) {
                    final response = await context.firebaseAuth
                        .forgetPassword(email: email ?? '');
                    if (!mounted) {
                      return;
                    }

                    if (response != 'success') {
                      handleFirebaseError(response, context);
                    } else {
                      showSnackbar(context, context.language.checkEmail);
                    }
                    await navigate(
                      AppRoutes.forgotPasswordScreen,
                      context,
                      AppRoutes.introScreen,
                    );
                  }
                },
                child: SizedBox(
                  height: 52,
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    shadowColor: lighten(context.secondaryColor, 20),
                    color: context.secondaryColor,
                    elevation: 7,
                    child: Center(
                      child: Text(
                        context.language.resetPassword,
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
    showSnackbar(context, context.language.signUp);
  } else if (response == 'invalid-email' || response == 'auth/invalid-email') {
    showSnackbar(context, context.language.checkEmail);
  } else if (response == 'wrong-password') {
    showSnackbar(context, context.language.wrongPassword);
  } else if (response == 'account-exists-with-different-credential') {
    showSnackbar(context, context.language.accountAlreadyExist);
  } else if (response == 'email-already-in-use') {
    showSnackbar(context, context.language.emailAlreadyExist);
  } else if (response == 'invalid-email') {
    showSnackbar(context, context.language.invalidEmail);
  } else if (response == 'email-not-verified') {
    showSnackbar(context, context.language.verifyEmail);
  } else if (response == 'weak-password') {
    showSnackbar(context, context.language.weakPassword);
  } else if (response == 'too-many-requests') {
    showSnackbar(context, context.language.tryAgainLater);
  } else {
    showSnackbar(context, context.language.contactUs);
  }
}
