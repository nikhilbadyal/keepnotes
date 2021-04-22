import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 16),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => launch('https://t.me/joinchat/uGAlVliNij1hZTFl'),
            child: Image.asset('assets/images/telegram.png'),
          ),
          GestureDetector(
              onTap: () =>
                  launch('https://github.com/ProblematicDude/keep-safe-notes'),
              child: Image.asset('assets/images/github.png')),
        ],
      ),
    );
  }
}
