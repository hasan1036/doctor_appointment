import 'package:doctor_appointment/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Health app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Doctors'), findsOneWidget);
    expect(find.text('Pregnancy'), findsOneWidget);
  });
}