
import 'package:flutter_test/flutter_test.dart';
import 'package:meditag/app/app.dart';

void main() {
  testWidgets('MediTag muestra la pantalla inicial', (tester) async {
    await tester.pumpWidget(const MediTagApp());

    expect(
      find.text('¡Bienvenido a MediTag!'),
      findsOneWidget,
    );
  });
}
