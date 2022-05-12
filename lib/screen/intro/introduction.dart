import 'dart:ui';

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/widget/floating_dots.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({final Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late TabController _controller;

  int _selectedIndex = 0;

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      IntroWelcome(
        onNext: () => setState(() {
          _selectedIndex += 1;
          _controller.index = _selectedIndex;
        }),
      ),
      const IntroPermissions(),
      const IntroTheme(),
      IntroReady(
        onLogin: () {
          Navigator.pushNamed(context, AppRoutes.loginScreen);
        },
      )
    ];
    _controller = TabController(length: screens.length, vsync: this);
    _controller.animation!.addListener(() {
      final value = _controller.animation!.value.round();
      if (value != _selectedIndex) {
        setState(() => _selectedIndex = value);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((final _) async {
      final systemBrightness = Theme.of(context).brightness;
      final statusBarBrightness = systemBrightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
      final themeBrightness = systemBrightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: statusBarBrightness,
          statusBarIconBrightness: statusBarBrightness,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: themeBrightness,
        ),
      );
    });

    final backgroundColor =
        Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7);

    Widget _body() {
      return Column(
        children: [
          Expanded(
            flex: 9,
            child: TabBarView(
              controller: _controller,
              children: screens,
            ),
          ),
          Expanded(
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _selectedIndex == 3
                            ? const SizedBox()
                            : TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  Language.of(context).skip,
                                  style: TextStyle(
                                    fontFamily: 'Product Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.7),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.loginScreen,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: screens.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (final context, final index) {
                      return Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(52),
                            color: _selectedIndex == index
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context)
                                    .iconTheme
                                    .color!
                                    .withOpacity(0.08),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _selectedIndex == 1 || _selectedIndex == 2
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                ),
                                onPressed: _selectedIndex <
                                        _controller.length - 1
                                    ? () => setState(() {
                                          _selectedIndex += 1;
                                          _controller.index = _selectedIndex;
                                        })
                                    : null,
                                child: Text(
                                  Language.of(context).next,
                                  style: TextStyle(
                                    fontFamily: 'Product Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: FloatingDotGroup(
              number: 10,
              size: DotSize.large,
              colors: [Theme.of(context).colorScheme.secondary],
              speed: DotSpeed.fast,
            ),
          ),
          Container(color: backgroundColor, child: _body())
        ],
      ),
    );
  }
}
