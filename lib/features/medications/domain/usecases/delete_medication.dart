import '../repositories/medication_repository.dart';

class DeleteMedication {
  final MedicationRepository repository;
  const DeleteMedication(this.repository);

  Future<void> call(String id) => repository.delete(id);
}
