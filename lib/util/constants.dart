//24-11-2021 03:19 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

//Image Const
const String backupSVG = '${imageAssets}backup.svg';
const String errorSvg = '${imageAssets}error.svg';
const String github = '${imageAssets}github.svg';
const String googleIcon = '${imageAssets}google.svg';
const String lockSvg = '${imageAssets}lock.svg';
const String mailSvg = '${imageAssets}mail.svg';
const String me = '${imageAssets}me.svg';
const String men = '${imageAssets}men.png';
const String noNotes = '${imageAssets}noNotes.png';
const String otp = '${imageAssets}otp.svg';
const String splashImage1 = '${imageAssets}splash1.png';
const String splashImage2 = '${imageAssets}splash2.png';
const String splashImage3 = '${imageAssets}splash3.png';
const String telegram = '${imageAssets}telegram.svg';
const String women = '${imageAssets}women.png';

// String Const
const String imageAssets = 'assets/images/';
const String githubProfile = 'https://github.com/nikhilbadyal';
const String repoLink = '$githubProfile/keep-notes';
const String telegramUrl = 'https://t.me/joinchat/uGAlVliNij1hZTFl';

// Constant INT
const pageLimit = 15;
const dbVersion = 1;
const backGroundTimer = 5;
const snackBarDuration = 2;
const welcomeSliderTimer = 200;
const lazyLoadPixelFactor = 500;
const minPassword = 8;
const pinCodeLen = 4;
const pinEnterReset = 500;
const bottomSheetTimer = 200;
const exitTimeInMillis = 1500;
const debugTimeDilation = 1.5;
const keyPadNumberSize = 30.0;

final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'nikhildevelops@gmail.com',
  queryParameters: {'subject': 'Suggestion for the app'},
);

//Widget const
Icon addIcon = const Icon(
  Icons.add_outlined,
  size: 30,
);

AppBarTheme getAppBarTheme(final Color primary) {
  return AppBarTheme(
    elevation: 0,
    color: primary,
    foregroundColor: primary == Colors.white ? Colors.grey.shade900 : null,
  );
}

//Function Const
typedef DoneCallBack = void Function(String text);
typedef OnTap = void Function();
typedef OnBuildContextTap = void Function(BuildContext context);
typedef OnFabTap = void Function(BuildContext context, NoteState noteState);
typedef SlidableActions = Function(Note note, BuildContext context);
typedef PickerLayoutBuilder = Widget Function(
  BuildContext context,
  List<Color> colors,
  PickerItem child,
);
typedef PickerItem = Widget Function(Color color);
typedef PickerItemBuilder = Widget Function(
  Color color,
  OnTap changeColor, {
  required bool isCurrentColor,
});
typedef BackPresAction = Future<bool> Function();

//UI Colors

// UI Const
Color defaultPrimary = Colors.deepPurple;
Color defaultAccent = Colors.deepPurpleAccent;

List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.grey[200]!,
    blurRadius: 30,
    offset: const Offset(0, 15),
  )
];
Color greyColor = const Color(0xFFEAEAEA);

enum AppTheme { dark, black, light }

List<Color> primaryColors = [
  const Color(0xff1a73e8),
  const Color(0xffffa842),
  const Color(0xffff4151),
  const Color(0xffb31818),
  const Color(0xff1ed760),
  const Color(0xff5e97f6),
  const Color(0xffff8055),
  const Color(0xff47ae84),
  const Color(0xff4a7ca5),
  const Color(0xffa86bd5),
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.blueGrey,
];
List<Color> secondaryColors = [
  const Color(0xff0370FF),
  const Color(0xffFFA842),
  const Color(0xffFF4151),
  const Color(0xffC70404),
  const Color(0xff05EF59),
  const Color(0xff5595FF),
  const Color(0xffFF8055),
  const Color(0xff2EC688),
  const Color(0xff327EBD),
  const Color(0xffAB58E8),
  const Color(0xffFF392B),
  const Color(0xffFF085C),
  const Color(0xffAB11C5),
  const Color(0xff6022CF),
  const Color(0xff2740CD),
  const Color(0xff1597FF),
  const Color(0xff00AAF7),
  const Color(0xff00BCD4),
  const Color(0xff009688),
  const Color(0xff33C839),
  const Color(0xff8DDB32),
  const Color(0xffE0F322),
  const Color(0xffFF9800),
  const Color(0xffFF5722),
  const Color(0xff8C4C35),
  const Color(0xff4885A2),
];
