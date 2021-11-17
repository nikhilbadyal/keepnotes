import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();

  String? email, password;

  bool checkFields() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey,
            child: _buildLoginForm(),
          )),
    );
  }

  Padding _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: ListView(children: [
        const SizedBox(height: 75),
        SizedBox(
          height: 125,
          width: 200,
          child: Stack(
            children: [
              const Text(
                'Hello',
                style: TextStyle(fontFamily: 'Trueno', fontSize: 60),
              ),
              const Positioned(
                top: 50,
                child: Text(
                  'There',
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 60),
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
                    color: Theme.of(context).colorScheme.secondary,
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
                'EMAIL',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
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
          onSaved: (val) {
            email = val ?? '';
          },
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            labelText: 'EMAIL',
            labelStyle: TextStyle(
              fontFamily: 'Trueno',
              fontSize: 12,
              color: Colors.grey.withOpacity(0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          validator: Validators.compose([
            Validators.email('Invalid Email'),
            Validators.required('* Required'),
          ]),
        ),
        const SizedBox(height: 50),
        GestureDetector(
          onTap: () async {
            if (checkFields()) {
              final response = await Provider.of<Auth>(context, listen: false)
                  .forgetPassword(email: email ?? '');
              if (response != 'success') {
                handleError(response, context);
              }
              Utilities.showSnackbar(context, 'Check your email');
              await navigate(
                AppRoutes.forgotPasswordScreen,
                context,
                AppRoutes.welcomeScreen,
              );
            }
          },
          child: SizedBox(
            height: 50,
            child: Material(
              borderRadius: BorderRadius.circular(25),
              shadowColor: lighten(Theme.of(context).colorScheme.secondary, 20),
              color: Theme.of(context).colorScheme.secondary,
              elevation: 7,
              child: const Center(
                child: Text(
                  'RESET PASSWORD',
                  style: TextStyle(color: Colors.white, fontFamily: 'Trueno'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ]),
    );
  }
}
