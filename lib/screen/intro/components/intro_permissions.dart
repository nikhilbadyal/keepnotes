import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class IntroPermissions extends StatefulWidget {
  const IntroPermissions({final Key? key}) : super(key: key);

  @override
  State<IntroPermissions> createState() => _IntroPermissionsState();
}

class _IntroPermissionsState extends State<IntroPermissions> {
  late bool accessGranted;

  @override
  void setState(final VoidCallback fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

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
                                color: context.secondaryColor,
                              )
                            : Icon(
                                MdiIcons.lock,
                                size: 42,
                                color: context.secondaryColor,
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
                          color: context.bodyText1,
                        ),
                        children: [
                          TextSpan(
                            text: '${context.language.grant} ',
                          ),
                          TextSpan(
                            text: context.language.access,
                            style: TextStyle(
                              color: context.secondaryColor,
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
              width: context.mq.size.width * 0.6,
              height: context.mq.size.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    grantAccess,
                    height: context.mq.size.height * 0.3,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'YTSans',
                        color: context.bodyText1,
                      ),
                      children: [
                        TextSpan(
                          text: '${context.language.appName} ',
                          style: TextStyle(
                            color: context.secondaryColor,
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: context.language.storageJustify,
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.w500,
                            color: context.bodyText1.withOpacity(0.8),
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
              child: InkWell(
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
                    color: context.secondaryColor,
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
                                context.language.allowAccess,
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
