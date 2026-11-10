import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class SaveMedication {
  final MedicationRepository repository;
  const SaveMedication(this.repository);

  Future<void> call(Medication medication) async {
    if (medication.name.trim().isEmpty ||
        medication.dosage.trim().isEmpty ||
        medication.schedule.trim().isEmpty) {
      throw ArgumentError('Completa todos los campos requeridos.');
    }
    await repository.save(medication);
  }
}
