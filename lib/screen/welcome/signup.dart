import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SignUp extends StatefulWidget {
  const SignUp(
    this.registerHeight,
    this.registerYOffset,
    this.signupKey,
    this.user,
    this.passwordRegEx,
    this.createAccountOnTap,
    this.goToLoginOnTap, {
    final Key? key,
  }) : super(key: key);
  final double registerHeight;
  final double registerYOffset;
  final GlobalKey<FormState> signupKey;
  final NotesUser user;
  final String Function() passwordRegEx;
  final Function() createAccountOnTap;
  final Function() goToLoginOnTap;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      height: widget.registerHeight,
      padding: const EdgeInsets.all(32),
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(0, widget.registerYOffset, 1),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: widget.signupKey,
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      Language.of(context).createNewAccount,
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
                        Validators.required(Language.of(context).required),
                        Validators.patternRegExp(
                            RegExp(widget.passwordRegEx()),
                            'Please meet the following criteria\n'
                            '6 characters min\n'
                            '1 upper,lower & special'),
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
                        await navigate(AppRoutes.welcomeScreen, context,
                            AppRoutes.forgotPasswordScreen);
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
                    btnText: Language.of(context).createNewAccount,
                    onTap: widget.createAccountOnTap,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlineBtn(
                    btnText: Language.of(context).backToLogin,
                    onTap: widget.goToLoginOnTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
