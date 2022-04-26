import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class IntroPermissions extends StatefulWidget {
  const IntroPermissions({final Key? key}) : super(key: key);

  @override
  _IntroPermissionsState createState() => _IntroPermissionsState();
}

class _IntroPermissionsState extends State<IntroPermissions> {
  late bool accessGranted;

  @override
  void initState() {
    super.initState();
    accessGranted = false;
    Permission.storage.status.then((final status) {
      if (status != PermissionStatus.granted) {
        setState(() => accessGranted = false);
      } else {
        setState(() => accessGranted = true);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
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
                        child: accessGranted
                            ? Icon(
                                MdiIcons.lockOpen,
                                size: 42,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : Icon(
                                MdiIcons.lock,
                                size: 42,
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
                          TextSpan(
                            text: '${Language.of(context).grant} ',
                          ),
                          TextSpan(
                            text: Language.of(context).access,
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
                    'assets/images/grantAccess.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'YTSans',
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      children: [
                        TextSpan(
                          text: '${Language.of(context).appName} ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: Language.of(context).storageJustify,
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.8),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShowUpTransition(
            forward: true,
            delay: const Duration(milliseconds: 600),
            duration: const Duration(milliseconds: 600),
            slideSide: SlideFromSlide.bottom,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (accessGranted == false) {
                    Permission.storage.request().then((final status) {
                      if (status == PermissionStatus.granted) {
                        setState(() => accessGranted = true);
                      }
                    });
                  }
                },
                child: AnimatedContainer(
                  margin: const EdgeInsets.only(bottom: 32),
                  duration: const Duration(milliseconds: 500),
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: accessGranted
                      ? Container(
                          margin: const EdgeInsets.only(left: 14, right: 14),
                          child: const Icon(
                            EvaIcons.doneAllOutline,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 18, right: 8),
                              child: Text(
                                Language.of(context).allowAccess,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: const Icon(
                                EvaIcons.lockOutline,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
