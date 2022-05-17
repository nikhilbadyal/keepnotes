//01-12-2021 03:42 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditBody extends StatefulWidget {
  const EditBody({
    required this.isReadOnly,
    required this.autofocus,
    required this.titleController,
    required this.contentController,
    required this.titleFocusNode,
    required this.contentFocusNode,
    final Key? key,
  }) : super(key: key);
  final bool isReadOnly;
  final bool autofocus;
  final TextEditingController titleController;
  final FocusNode titleFocusNode;
  final TextEditingController contentController;
  final FocusNode contentFocusNode;

  @override
  State<EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight,
        left: 10,
        right: 10,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            TextField(
              focusNode: widget.titleFocusNode,
              readOnly: widget.isReadOnly,
              controller: widget.titleController,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 18,
                height: 1.7,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
              decoration: InputDecoration(
                hintText: context.language.enterNoteTitle,
                border: InputBorder.none,
              ),
            ),
            TextField(
              focusNode: widget.contentFocusNode,
              onChanged: (final str) {
                Provider.of<CharCount>(context, listen: false)
                    .setCount(str.characters.length);
              },
              autofocus: widget.autofocus,
              readOnly: widget.isReadOnly,
              controller: widget.contentController,
              maxLines: null,
              showCursor: true,
              style: const TextStyle(
                wordSpacing: 1.3,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
              decoration: InputDecoration(
                hintText: context.language.enterNoteContent,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
