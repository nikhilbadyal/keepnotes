import 'package:notes/_appPackages.dart';
import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';


Widget login(
    BuildContext context,
    double _loginWidth,
    double _loginHeight,
    double _loginYOffset,
    double _loginXOffset,
    double _loginOpacity,
    GlobalKey<FormState> loginKey,
    NotesUser user,
    String Function() passwordRegEx,
    Function() loginTap,
    Function() goToSignupTap) {
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
                    onSaved: (val) {
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
                    onSaved: (val) {
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
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.transparent;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        '/forgot',
                      );
                      // navigate('/login', context, '/forgot');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
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
                /*const OutlineBtnNew(
                  btnText: 'Create New Account',

                )*/
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
