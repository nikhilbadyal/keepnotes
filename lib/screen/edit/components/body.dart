//01-12-2021 03:42 PM
// ignore_for_file: cascade_invocations

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditBody extends StatefulWidget {
  const EditBody({
    required this.isReadOnly,
    required this.note,
    required this.contentController,
    required this.titleController,
    required this.listContentControllers,
    required this.listContentNodes,
    required this.addListContentItem,
    required this.needFocus,
    final Key? key,
  }) : super(key: key);
  final bool isReadOnly;
  final Note note;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final List<TextEditingController> listContentControllers;

  final List<FocusNode> listContentNodes;
  final Function() addListContentItem;
  final bool needFocus;

  @override
  State<EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
  late bool autofocus;
  late bool needFocus;

  @override
  void initState() {
    widget.listContentControllers.clear();
    for (var i = 0; i < widget.note.checkBoxItems.length; i++) {
      widget.listContentControllers.add(
        TextEditingController(text: widget.note.checkBoxItems[i].content),
      );

      final node = FocusNode();
      widget.listContentNodes.add(node);
    }
    autofocus = widget.note.title.isEmpty && widget.note.content.isEmpty;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    needFocus = widget.needFocus;
    final showNewItemButton = widget.note.checkBoxItems.isNotEmpty &&
            widget.note.checkBoxItems.last.content.isNotEmpty ||
        widget.note.checkBoxItems.isEmpty;
    return Container(
      padding: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight,
        left: 10,
        right: 10,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            NoteTextFields(
              controller: widget.titleController,
              isReadOnly: widget.isReadOnly,
              textCapitalization: TextCapitalization.sentences,
              style: GoogleFonts.merriweather(
                textStyle: const TextStyle(
                  fontSize: 18,
                  height: 1.7,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              inputDecoration: InputDecoration(
                hintText: Language.of(context).enterNoteTitle,
                border: InputBorder.none,
              ),
            ),
            NoteTextFields(
              onChanged: (final str) {
                Provider.of<CharCount>(context, listen: false)
                    .setCount(str.characters.length);
              },
              autoFocus: autofocus,
              isReadOnly: widget.isReadOnly,
              controller: widget.contentController,
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  wordSpacing: 1.3,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
              inputDecoration: InputDecoration(
                hintText: Language.of(context).enterNoteContent,
                border: InputBorder.none,
              ),
            ),
            if (widget.note.checkBoxItems.isNotEmpty)
              ...List.generate(
                widget.note.checkBoxItems.length,
                generateListItem,
              ),
            if (widget.note.checkBoxItems.isNotEmpty)
              AnimatedOpacity(
                opacity: showNewItemButton ? 1 : 0,
                duration: Duration.zero,
                child: ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text(
                    'Add Item',
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  horizontalTitleGap: 12,
                  onTap: widget.addListContentItem,
                  //TODO fix this  onTap: showNewItemButton ? () =>
                  // addListContentItem() : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget generateListItem(final int index) {
    final currentItem = widget.note.checkBoxItems[index];
    debugPrint('here');
    if (needFocus && index == widget.note.checkBoxItems.length - 1) {
      needFocus = false;
      WidgetsBinding.instance!.addPostFrameCallback(
        (final _) =>
            context.focusScope.requestFocus(widget.listContentNodes.last),
      );
    }

    return _NoteListEntryItem(
      item: currentItem,
      controller: widget.listContentControllers[index],
      focusNode: widget.listContentNodes[index],
      onDismissed: (final _) => setState(() {
        widget.note.checkBoxItems.removeAt(index);
        widget.listContentControllers.removeAt(index);
        widget.listContentNodes.removeAt(index);
      }),
      onTextChanged: (final text) {
        setState(() => widget.note.checkBoxItems[index].content = text);
      },
      onEditingComplete: () {
        if (index == widget.note.checkBoxItems.length - 1) {
          if (widget.note.checkBoxItems.last.content != '') {
          } else {
            FocusScope.of(context).requestFocus(widget.listContentNodes[index]);
          }
        } else {
          FocusScope.of(context)
              .requestFocus(widget.listContentNodes[index + 1]);
        }
      },
      onCheckChanged: (final value) {
        setState(() => widget.note.checkBoxItems[index].isChecked = value!);
      },
      checkColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class _NoteListEntryItem extends StatefulWidget {
  const _NoteListEntryItem({
    required this.item,
    this.controller,
    this.focusNode,
    this.onDismissed,
    this.onTextChanged,
    this.onEditingComplete,
    this.onCheckChanged,
    this.checkColor,
    this.enabled = true,
    final Key? key,
  }) : super(key: key);
  final CheckBoxItem item;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final DismissDirectionCallback? onDismissed;
  final ValueChanged<String>? onTextChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<bool?>? onCheckChanged;
  final Color? checkColor;
  final bool enabled;

  @override
  _NoteListEntryItemState createState() => _NoteListEntryItemState();
}

class _NoteListEntryItemState extends State<_NoteListEntryItem>
    with SingleTickerProviderStateMixin {
  bool showDeleteButton = false;

  @override
  Widget build(final BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.item.id),
      onDismissed: widget.onDismissed,
      background: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.red[400]
            : Colors.red[600],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: IgnorePointer(
                ignoring: !widget.enabled,
                child: Checkbox(
                  fillColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary,
                  ),
                  value: widget.item.isChecked,
                  onChanged: widget.onCheckChanged,
                  checkColor: widget.checkColor ?? Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Add something',
                ),
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: Theme.of(context).iconTheme.color!.withOpacity(
                        widget.item.isChecked ? 0.7 : 1,
                      ),
                  decoration:
                      widget.item.isChecked ? TextDecoration.lineThrough : null,
                ),
                onEditingComplete: widget.onEditingComplete,
                onChanged: widget.onTextChanged,
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.next,
                readOnly: !widget.enabled,
              ),
            ),
            Visibility(
              visible: widget.enabled,
              child: AnimatedOpacity(
                opacity: showDeleteButton ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: showDeleteButton
                      ? () =>
                          widget.onDismissed?.call(DismissDirection.endToStart)
                      : null,
                  padding: EdgeInsets.zero,
                  splashRadius: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
