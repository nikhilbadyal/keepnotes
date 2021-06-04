import 'package:flutter/material.dart';
import 'package:notes/screen/settings/AbstractSection.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key, this.sections}) : super(key: key);

  final List<AbstractSection>?sections;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sections!.length,
          itemBuilder: (context, index) {
            final current = sections![index];
            AbstractSection? futureOne;
            if (index + 1 != sections!.length) {
              futureOne = sections![index + 1];
            }
            if (futureOne != null && futureOne.title != null) {
              current.showBottomDivider = false;
              return current;
            } else {
              current.showBottomDivider = true;
              return current;
            }
          },
        ),
      ),
    );
  }
}
