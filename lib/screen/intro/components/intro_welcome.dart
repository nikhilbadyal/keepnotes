import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IntroWelcome extends StatelessWidget {
  const IntroWelcome({required this.onNext, final Key? key}) : super(key: key);

  final Function() onNext;

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: [
            ShowUpTransition(
              duration: const Duration(milliseconds: 600),
              forward: true,
              slideSide: SlideFromSlide.bottom,
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AvatarGlow(
                        endRadius: 133,
                        showTwoGlows: false,
                        glowColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        repeatPauseDuration: const Duration(milliseconds: 400),
                        child: Container(
                          height: 168,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                          ),
                          child: Center(
                            child: SizedBox(
                              height: 52,
                              width: 120,
                              child: SvgPicture.asset(
                                'assets/images/icon.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'YTSans',
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          children: [
                            TextSpan(
                              text: '${Language.of(context).welcomeTo}\n',
                              style: const TextStyle(
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: Language.of(context).appName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                fontSize: 32,
                                fontFamily: 'Product Sans',
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
            ShowUpTransition(
              forward: true,
              slideSide: SlideFromSlide.top,
              duration: const Duration(milliseconds: 600),
              child: GestureDetector(
                onTap: () {
                  launchUrlString(githubProfile);
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 15,
                                width: 15,
                                color: Colors.white,
                              ),
                              Icon(
                                MdiIcons.youtube,
                                size: 40,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'YTSans',
                              fontWeight: FontWeight.w400,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Powered by\n',
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: 'Firebase',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Product Sans',
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
            ),
            ShowUpTransition(
              forward: true,
              slideSide: SlideFromSlide.top,
              duration: const Duration(milliseconds: 600),
              child: Align(
                alignment: Alignment.topRight,
                child: _createLanguageDropDown(context),
              ),
            )
          ],
        ),
        floatingActionButton: ShowUpTransition(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 600),
          forward: true,
          slideSide: SlideFromSlide.bottom,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: Text(
                Language.of(context).getStarted,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'YTSans',
                  fontSize: 16,
                ),
              ),
              icon: const Icon(EvaIcons.arrowForward, color: Colors.white),
              onPressed: onNext,
            ),
          ),
        ),
      ),
    );
  }

  Padding _createLanguageDropDown(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButton<LanguageData>(
        alignment: Alignment.centerRight,
        iconSize: 26,
        hint: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            Localizations.localeOf(context).languageCode.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.w800,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ),
        icon: const SizedBox(),
        onChanged: (final value) async {
          if (value == null) {
            return;
          }
          context.read<AppConfiguration>().changeLocale(value.languageCode);
          final locale = setLocale(value.languageCode);
          MyNotes.setLocale(context, locale);
        },
        underline: DropdownButtonHideUnderline(child: Container()),
        items: supportedLanguages
            .map<DropdownMenuItem<LanguageData>>(
              (final e) => DropdownMenuItem<LanguageData>(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      e.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'YTSans',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

Future<void> onLocaleChange(final LanguageData? value) async {}
