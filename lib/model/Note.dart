import 'package:intl/intl.dart';
import 'package:notes/main.dart';

enum NoteState {
  unspecified, //HOME
  pinned, // TO be implemented
  archived, //ARCHIVED
  hidden, //Hidden
  deleted, //Trash
}

class Note implements Comparable<Note> {
  Note(
      {this.id = -1,
      this.title = '',
      this.content = '',
      required this.lastModify,
      this.state = NoteState.unspecified});

  int id;
  String title;
  String content;
  DateTime lastModify;
  NoteState state;

  Note copyWith({
    int id = -1,
    String? title,
    String? content,
    DateTime? lastModify,
    NoteState? state,
  }) {
    return Note(
        id: id,
        title: title ?? this.title,
        state: state ?? this.state,
        lastModify: lastModify ?? this.lastModify,
        content: content ?? this.content);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is Note && other.id == id;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Object is $id $title $content $lastModify $state';
  }

  Map<String, dynamic> toMap({required bool isNew}) {
    final data = <String, dynamic>{
      'title': title,
      'content': content,
      'lastModify': lastModify.millisecondsSinceEpoch,
      'state': state.index, //  for later use for integrating archiving
    };
    if (!isNew) {
      data['id'] = id;
    }
    return data;
  }

  void update(Note other, {bool updateTimestamp = true}) {
    title = other.title;
    content = other.content;
    state = other.state;

    if (updateTimestamp) {
      lastModify = DateTime.now();
    } else {
      lastModify = other.lastModify;
    }
  }

  static Note fromJson(Map<String, dynamic> json) {
    int state = json['state'];
    if (state == 3 && !lockChecker.passwordSet) {
      state = 0;
    }
    return Note(
      title: json['title'].toString(),
      content: json['content'].toString(),
      lastModify: DateTime.fromMillisecondsSinceEpoch(
        json['lastModify'],
      ),
      state: NoteState.values[state],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'title': title,
      'content': content,
      'lastModify': lastModify.millisecondsSinceEpoch,
      'state': state.index,
    };
    return data;
  }

  String get strLastModifiedDate =>
      DateFormat.yMd().add_jm().format(lastModify);

  String get strLastModifiedDate1 => DateFormat('jm').format(lastModify);

  @override
  int compareTo(Note other) {
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
