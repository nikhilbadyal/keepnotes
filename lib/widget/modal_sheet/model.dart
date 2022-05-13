import 'package:notes/_internal_packages.dart';

abstract class ModalSheetWidgets extends StatelessWidget {
  const ModalSheetWidgets({
    required this.onTap,
    required this.icon,
    required this.label,
    final Key? key,
  }) : super(key: key);
  final Function()? onTap;
  final IconData icon;
  final String label;
}
