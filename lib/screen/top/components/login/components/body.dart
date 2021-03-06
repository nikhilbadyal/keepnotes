//24-11-2021 08:59 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Login extends StatefulWidget {
  const Login({
    final Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                context.language.loginToContinue,
                style: TextStyle(
                  color: context.bodyText1,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                context.language.loginExplaination,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.bodyText1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              const SignForm(),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialCard(
                    icon: google,
                    press: () async {
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
                      final response =
                          await context.firebaseAuth.signInWithGoogle();
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
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const NoAccountText(),
            ],
          ),
        ),
      ),
    );
  }
}
