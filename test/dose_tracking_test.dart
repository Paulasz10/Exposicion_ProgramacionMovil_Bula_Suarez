import 'package:flutter_test/flutter_test.dart';
import 'package:meditag/features/medications/domain/entities/medication.dart';
import 'package:meditag/features/dose_tracking/domain/entities/dose_record.dart';
import 'package:meditag/features/dose_tracking/domain/repositories/dose_repository.dart';
import 'package:meditag/features/dose_tracking/domain/usecases/confirm_dose.dart';

class FakeDoseRepository implements DoseRepository {
  final List<DoseRecord> items = [];
  @override
  Future<List<DoseRecord>> getAll() async => List.of(items);
  @override
  Future<void> save(DoseRecord record) async => items.add(record);
}

void main() {
  test('Una toma se registra una vez por día y medicamento', () async {
    final repository = FakeDoseRepository();
    final useCase = ConfirmDose(repository);
    const medication = Medication(id: 'a', name: 'Demo A',
      dosage: 'Ejemplo', schedule: '08:00');
    final now = DateTime(2026, 11, 9, 8, 30);
    await useCase(medication, now: now);
    expect(repository.items.length, 1);
    await expectLater(
      useCase(medication, now: DateTime(2026, 11, 9, 11)),
      throwsA(isA<DoseAlreadyRecordedException>()),
    );
    await useCase(medication, now: DateTime(2026, 11, 10, 8, 30));
    expect(repository.items.length, 2);
  });
}
