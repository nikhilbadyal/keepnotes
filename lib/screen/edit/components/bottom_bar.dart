import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    required this.note,
    required this.saveNote,
    required this.onIconTap,
    required this.isReadOnly,
    required this.autoSaverTimer,
    final Key? key,
  }) : super(key: key);

  final Note note;
  final Future<void> Function() saveNote;
  final OnTap onIconTap;
  final bool isReadOnly;
  final Timer autoSaverTimer;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(final BuildContext context) {
    final primaryColor =
        Color(getIntFromSF('primaryColor') ?? defaultPrimary.value);
    final appTheme =
        AppTheme.values[getIntFromSF('appTheme') ?? AppTheme.black.index];
    return BottomAppBar(
      child: Container(
        color: context.theme.canvasColor,
        height: kBottomNavigationBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.lock_outline),
              onPressed: widget.onIconTap,
              color: widget.isReadOnly
                  ? primaryColor
                  : appTheme == AppTheme.light
                      ? Colors.black
                      : Colors.white,
            ),
            Center(
              child: Text(
                '${context.language.modified} '
                '${widget.note.strLastModifiedDate1}',
              ),
            ),
            IconButton(
              onPressed: () async {
                await widget.saveNote();
                if (!mounted) {
                  return;
                }

                if (widget.note.content.isEmpty && widget.note.title.isEmpty) {
                  showSnackbar(context, context.language.emptyNote);
                } else {
                  moreMenu(context);
                }
              },
              icon: const Icon(Icons.more_vert_outlined),
              tooltip: context.language.more,
            ),
          ],
        ),
      ),
    );
  }

  void moreMenu(final BuildContext context) {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (final context) => Wrap(
        children: [
          BottomBarOptions(
            note: widget.note,
            saveNote: widget.saveNote,
            autoSaver: widget.autoSaverTimer,
          ),
        ],
      ),
    );
  }
}
