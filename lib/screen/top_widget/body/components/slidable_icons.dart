//30-11-2021 03:05 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget slidableAction(
  final String label,
  final Color foregroundColor,
  final Note note,
  final IconData icon,
  final OnBuildContextTap onPressed,) {
  return SlidableAction(
    autoClose: false,
    icon: icon,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: onPressed,
  );
}
