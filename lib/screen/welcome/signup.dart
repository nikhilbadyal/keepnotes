import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget signup(
    final BuildContext context,
    final double _registerHeight,
    final double _registerYOffset,
    final GlobalKey<FormState> signupKey,
    final NotesUser user,
    final String Function() passwordRegEx,
    final Function() createAccountOnTap,
    final Function() goToLoginOnTap) {
  return AnimatedContainer(
    height: _registerHeight,
    padding: const EdgeInsets.all(32),
    curve: Curves.fastLinearToSlowEaseIn,
    duration: const Duration(milliseconds: 1000),
    transform: Matrix4.translationValues(0, _registerYOffset, 1),
    decoration: BoxDecoration(
      color: Theme.of(context).canvasColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    child: SingleChildScrollView(
      child: Form(
        key: signupKey,
        child: Wrap(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'Create a New Account',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                InputWithIcon(
                  icon: Icons.email,
                  hint: 'Enter Email...',
                  textFormField: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (final val) {
                      user.email = val ?? '';
                    },
                    validator: Validators.compose([
                      Validators.email('Invalid Email'),
                      Validators.required('* Required'),
                    ]),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'example@domain.com',
                      hintStyle: TextStyle(
                        color: Colors.grey[500] ?? Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InputWithIcon(
                  icon: Icons.vpn_key,
                  hint: 'Enter Password...',
                  textFormField: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (final val) {
                      user.password = val ?? '';
                    },
                    validator: Validators.compose([
                      Validators.required('* Required'),
                      Validators.patternRegExp(
                          RegExp(passwordRegEx()),
                          'Please meet the following criteria\n'
                          '8 characters length\n'
                          '2 letters in Upper Case\n'
                          '1 Special Character\n'
                          '2 numerals (0-9)\n'
                          '3 letters in Lower Case\n')
                    ]),
                    // NIkhi@12
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(
                        color: Colors.grey[500] ?? Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 1),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (final states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.transparent;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    onPressed: () async {
                      await navigate(AppRoutes.welcomeScreen, context,
                          AppRoutes.forgotPasswordScreen);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                PrimaryButton(
                  btnText: 'Create Account',
                  onTap: createAccountOnTap,
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlineBtn(
                  btnText: 'Back To Login',
                  onTap: goToLoginOnTap,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
