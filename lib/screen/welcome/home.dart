import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class Home extends StatefulWidget {
  const Home(this.backgroundColor, this.onScreenTap, this.onGetStartTap,
      this.headingTop, this.headingColor,
      {final Key? key})
      : super(key: key);

  final Color backgroundColor;
  final Function() onScreenTap;
  final Function() onGetStartTap;
  final double headingTop;
  final Color headingColor;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1000),
      height: MediaQuery.of(context).size.height,
      color: widget.backgroundColor,
      child: Wrap(
        children: <Widget>[
          GestureDetector(
            onTap: widget.onScreenTap,
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
                        top: widget.headingTop,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Keep ',
                            style: TextStyle(
                              color: widget.headingColor,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            'Notes',
                            style: TextStyle(
                                color: widget.headingColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Language.of(context).appTagLine,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: widget.headingColor, fontSize: 16),
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
              onTap: widget.onGetStartTap,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    Language.of(context).getStarted,
                    style: TextStyle(
                        color: Theme.of(context).canvasColor, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*

Widget Home(
    final BuildContext context,
    final Color widget.backgroundColor,
    final Function() widget.onScreenTap,
    final Function() onGetStartTap,
    final double widget.headingTop,
    final Color _headingColor) {
  return AnimatedContainer(
    curve: Curves.fastLinearToSlowEaseIn,
    duration: const Duration(milliseconds: 1000),
    height: MediaQuery.of(context).size.height,
    color: widget.backgroundColor,
    child: Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: widget.onScreenTap,
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
                      top: widget.headingTop,
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
                    Language.of(context).appTagLine,
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
              child: Center(
                child: Text(
                  Language.of(context).getStarted,
                  style: TextStyle(
                      color: Theme.of(context).canvasColor, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
*/
