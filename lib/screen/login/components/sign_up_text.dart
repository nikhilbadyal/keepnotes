//24-11-2021 09:06 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Language.of(context).noAccount,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.signUpScreen),
          child: Text(
            Language.of(context).signUp,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
