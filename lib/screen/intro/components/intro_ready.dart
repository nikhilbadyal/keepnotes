import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class IntroReady extends StatelessWidget {
  const IntroReady({required this.onLogin, final Key? key}) : super(key: key);

  final Function()? onLogin;

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
                            EvaIcons.layersOutline,
                            size: 40,
                            color: context.theme.colorScheme.secondary,
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
                            color: context.theme.textTheme.bodyText1!.color,
                          ),
                          children: [TextSpan(text: context.language.ready)],
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
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: context.mq.size.width * 0.6,
                  height: context.mq.size.height * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(appReady),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 32),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w500,
                                color: context.theme.textTheme.bodyText1!.color,
                              ),
                              children: [
                                TextSpan(
                                  text: '${context.language.over},'
                                      '\n${context.language.enjoy} ',
                                ),
                                TextSpan(
                                  text: '${context.language.appName}!',
                                  style: TextStyle(
                                    color: context.theme.colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
              backgroundColor: context.theme.colorScheme.secondary,
              label: Text(
                context.language.login,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'YTSans',
                  fontSize: 16,
                ),
              ),
              icon: const Icon(EvaIcons.logInOutline, color: Colors.white),
              onPressed: onLogin,
            ),
          ),
        ),
      ),
    );
  }
}
