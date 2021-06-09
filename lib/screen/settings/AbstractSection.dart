import 'package:notes/_internalPackages.dart';

// ignore: must_be_immutable
abstract class AbstractSection extends StatelessWidget {
  AbstractSection({Key? key, this.title, this.titlePadding}) : super(key: key);
  bool showBottomDivider = false;
  final String? title;

  final EdgeInsetsGeometry? titlePadding;
}
