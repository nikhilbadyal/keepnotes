//28-12-2021 10:18 PM

import 'package:cloud_firestore/cloud_firestore.dart';

class CheckBoxItem {
  CheckBoxItem({
    required this.id,
    required this.content,
    required this.isChecked,
  });

  int id;
  String content;
  bool isChecked;

  CheckBoxItem copyWith({
    required final int id,
    final String? content,
    final bool? isChecked,
  }) =>
      CheckBoxItem(
        id: id,
        content: content ?? this.content,
        isChecked: isChecked ?? this.isChecked,
      );

  @override
  String toString() {
    return 'CheckBoxList{id: $id, content: $content, isChecked: $isChecked}';
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'id': id,
      'content': content,
      'isChecked': isChecked ? '1' : '0',
    };
    return data;
  }

  static CheckBoxItem fromMap(final Map<String, dynamic> json) {
    return CheckBoxItem(
      id: json['id'],
      isChecked: json['isChecked'] == '1',
      content: json['content'].toString(),
    );
  }

  static CheckBoxItem fromDocumentSnapshot(final QueryDocumentSnapshot json) {
    return CheckBoxItem(
      id: json['id'],
      isChecked: json['isChecked'] == '1',
      content: json['content'].toString(),
    );
  }
}
