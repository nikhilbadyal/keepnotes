// ignore_for_file: use_build_context_synchronously

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/widget/bottom_sheet.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  BottomBar({
    required this.note,
    required this.saveNote,
    required this.onIconTap,
    required this.isReadOnly,
    required this.autoSaver,
    required this.listContentControllers,
    required this.listContentNodes,
    required this.addListContentItem,
    final Key? key,
  }) : super(key: key);

  Note note;
  final Future<void> Function() saveNote;
  final OnTap onIconTap;
  final bool isReadOnly;
  final Timer autoSaver;
  final List<TextEditingController> listContentControllers;
  final Function() addListContentItem;

  final List<FocusNode> listContentNodes;

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
        color: Theme.of(context).canvasColor,
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
                '${Language.of(context).modified} '
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
                  showSnackbar(context, Language.of(context).emptyNote);
                } else {
                  moreMenu(context);
                }
              },
              icon: const Icon(Icons.more_vert_outlined),
              tooltip: Language.of(context).more,
            ),
          ],
        ),
      ),
    );
  }

  static Future<T?> showModalBottomSheet<T extends Object?>({
    required final BuildContext context,
    required final WidgetBuilder builder,
    final Color? backgroundColor,
    final double? elevation,
    final ShapeBorder? shape,
    final Clip? clipBehavior,
    final bool enableDismiss = true,
    final bool enableGestures = true,
  }) async {
    return context.push<T?>(
      BottomSheetRoute(
        child: builder(context),
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        enableDismiss: enableDismiss,
        enableGestures: enableGestures,
      ),
    );
  }

  Future<void> toggleList() async {
    setState(
      () => widget.note = widget.note
          .copyWith(hasList: !widget.note.hasList, id: widget.note.id),
    );
    if (widget.note.checkBoxItems.isEmpty && widget.note.hasList) {
      widget.addListContentItem();
    }
  }

  void copyTap() {
    widget.autoSaver.cancel();
    widget.saveNote();
    Navigator.of(context).pop();
    unawaited(
      Clipboard.setData(
        ClipboardData(text: widget.note.title),
      ).then((final _) {
        Clipboard.setData(
          ClipboardData(text: widget.note.content),
        ).then(
          (final value) => showSnackbar(
            context,
            Language.of(context).done,
            snackBarBehavior: SnackBarBehavior.floating,
          ),
        );
      }),
    );
  }

  void trashTap() {
    widget.autoSaver.cancel();
    widget.saveNote();
    final path = widget.note.path;
    unawaited(
      Provider.of<NotesHelper>(context, listen: false).trash(widget.note),
    );
    Navigator.of(context).popUntil(
      ModalRoute.withName(path),
    );
  }

  Future<void> hideTap() async {
    widget.autoSaver.cancel();
    await widget.saveNote();
    final status = Provider.of<AppConfiguration>(
      context,
      listen: false,
    ).password.isNotEmpty;
    final path = widget.note.path;
    if (!status) {
      await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (final context) => MyAlertDialog(
          content: Text(Language.of(context).setPasswordFirst),
        ),
      );
    } else {
      await Provider.of<NotesHelper>(context, listen: false).hide(widget.note);
    }
    if (!mounted) {
      return;
    }

    Navigator.of(context).popUntil(
      ModalRoute.withName(path),
    );
  }

  Widget getHideOpt(final BuildContext context) {
    return ListTile(
      leading: const Icon(
        TablerIcons.ghost,
      ),
      title: Text(
        Language.of(context).hide,
      ),
      onTap: () {
        context.pop();
        copyTap.call();
      },
    );
  }

  void unHideTap() {
    widget.autoSaver.cancel();
    widget.saveNote();
    final path = widget.note.path;
    unawaited(
      Provider.of<NotesHelper>(context, listen: false).trash(widget.note),
    );
    Navigator.of(context).popUntil(
      ModalRoute.withName(path),
    );
  }

  Widget getUnHideOpt(final BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.drive_file_move_outline,
      ),
      title: Text(
        Language.of(context).unhide,
      ),
      onTap: () {
        context.pop();
        unHideTap.call();
      },
    );
  }

  void archiveTap() {
    widget.autoSaver.cancel();
    widget.saveNote();
    final path = widget.note.path;
    unawaited(
      Provider.of<NotesHelper>(context, listen: false).archive(widget.note),
    );
    Navigator.of(context).popUntil(
      ModalRoute.withName(path),
    );
  }

  Widget getArchiveOpt(final BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.archive_outlined,
      ),
      title: Text(
        Language.of(context).archive,
      ),
      onTap: () {
        context.pop();
        copyTap.call();
      },
    );
  }

  void unArchiveTap() {
    widget.autoSaver.cancel();
    widget.saveNote();
    final path = widget.note.path;
    unawaited(
      Provider.of<NotesHelper>(context, listen: false).unarchive(widget.note),
    );
    Navigator.of(context).popUntil(
      ModalRoute.withName(path),
    );
  }

  Widget getUnArchiveOpt(final BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.unarchive_outlined,
      ),
      title: Text(
        Language.of(context).unarchive,
      ),
      onTap: () {
        context.pop();
        unArchiveTap.call();
      },
    );
  }

  void moreMenu(final BuildContext context) {
    Widget widget1;
    Widget widget2;
    switch (widget.note.state) {
      case NoteState.archived:
        widget1 = getHideOpt(context);
        widget2 = getUnArchiveOpt(context);
        break;

      case NoteState.hidden:
        widget1 = getUnHideOpt(context);
        widget2 = getArchiveOpt(context);

        break;
      default:
        widget1 = getHideOpt(context);
        widget2 = getArchiveOpt(context);
    }
    showModalBottomSheet(
      context: context,
      builder: (final context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  widget.note.checkBoxItems.isNotEmpty
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                ),
                title: const Text('Toggle List'),
                onTap: () {
                  context.pop();
                  toggleList.call();
                },
              ),
              widget1,
              widget2,
              ListTile(
                leading: const Icon(TablerIcons.copy),
                title: Text(
                  Language.of(context).clipboard,
                ),
                onTap: () {
                  context.pop();
                  copyTap.call();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outlined,
                ),
                title: Text(
                  Language.of(context).trash,
                ),
                onTap: () {
                  context.pop();
                  trashTap.call();
                },
              ),
            ],
          ),
        );
      },
    );
    /*showModalBottomSheet<dynamic>(
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

        ],
      ),
    );*/
  }
}
