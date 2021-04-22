import 'package:flutter/material.dart';
import 'package:notes/util/Languages/Languages.dart';

class ErrorModalSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(Languages.of(context).error),
    );
  }
}
