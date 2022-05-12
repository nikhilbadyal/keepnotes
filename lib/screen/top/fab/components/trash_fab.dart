import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class TrashFab extends StatelessWidget {
  const TrashFab({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
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
  }
}
