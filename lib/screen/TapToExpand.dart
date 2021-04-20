import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomWidget extends StatefulWidget {
  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimCard(
        Theme.of(context).primaryColor,
        '',
        '',
        '',
      ),
    );
  }
}

class AnimCard extends StatefulWidget {
  const AnimCard(this.color, this.num, this.numEng, this.content);

  final Color color;
  final String num;
  final String numEng;
  final String content;

  @override
  _AnimCardState createState() => _AnimCardState();
}

class _AnimCardState extends State<AnimCard> {
  var padding = 150.0;
  var bottomPadding = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPadding(
            padding: EdgeInsets.only(top: padding, bottom: bottomPadding),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn,
            child: SizedBox(
              child: CardItem(
                widget.color,
                widget.num,
                widget.numEng,
                widget.content,
                () {
                  setState(() {
                    padding = padding == 0 ? 150.0 : 0.0;
                    bottomPadding = bottomPadding == 0 ? 150 : 0.0;
                  });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 20, left: 20, top: 200),
              height: 180,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2), blurRadius: 30)
                ],
                color: Colors.grey.shade200.withOpacity(1.0),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Icon(Icons.favorite,
                    color: Theme.of(context).primaryColor.withOpacity(1.0),
                    size: 70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem(this.color, this.num, this.numEng, this.content, this.onTap);

  final Color color;
  final String num;
  final String numEng;
  final String content;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        height: 220,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 25),
          ],
          color: color.withOpacity(1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: const [
                Text(
                  'Tap to view more',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'The app was developed with privacy and security'
                  ' as the main focus. Personal details should remain '
                  'personal.\n\n'
                  'Many users start being skeptical when '
                  'an app requests for an internet permission. So '
                  'I decided to keep this app privacy friendly and '
                  'hence it doesn\'t have internet. \n\nEverything sounds '
                  'sweet sweet until you realize that this is an '
                  'offline app and you need to take care of your '
                  'notes by yourself.\n\nRemember - If you forget your password. '
                  'No one can help you.Not even me.\n\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
