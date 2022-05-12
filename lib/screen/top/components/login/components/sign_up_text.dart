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
          context.language.noAccount,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        InkWell(
          onTap: () => context.nextPage(AppRoutes.signUpScreen),
          child: Text(
            context.language.signUp,
            style: TextStyle(
              fontSize: 16,
              color: context.theme.colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
