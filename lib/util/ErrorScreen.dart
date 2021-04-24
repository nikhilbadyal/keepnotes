// In case something messes up. I hope no one come across this
import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';

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
