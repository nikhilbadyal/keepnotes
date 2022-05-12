import 'package:notes/_aap_packages.dart' show NoteState;

enum ScreenTypes {
  suggestions,
  hidden,
  enterPin,
  setpass,
  home,
  archive,
  backup,
  trash,
  aboutMe,
  settings,
  intro,
  login,
  forgotPassword,
  edit,
  signup
}

extension NoteInScreen on ScreenTypes {
  NoteState get getNoteSate {
    switch (this) {
      case ScreenTypes.hidden:
        return NoteState.hidden;

      case ScreenTypes.archive:
        return NoteState.archived;

      case ScreenTypes.trash:
        return NoteState.trashed;

      default:
        return NoteState.unspecified;
    }
  }
}
