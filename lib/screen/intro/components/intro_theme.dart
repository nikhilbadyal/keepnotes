import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

enum ThemeSelected { system, light, dark }

class IntroTheme extends StatefulWidget {
  const IntroTheme({final Key? key}) : super(key: key);

  @override
  _IntroThemeState createState() => _IntroThemeState();
}

class _IntroThemeState extends State<IntroTheme> {
  late ThemeSelected theme;

  @override
  void initState() {
    super.initState();
    theme = ThemeSelected.system;
  }

  @override
  Widget build(final BuildContext context) {
    theme = ThemeSelected.dark;

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShowUpTransition(
            duration: const Duration(milliseconds: 600),
            forward: true,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          EvaIcons.colorPaletteOutline,
                          size: 40,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        children: [
                          TextSpan(text: Language.of(context).app),
                          TextSpan(
                            text: Language.of(context).theme,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShowUpTransition(
            slideSide: SlideFromSlide.bottom,
            duration: const Duration(milliseconds: 600),
            forward: true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/appTheme.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        children: [
                          TextSpan(
                            text: '${Language.of(context).selectTheme}\n',
                          ),
                          TextSpan(
                            text: '${Language.of(context).theme}!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowUpTransition(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 700),
                    forward: true,
                    slideSide: SlideFromSlide.bottom,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<AppConfiguration>()
                            .changeAppTheme(AppTheme.light);
                      },
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(8),
                        duration: const Duration(milliseconds: 150),
                        height: 52,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme == ThemeSelected.light
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).cardColor.withOpacity(0.4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.08),
                              spreadRadius: 0.01,
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            Language.of(context).light,
                            style: TextStyle(
                              fontSize: 15,
                              color: theme == ThemeSelected.light
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Product Sans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ShowUpTransition(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 800),
                    forward: true,
                    slideSide: SlideFromSlide.bottom,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<AppConfiguration>()
                            .changeAppTheme(AppTheme.dark);
                      },
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(8),
                        duration: const Duration(milliseconds: 150),
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme == ThemeSelected.dark
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).cardColor.withOpacity(0.4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.08),
                              spreadRadius: 0.01,
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            Language.of(context).dark,
                            style: TextStyle(
                              fontSize: 15,
                              color: theme == ThemeSelected.dark
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Product Sans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
