//25-11-2021 04:03 PM
import 'package:notes/_aap_packages.dart';
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 26),
        child: FloatingActionButton(
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
                            onPressed: context.previousPage,
                          ),
                          const SizedBox(width: 16),
                          Text(context.language.options),
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
        ),
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
                  onPressed: context.previousPage,
                ),
                const SizedBox(width: 16),
                Text(context.language.options),
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
