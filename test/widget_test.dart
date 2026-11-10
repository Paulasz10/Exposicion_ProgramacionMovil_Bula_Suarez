import 'package:flutter_test/flutter_test.dart';
import 'package:meditag/app/app.dart';
void main(){testWidgets('MediTag muestra su nombre',(tester)async{await tester.pumpWidget(const MediTagApp());await tester.pump();expect(find.text('MediTag'),findsWidgets);});}
