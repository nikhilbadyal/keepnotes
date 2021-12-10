import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class Welcome extends StatefulWidget {
  const Welcome({final Key? key,}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentPage = 0;

  @override
  Widget build(final BuildContext context) {
    final splashData = <Map<String, String>>[
      {'text': Language.of(context).splashDes1, 'image': splashImage1},
      {'text': Language.of(context).splashDes2, 'image': splashImage2},
      {'text': Language.of(context).splashDes3, 'image': splashImage3},
    ];
    return Column(
      children: <Widget>[
        const Spacer(),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'Keep ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 20
                              : 40,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Notes',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 20
                                : 40,
                            fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: welcomeSliderTimer),
                  child: Text(
                    splashData[currentPage]['text'] ??
                        Language.of(context).someError,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 10
                            : 17,),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: PageView.builder(
              onPageChanged: (final value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: splashData.length,
              itemBuilder: (final context, final index) => ImageSlider(
                    count: currentPage,
                    description: splashData[index]['text'] ??
                        Language.of(context).someError,
                    imageLink: splashData[index]['image'] ?? splashImage1,
                  ),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (final index) => buildDot(currentPage, context, index: index),
          ),
        ),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.loginScreen),
            child: Container(
              margin:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? const EdgeInsets.only(left: 200, right: 200, top: 10)
                      : const EdgeInsets.all(32),
              padding:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? const EdgeInsets.only(left: 50, right: 50)
                      : const EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  Language.of(context).getStarted,
                  style: TextStyle(
                      color: Theme.of(context).canvasColor, fontSize: 20,),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
