import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Login extends StatefulWidget {
  const Login(
      this.loginWidth,
      this.loginHeight,
      this.loginYOffset,
      this.loginXOffset,
      this.loginOpacity,
      this.loginKey,
      this.user,
      this.passwordRegEx,
      this.loginTap,
      this.goToSignupTap,
      {final Key? key})
      : super(key: key);

  final double loginWidth;
  final double loginHeight;
  final double loginYOffset;
  final double loginXOffset;
  final double loginOpacity;
  final GlobalKey<FormState> loginKey;
  final NotesUser user;
  final String Function() passwordRegEx;
  final Function() loginTap;
  final Function() goToSignupTap;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(32),
      width: widget.loginWidth,
      height: widget.loginHeight,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(
          widget.loginXOffset, widget.loginYOffset, 1),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.withOpacity(widget.loginOpacity),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: widget.loginKey,
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      Language.of(context).loginToContinue,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  InputWithIcon(
                    icon: Icons.email,
                    textFormField: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (final val) {
                        widget.user.email = val ?? '';
                      },
                      validator: Validators.compose([
                        Validators.email(Language.of(context).checkEmail),
                        Validators.required(Language.of(context).required),
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
                    textFormField: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (final val) {
                        widget.user.password = val ?? '';
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
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
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
                        Language.of(context).forgotPassword,
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
                    btnText: Language.of(context).login,
                    onTap: widget.loginTap,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlineBtn(
                    btnText: Language.of(context).createNewAccount,
                    onTap: widget.goToSignupTap,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
Widget Login(
    final double loginWidth,
    final double loginHeight,
    final double loginYOffset,
    final double loginXOffset,
    final double loginOpacity,
    final GlobalKey<FormState> loginKey,
    final NotesUser user,
    final String Function() passwordRegEx,
    final Function() loginTap,
    final Function() goToSignupTap) {
  return AnimatedContainer(
    padding: const EdgeInsets.all(32),
    width: loginWidth,
    height: loginHeight,
    curve: Curves.fastLinearToSlowEaseIn,
    duration: const Duration(milliseconds: 1000),
    transform: Matrix4.translationValues(loginXOffset, loginYOffset, 1),
    decoration: BoxDecoration(
      color: Theme.of(context).canvasColor.withOpacity(loginOpacity),
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
                  child: Text(
                    Language.of(context).loginToContinue,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                InputWithIcon(
                  icon: Icons.email,
                  textFormField: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (final val) {
                      user.email = val ?? '';
                    },
                    validator: Validators.compose([
                      Validators.email(Language.of(context).checkEmail),
                      Validators.required(Language.of(context).required),
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
                      Language.of(context).forgotPassword,
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
                  btnText: Language.of(context).login,
                  onTap: loginTap,
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlineBtn(
                  btnText: Language.of(context).createNewAccount,
                  onTap: goToSignupTap,
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}*/
