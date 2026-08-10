import 'package:flutter_test/flutter_test.dart';
import 'package:acadexa/app.dart';

void main() {
  testWidgets('Acadexa app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AcadexaApp());

    expect(find.byType(AcadexaApp), findsOneWidget);
  });
}