//25-11-2021 04:03 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget? getFAB(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.hidden:
      return const Fab(noteState: NoteState.hidden, onFabTap: onFabTap);
    case ScreenTypes.archive:
      return const Fab(
        onFabTap: onFabTap,
        noteState: NoteState.archived,
      );
    case ScreenTypes.trash:
      return FloatingActionButton(
        child: const Icon(Icons.delete_forever_outlined),
        onPressed: () {
          showModalBottomSheet<void>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            context: context,
            builder: (final context) {
              return Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_outlined),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        SizedBox(width: 4.1 * widthMultiplier),
                        Text(Language.of(context).options),
                      ],
                    ),
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: const [
                      ModalSheetDeleteAllWidget(),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    case ScreenTypes.home:
      return const Fab(
        onFabTap: onFabTap,
      );
    default:
      return null;
  }
}

void onTrashFab(final BuildContext context, final _) {
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
    builder: (final context) {
      return Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 4.1 * widthMultiplier),
                Text(Language.of(context).options),
              ],
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: const [
              ModalSheetDeleteAllWidget(),
            ],
          ),
        ],
      );
    },
  );
}

class ModalSheetDeleteAllWidget extends StatefulWidget {
  const ModalSheetDeleteAllWidget({
    final Key? key,
  }) : super(key: key);

  @override
  State<ModalSheetDeleteAllWidget> createState() =>
      _ModalSheetDeleteAllWidgetState();
}

class _ModalSheetDeleteAllWidgetState extends State<ModalSheetDeleteAllWidget> {
  @override
  Widget build(final BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () async {
            final status = await showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (final context) => MyAlertDialog(
                    content: Text(Language.of(context).emptyTrashWarning),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(Language.of(context).alertDialogOp1),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(Language.of(context).alertDialogOp2),
                      ),
                    ],
                  ),
                ) ??
                false;
            if (status) {
              if (!mounted) {
                return;
              }
              if (Provider.of<NotesHelper>(context, listen: false)
                  .mainNotes
                  .isNotEmpty) {
                Provider.of<NotesHelper>(context, listen: false).emptyTrash();
              }
            }
            if (!mounted) {
              return;
            }
            Navigator.of(context).popUntil(
              (final route) => route.settings.name == AppRoutes.trashScreen,
            );
          },
          child: Container(
            height: 9.41 * heightMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TablerIcons.trash,
                  size: 9 * widthMultiplier,
                ),
                SizedBox(width: 4.1 * widthMultiplier),
                Text(Language.of(context).emptyTrash),
              ],
            ),
          ),
        ),
      );
}
