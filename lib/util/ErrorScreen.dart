// In case something messes up. I hope no one come across this
import 'package:flutter/material.dart';
import 'package:notes/util/Languages/Languages.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Languages.of(context).error),
      ),
      body: const Center(
        child: Text('Are you lost baby girl ?'),
      ),
    );
  }
}
