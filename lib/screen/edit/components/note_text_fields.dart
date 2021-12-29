//29-12-2021 08:58 PM

import 'package:notes/_internal_packages.dart';

class NoteTextFields extends StatefulWidget {
  const NoteTextFields({
    required this.controller,
    required this.isReadOnly,
    this.maxLines,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.inputDecoration,
    this.showCursor = true,
    this.autoFocus = false,
    this.onChanged,
    final Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final bool isReadOnly;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final InputDecoration? inputDecoration;
  final bool showCursor;
  final bool autoFocus;
  final Function(String str)? onChanged;

  @override
  _NoteTextFieldsState createState() => _NoteTextFieldsState();
}

class _NoteTextFieldsState extends State<NoteTextFields> {
  @override
  Widget build(final BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: widget.isReadOnly,
      maxLines: widget.maxLines,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      decoration: widget.inputDecoration,
      showCursor: widget.showCursor,
      autofocus: widget.autoFocus,
      onChanged: widget.onChanged,
    );
  }
}
