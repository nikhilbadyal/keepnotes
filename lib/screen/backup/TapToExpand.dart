import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';

class CardItem extends StatelessWidget {
  const CardItem(this.color, this.num, this.numEng, this.content, this.onTap,
      {Key? key})
      : super(key: key);

  final Color color;
  final String num;
  final String numEng;
  final String content;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.65;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        height: 215,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 25),
          ],
          color: color.withOpacity(1),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  Language.of(context).viewMore,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    Language.of(context).backupWarning,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
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
