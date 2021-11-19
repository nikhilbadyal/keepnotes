import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget login(
    final BuildContext context,
    final double _loginWidth,
    final double _loginHeight,
    final double _loginYOffset,
    final double _loginXOffset,
    final double _loginOpacity,
    final GlobalKey<FormState> loginKey,
    final NotesUser user,
    final String Function() passwordRegEx,
    final Function() loginTap,
    final Function() goToSignupTap) {
  return AnimatedContainer(
    padding: const EdgeInsets.all(32),
    width: _loginWidth,
    height: _loginHeight,
    curve: Curves.fastLinearToSlowEaseIn,
    duration: const Duration(milliseconds: 1000),
    transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
    decoration: BoxDecoration(
      color: Theme.of(context).canvasColor.withOpacity(_loginOpacity),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    child: SingleChildScrollView(
      child: Form(
        key: loginKey,
        child: Wrap(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'Login To Continue',
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
                    ]),
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
                      await Navigator.of(context)
                          .pushNamed(AppRoutes.forgotPasswordScreen);
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
                  btnText: 'Login',
                  onTap: loginTap,
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlineBtn(
                  btnText: 'Create New Account',
                  onTap: goToSignupTap,
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
