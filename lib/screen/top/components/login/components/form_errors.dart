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
        errors.length,
        (final index) => formErrorText(error: errors[index]!),
      ),
    );
  }

  Widget formErrorText({
    required final String error,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SvgPicture.asset(
            errorSvg,
            height: 20,
            width: 20,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(error),
        ],
      ),
    );
  }
}
