import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/screen/sign_up/components/sign_up_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({final Key? key}) : super(key: key);

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
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text(Language.of(context).registerAccount,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      height: 1.5,
                    )),
                Text(
                  Language.of(context).signUpJustification,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                const SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: googleIcon,
                      press: () async {
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
                          initialize(context);
                          await Navigator.pushNamedAndRemoveUntil(context,
                              AppRoutes.homeScreen, (final route) => false);
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
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  Language.of(context).totalPrivacy,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
