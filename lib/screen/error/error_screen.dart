import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.language.error),
      ),
      body: const Center(
        child: Text('Are you lost baby girl ?'),
      ),
    );
  }
}
