import '../../../medications/domain/entities/medication.dart';
import '../entities/dose_record.dart';
import '../repositories/dose_repository.dart';

class DoseAlreadyRecordedException implements Exception {
  const DoseAlreadyRecordedException();
  @override
  String toString() => 'Esta toma ya fue registrada hoy.';
}

class ConfirmDose {
  final DoseRepository repository;
  const ConfirmDose(this.repository);

  Future<DoseRecord> call(Medication medication, {DateTime? now}) async {
    final date = now ?? DateTime.now();
    // MVP: un único horario (slot) por medicamento al día.
    final slot = medication.schedule.trim();
    final day = '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    final id = '${medication.id}|$day|$slot';
    final existing = await repository.getAll();
    if (existing.any((record) => record.id == id)) {
      throw const DoseAlreadyRecordedException();
    }
    final record = DoseRecord(
      id: id,
      medicationId: medication.id,
      medicationName: medication.name,
      takenAt: date,
      scheduledSlot: slot,
    );
    await repository.save(record);
    return record;
  }
}
