import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class ModalSheetWidget extends ModalSheetWidgets {
  const ModalSheetWidget({
    required final Function()? onTap,
    required final IconData icon,
    required final String label,
    final Key? key,
  }) : super(key: key, onTap: onTap, icon: icon, label: label);

  @override
  Widget build(final BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: context.iconColor.withOpacity(0.1),
                width: 1.5,
              ),
              color: context.canvasColor,
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
                  icon,
                  size: 35,
                ),
                const SizedBox(width: 16),
                Text(label),
              ],
            ),
          ),
        ),
      );
}
