import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Language.of(context).error),
        ),
        body: const Center(
          child: Text('Are you lost baby girl ?'),
        ),
      );
}
