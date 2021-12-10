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
        padding: EdgeInsets.symmetric(
          horizontal: 7 * SizeConfig.widthMultiplier,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),
              Text(
                Language.of(context).loginToContinue,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 3 * textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Language.of(context).loginExplaination,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 1.8 * textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              const SignForm(),
              SizedBox(height: screenHeight * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialCard(
                    icon: googleIcon,
                    press: () async {
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
                      final response = await Provider.of<Auth>(
                        context,
                        listen: false,
                      ).signInWithGoogle();
                      if (!mounted) {
                        return;
                      }

                      if (Provider.of<Auth>(
                        context,
                        listen: false,
                      ).isLoggedIn) {
                        Provider.of<AppConfiguration>(context, listen: false)
                            .password = initialize(
                          Provider.of<Auth>(context, listen: false)
                              .auth
                              .currentUser,
                        );
                        await Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.homeScreen,
                          (final route) => false,
                        );
                      } else {
                        Navigator.of(context).pop();
                        handleFirebaseError(
                          response,
                          context,
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 2.8 * heightMultiplier,
              ),
              const NoAccountText(),
            ],
          ),
        ),
      ),
    );
  }
}
