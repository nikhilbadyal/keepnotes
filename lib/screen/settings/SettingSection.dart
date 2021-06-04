import 'package:flutter/material.dart';
import 'package:notes/screen/settings/AbstractSection.dart';
import 'package:notes/screen/settings/SettingsTiles.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class SettingsSection extends AbstractSection {
  // ignore: use_key_in_widget_constructors
  SettingsSection({this.tiles, title})
      : super(title: title, titlePadding: defaultTitlePadding);

  final List<SettingsTile>? tiles;

  @override
  @override
  Widget build(BuildContext context) {
    return androidSection(context);
  }

  Widget androidSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null)
          Padding(
            padding: titlePadding!,
            child: Text(
              title!,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tiles!.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return tiles![index];
          },
        ),
        if (showBottomDivider) const Divider(height: 1)
      ]),
    );
  }
}
