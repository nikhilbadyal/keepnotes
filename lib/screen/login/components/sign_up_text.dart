//24-11-2021 09:06 PM
import 'package:flutter/material.dart';
import 'package:notes/_app_packages.dart';

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
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.signUpScreen),
          child: Text(
            Language.of(context).signUp,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}
