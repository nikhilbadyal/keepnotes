//24-11-2021 10:58 PM

import 'package:notes/_internal_packages.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    required this.imageLink,
    required this.description,
    required this.count,
    final Key? key,
  }) : super(key: key);

  final String imageLink;
  final int count;

  final String description;

  @override
  Widget build(final BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 40),
        child: Image.asset(imageLink));
  }
}
