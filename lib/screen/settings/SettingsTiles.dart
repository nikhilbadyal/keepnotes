import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum _SettingsTileType { simple, switchTile }

const Color mediumGrayColor = Color(0xFFC7C7CC);
const Color itemPressedColor = Color(0xFFD9D9D9);
const Color borderColor = Color(0xFFBCBBC1);
const Color borderLightColor = Color.fromRGBO(49, 44, 51, 1);
const Color backgroundGray = Color(0xFFEFEFF4);
const Color groupSubtitle = Color(0xFF777777);
const Color iosTileDarkColor = Color.fromRGBO(28, 28, 30, 1);
const Color iosPressedTileColorDark = Color.fromRGBO(44, 44, 46, 1);
const Color iosPressedTileColorLight = Color.fromRGBO(230, 229, 235, 1);

const defaultTitlePadding = EdgeInsets.only(
  left: 15,
  right: 15,
  bottom: 6,
);

const defaultCupertinoForwardIcon = Icon(
  CupertinoIcons.forward,
  size: 21,
  color: mediumGrayColor,
);

const defaultCupertinoForwardPadding = EdgeInsetsDirectional.only(
  start: 2.25,
);

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.trailing,
    this.iosChevron = defaultCupertinoForwardIcon,
    this.iosChevronPadding = defaultCupertinoForwardPadding,
    @Deprecated('Use onPressed instead') this.onTap,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.enabled = true,
    this.onPressed,
    this.switchActiveColor,
    Key? key,
  })  : _tileType = _SettingsTileType.simple,
        onToggle = null,
        switchValue = null,
        assert(titleMaxLines == null || titleMaxLines > 0, 'Error'),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0, 'Error'),
        super(key: key);

  const SettingsTile.switchTile({
    required this.title,
    required this.onToggle,
    required this.switchValue,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.enabled = true,
    this.trailing,
    this.titleTextStyle ,
    this.subtitleTextStyle,
    this.switchActiveColor,
    Key? key,
  })  : _tileType = _SettingsTileType.switchTile,
        onTap = null,
        onPressed = null,
        iosChevron = null,
        iosChevronPadding = null,
        assert(titleMaxLines == null || titleMaxLines > 0, 'Error'),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0, 'Error'),
        super(key: key);
  final String title;
  final int? titleMaxLines;
  final String? subtitle;
  final int? subtitleMaxLines;
  final Widget? leading;
  final Widget? trailing;
  final Icon? iosChevron;
  final EdgeInsetsGeometry? iosChevronPadding;
  final VoidCallback? onTap;
  final Function(BuildContext context)? onPressed;
  final Function(bool value)? onToggle;
  final bool? switchValue;
  final bool enabled;
  final TextStyle? titleTextStyle ;
  final TextStyle? subtitleTextStyle;
  final Color? switchActiveColor;
  final _SettingsTileType _tileType;

  @override
  Widget build(BuildContext context) {
    return androidTile(context);
  }

  Widget androidTile(BuildContext context) {
    if (_tileType == _SettingsTileType.switchTile) {
      return SwitchListTile(
        secondary: leading,
        value: switchValue!,
        activeColor: switchActiveColor,
        onChanged: enabled ? onToggle : null,
        title: Text(
          title,
          style: titleTextStyle,
          maxLines: titleMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: subtitleTextStyle,
                maxLines: subtitleMaxLines,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      );
    } else {
      return ListTile(
        title: Text(title, style: titleTextStyle),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: subtitleTextStyle,
                maxLines: subtitleMaxLines,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        leading: leading,
        enabled: enabled,
        trailing: trailing,
        onTap: onTapFunction(context) as void Function()?,
      );
    }
  }

  Function? onTapFunction(BuildContext context) =>
      onTap != null || onPressed != null
          ? () {
              if (onPressed != null) {
                onPressed!.call(context);
              } else {
                onTap!.call();
              }
            }
          : null;
}
