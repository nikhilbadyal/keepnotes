import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

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
                    content: Text(
                      context.language.emptyTrashWarning,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => context.previousPage(true),
                        child: Text(
                          context.language.alertDialogOp1,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.previousPage(false),
                        child: Text(
                          context.language.alertDialogOp2,
                        ),
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
            context.navigator.popUntil(
              ModalRoute.withName(AppRoutes.trashScreen),
            );
          },
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: context.theme.iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: context.theme.cardColor,
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
                const Icon(
                  TablerIcons.trash,
                  size: 36,
                ),
                const SizedBox(width: 16),
                Text(
                  context.language.emptyTrash,
                ),
              ],
            ),
          ),
        ),
      );
}
