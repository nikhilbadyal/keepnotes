import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    final Key? key,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  context.language.registerAccount,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: context.bodyText1,
                    height: 1.5,
                  ),
                ),
                Text(
                  context.language.signUpJustification,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),
                const SignUpForm(),
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
                Text(
                  context.language.totalPrivacy,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
