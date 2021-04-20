import 'package:flutter/material.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/util/AppConfiguration.dart';

typedef onTap = void Function();
typedef onLongPress = void Function();

class ListItem extends StatelessWidget {
  const ListItem(
      {Key? key,
      required this.note,
      this.onItemTap,
      this.onItemLongPress,
      required this.isSelected,
      required this.selectedFlag})
      : super(key: key);

  final Note note;
  final onTap? onItemTap;
  final onLongPress? onItemLongPress;
  final bool isSelected;
  final Map<int, bool> selectedFlag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 125.0,
      child: GestureDetector(
        onLongPress: onItemLongPress,
        onTap: onItemTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: selectedAppTheme == AppTheme.Light
                ? Theme.of(context).floatingActionButtonTheme.foregroundColor
                : Colors.grey[900],
            boxShadow: selectedAppTheme == AppTheme.Light ? shadow : null,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: selectedAppTheme == AppTheme.Light
                  ? greyColor
                  : Theme.of(context).primaryColor,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        note.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        note.strLastModifiedDate,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Expanded(
                        child: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.0,
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
  }

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
