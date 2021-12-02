//24-11-2021 10:59 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

AnimatedContainer buildDot(final int currentPage, final BuildContext context,
    {final int? index,}) {
  const kAnimationDuration = Duration(milliseconds: welcomeSliderTimer);

  return AnimatedContainer(
    duration: kAnimationDuration,
    margin: const EdgeInsets.only(right: 5),
    height: 6,
    width: currentPage == index ? 20 : 6,
    decoration: BoxDecoration(
      color: currentPage == index
          ? Theme.of(context).colorScheme.secondary
          : const Color(0xFFD8D8D8),
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
