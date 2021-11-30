import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

void moreOptions(final BuildContext context) {
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
    builder: (final context) => Wrap(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_outlined),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
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
    ),
  );
}
