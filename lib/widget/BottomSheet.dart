import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:notes/screen/ModalSheetWidgets.dart';

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
                  icon: const Icon(EvaIcons.arrowBackOutline),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                const Text('Options'),
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
