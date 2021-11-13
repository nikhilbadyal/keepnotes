import 'package:notes/_internal_packages.dart';

// ignore: must_be_immutable
abstract class AbstractSection extends StatelessWidget {
  AbstractSection({Key? key, this.title, this.titlePadding}) : super(key: key);
  bool showBottomDivider = false;
  final String? title;

  final EdgeInsetsGeometry? titlePadding;
}
