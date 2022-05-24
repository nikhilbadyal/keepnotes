import 'package:flutter_test/flutter_test.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Future<void> setupPreferences(final String key, final String value) async {
  SharedPreferences.setMockInitialValues(
    <String, Object>{'flutter.$key': value},
  );
  final preferences = await SharedPreferences.getInstance();
  await preferences.setString(key, value);
}

Future<void> main() async {
  const key = 'dummy';
  await setupPreferences(key, 'my string');
  prefs = await SharedPreferences.getInstance();
  testWidgets('FAB exists', (final tester) async {
    final fab = Fab(
      onFabTap: onFabTap,
      key: UniqueKey(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: fab),
      ),
    );
    var result = find.byWidget(fab);
    expect(result, findsOneWidget);
    result = find.byIcon(Icons.add_outlined);
    expect(result, findsOneWidget);
    const fab2 = Fab(
      onFabTap: onFabTap,
      icon: Icon(Icons.ac_unit_rounded),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: fab2),
        onGenerateRoute: generateRoute,
      ),
    );
    result = find.byWidget(fab2);
    expect(result, findsOneWidget);
    result = find.byIcon(Icons.ac_unit_rounded);
    expect(result, findsOneWidget);
    await tester.tap(result);
    await tester.pumpAndSettle();
    expect(find.byType(EditScreen), findsOneWidget);
  });
}
