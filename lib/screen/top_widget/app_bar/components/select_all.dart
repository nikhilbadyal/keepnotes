//25-11-2021 10:49 AM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class SelectDeSelectAllFab extends StatelessWidget {
  const SelectDeSelectAllFab({final Key? key,}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final isFalseAvailable = homeBody!.selectedFlag.containsValue(false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: FloatingActionButton(
        onPressed: _selectAll,
        child: Icon(
          isFalseAvailable ? Icons.done_all : Icons.remove_done,
        ),
      ),
    );
  }

  void _selectAll() {
    final isFalseAvailable = homeBody!.selectedFlag.containsValue(false);
    homeBody!.selectedFlag
        .updateAll((final key, final value) => isFalseAvailable);
    homeBody!.isSelectionMode = homeBody!.selectedFlag.containsValue(true);
    homeBody!.callSetState();
  }
}
