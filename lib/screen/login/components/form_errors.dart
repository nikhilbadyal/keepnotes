//24-11-2021 09:08 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class FormError extends StatelessWidget {
  const FormError({
    required this.errors,
    final Key? key,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (final index) => formErrorText(error: errors[index]!)),
    );
  }

  Row formErrorText({required final String error}) {
    return Row(
      children: [
        SvgPicture.asset(
          errorSvg,
          height: getProportionateScreenWidth(14),
          width: getProportionateScreenWidth(14),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Text(error),
      ],
    );
  }
}
