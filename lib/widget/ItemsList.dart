import 'package:flutter/material.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:provider/provider.dart';

typedef OnTap = void Function();
typedef OnLongPress = void Function();

class ListItem extends StatelessWidget {
  const ListItem({
    required this.note,
    required this.isSelected,
    required this.selectedFlag,
    this.onItemTap,
    this.onItemLongPress,
    Key? key,
  }) : super(key: key);

  final Note note;
  final OnTap? onItemTap;
  final OnLongPress? onItemLongPress;
  final bool isSelected;
  final Map<int, bool> selectedFlag;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 125,
        child: GestureDetector(
          onLongPress: onItemLongPress,
          onTap: onItemTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Provider.of<AppConfiguration>(context, listen: false)
                          .appTheme ==
                      AppTheme.Light
                  ? Theme.of(context).floatingActionButtonTheme.foregroundColor
                  : Colors.grey[900],
              boxShadow: Provider.of<AppConfiguration>(context, listen: false)
                          .appTheme ==
                      AppTheme.Light
                  ? shadow
                  : null,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Provider.of<AppConfiguration>(context, listen: false)
                            .appTheme ==
                        AppTheme.Light
                    ? greyColor
                    : Theme.of(context).primaryColor,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          note.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          note.strLastModifiedDate,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _selectedIcon(isSelected),
              ],
            ),
          ),
        ),
      );

  Widget _selectedIcon(bool isSelected) {
    if (isSelected) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      );
    } else {
      return const SizedBox();
    }
  }
}
