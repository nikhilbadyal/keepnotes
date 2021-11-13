import 'package:notes/_internal_packages.dart';

Widget home(
    BuildContext context,
    Color _backgroundColor,
    Function() onScreenTap,
    Function() onGetStartTap,
    double _headingTop,
    Color _headingColor) {
  return AnimatedContainer(
    curve: Curves.fastLinearToSlowEaseIn,
    duration: const Duration(milliseconds: 1000),
    height: MediaQuery.of(context).size.height,
    color: _backgroundColor,
    child: Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: onScreenTap,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 1000),
                    margin: EdgeInsets.only(
                      top: _headingTop,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Keep ',
                          style: TextStyle(
                            color: _headingColor,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          'Notes',
                          style: TextStyle(
                              color: _headingColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'We keep you safe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _headingColor, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(
            32,
          ),
          child: Center(
            child: Image.asset('assets/images/splash_bg.png'),
          ),
        ),
        SizedBox(
          child: GestureDetector(
            onTap: onGetStartTap,
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
