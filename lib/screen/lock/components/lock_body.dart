import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class LockBody extends StatefulWidget {
  const LockBody({
    required this.doneCallBack,
    required this.title,
    this.onFingerTap,
    final Key? key,
  }) : super(key: key);

  final DoneCallBack doneCallBack;
  final OnTap? onFingerTap;
  final String title;

  @override
  _LockBodyState createState() => _LockBodyState();
}

class _LockBodyState extends State<LockBody> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  @override
  Widget build(final BuildContext context) {
    return OrientationBuilder(
      builder: (final context, final orientation) {
        return orientation == Orientation.portrait
            ? buildPotrait()
            : buildLandscape();
      },
    );
  }

  Widget buildPotrait() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SvgPicture.asset(
              otp,
              height: 30 * heightMultiplier,
            ),
            SizedBox(
              height: 5 * heightMultiplier,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5 * heightMultiplier),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 3 * textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PinCodeBoxes(
              pinPutController: _pinPutController,
              pinPutFocusNode: _pinPutFocusNode,
              doneCallBack: widget.doneCallBack,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLandscape() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset(
              otp,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5 * heightMultiplier),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 3 * textMultiplier,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PinCodeBoxes(
                  pinPutController: _pinPutController,
                  pinPutFocusNode: _pinPutFocusNode,
                  doneCallBack: widget.doneCallBack,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
