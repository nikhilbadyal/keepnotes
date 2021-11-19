import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/_external_packages.dart';

enum NoteState {
  unspecified,
  pinned,
  archived,
  hidden,
  deleted,
}

class Note implements Comparable<Note> {
  Note(
      {required this.lastModify,
      required this.id,
      this.title = '',
      this.content = '',
      this.state = NoteState.unspecified});

  String id;
  String title;
  String content;
  DateTime lastModify;
  NoteState state;

  Note copyWith({
    required final String id,
    final String? title,
    final String? content,
    final DateTime? lastModify,
    final NoteState? state,
  }) =>
      Note(
          id: id,
          title: title ?? this.title,
          state: state ?? this.state,
          lastModify: lastModify ?? this.lastModify,
          content: content ?? this.content);

  @override
  String toString() => 'Object is $id $title $content $lastModify $state';

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'lastModify': lastModify.millisecondsSinceEpoch,
      'state': state.index,
    };
    return data;
  }

  static Note fromMap(final Map<String, dynamic> json) {
    return Note(
      id: const Uuid().v4(),
      title: json['title'].toString(),
      content: json['content'].toString(),
      lastModify: DateTime.fromMillisecondsSinceEpoch(
        json['lastModify'],
      ),
      state: NoteState.values[json['state']],
    );
  }

  static Note fromDocumentSnapshot(final QueryDocumentSnapshot json) {
    final int state = json['state'];
    return Note(
      id: json['id'],
      title: json['title'].toString(),
      content: json['content'].toString(),
      lastModify: DateTime.fromMillisecondsSinceEpoch(
        json['lastModify'],
      ),
      state: NoteState.values[state],
    );
  }

  String get strLastModifiedDate =>
      DateFormat.yMd().add_jm().format(lastModify);

  String get strLastModifiedDate1 => DateFormat('jm').format(lastModify);

  @override
  int compareTo(final Note other) {
    final isAfter = lastModify.isAfter(other.lastModify);
    if (isAfter) {
      return -1;
    } else {
      final isBefore = lastModify.isBefore(other.lastModify);
      if (isBefore) {
        return 1;
      }
      return 0;
    }
  }
}
