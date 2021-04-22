import 'package:flutter/material.dart';
import 'package:notes/screen/ModalSheetWidgets.dart';
import 'package:notes/util/Languages/Languages.dart';

void moreOptions(BuildContext context) {
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
    builder: (context) {
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
                const SizedBox(width: 16),
                Text(Languages.of(context).options),
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
