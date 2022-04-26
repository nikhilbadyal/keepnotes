import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/util/navigation/app_routes.dart';

enum NoteState {
  unspecified,
  archived,
  hidden,
  trashed,
}

extension NoteX on Note {
  static const _values = [
    AppRoutes.homeScreen,
    AppRoutes.archiveScreen,
    AppRoutes.hiddenScreen,
    AppRoutes.trashScreen
  ];

  static Note get emptyNote => Note(
        id: '',
        title: '',
        content: '',
        lastModify: DateTime.now(),
        state: NoteState.unspecified,
      );

  String get path => _values[state.index];
}

class Note implements Comparable<Note> {
  Note({
    required this.lastModify,
    required this.id,
    required this.title,
    required this.content,
    required this.state,
  });

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
        content: content ?? this.content,
      );

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
    return NoteX.emptyNote.copyWith(
      id: const Uuid().v4(),
      title: json['title'].toString(),
      content: json['content'].toString(),
      lastModify: DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['lastModify'].toString()),
      ),
      state: NoteState.values[int.parse(json['state'].toString())],
    );
  }

  static Note fromDocumentSnapshot(final QueryDocumentSnapshot json) {
    final state = int.parse(json['state'].toString());
    return NoteX.emptyNote.copyWith(
      id: json['id'].toString(),
      title: json['title'].toString(),
      content: json['content'].toString(),
      lastModify: DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['lastModify'].toString()),
      ),
      state: NoteState.values[state],
    );
  }

  String get strLastModifiedDate =>
      DateFormat.yMd().add_jm().format(lastModify);

  String get strLastModifiedDate1 => DateFormat('jm').format(lastModify);

  @override
  int compareTo(final Note other) {
    return other.lastModify.compareTo(lastModify);
  }
}
