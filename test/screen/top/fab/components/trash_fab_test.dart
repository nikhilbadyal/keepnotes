import 'package:flutter_test/flutter_test.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

import '../../../../database/note_data.dart';

Future<void> main() async {
  testWidgets('Trash FAB exists', (final tester) async {
    final trashFab = TrashFab(
      key: UniqueKey(),
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NotesHelper>(
            create: (final context) => NotesHelper(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: trashFab),
        ),
      ),
    );
    var result = find.byWidget(trashFab);
    expect(result, findsOneWidget);
    result = find.byIcon(Icons.delete_forever_outlined);
    expect(result, findsOneWidget);
    final backIcon = find.byIcon(Icons.arrow_back_outlined);
    expect(backIcon, findsNothing);
    await tester.tap(result);
    await tester.pumpAndSettle();
    result = find.byIcon(Icons.arrow_back_outlined);
    expect(result, findsOneWidget);
    BuildContext context =
        tester.element(find.byType(ModalSheetDeleteAllWidget));
    final emptyTrashText = find.text(context.language.emptyTrash);
    expect(emptyTrashText, findsOneWidget);
    final trashIcon = find.byIcon(TablerIcons.trash);
    expect(trashIcon, findsOneWidget);
    await tester.tap(trashIcon);
    await tester.pump();
    context = tester.element(find.byType(MyAlertDialog));
    final dialogOp1 = find.text(context.language.alertDialogOp1);
    expect(dialogOp1, findsOneWidget);
    final dialogOp2 = find.text(context.language.alertDialogOp2);
    expect(dialogOp2, findsOneWidget);
    final dialogOp3 = find.text(context.language.emptyTrashWarning);
    expect(dialogOp3, findsOneWidget);
    final note1 = Note.fromMap(getRandomNotes()[0])..state = NoteState.trashed;
    final note2 = Note.fromMap(getRandomNotes()[1])..state = NoteState.trashed;
    context.noteHelper.mainNotes.insert(0, note1);
    context.noteHelper.mainNotes.insert(0, note2);
    await tester.tap(dialogOp1);
    expect(context.noteHelper.mainNotes.length, 0);
  });
}
