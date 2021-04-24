import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';

class ErrorModalSheet extends StatelessWidget {
  const ErrorModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        child: Text(Language.of(context).error),
      );
}
