import 'package:google_fonts/google_fonts.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    required this.note,
    required this.isSelected,
    required this.selectedFlag,
    this.onItemTap,
    this.onItemLongPress,
    final Key? key,
  }) : super(key: key);

  final Note note;
  final OnTap? onItemTap;
  final OnTap? onItemLongPress;
  final bool isSelected;
  final Map<int, bool> selectedFlag;

  @override
  Widget build(final BuildContext context) {
    final appTheme =
        AppTheme.values[getIntFromSF('appTheme') ?? AppTheme.black.index];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: getHeight(note.content.length),
      child: GestureDetector(
        onLongPress: onItemLongPress,
        onTap: onItemTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: appTheme == AppTheme.light
                ? Theme.of(context).floatingActionButtonTheme.foregroundColor
                : Colors.black,
            // boxShadow: appTheme == AppTheme.light ? shadow : null,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: appTheme == AppTheme.light
                  ? greyColor
                  : Colors.grey[900] ?? Colors.transparent,
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
                      if (note.title.isNotEmpty)
                        Text(
                          note.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.merriweather(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  height: 1,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,),),
                        )
                      else
                        Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        note.strLastModifiedDate,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                          wordSpacing: 1.3,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Text(
                          note.content,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                            wordSpacing: 1,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),),
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

  Widget _selectedIcon(final bool isSelected) {
    if (isSelected) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      );
    } else {
      return const SizedBox();
    }
  }

  double getHeight(final int length) {
    if (length < 50) {
      return 120;
    } else if (length >= 50 && length < 150) {
      return 150;
    }
    return 180;
  }
}
