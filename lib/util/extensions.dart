//29-12-2021 08:20 PM
import 'package:notes/_internal_packages.dart';

extension ProvideData on BuildContext {
  ThemeData get theme => Theme.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get mSize => mediaQuery.size;

  EdgeInsets get padding => mediaQuery.padding;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  NavigatorState get navigator => Navigator.of(this);

  void pop<T extends Object?>([final T? result]) => navigator.pop<T?>(result);

  Future<T?> push<T extends Object?>(final Route<T> route) =>
      navigator.push<T?>(route);
}
