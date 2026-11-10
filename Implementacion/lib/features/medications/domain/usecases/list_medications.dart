import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class ListMedications {
  final MedicationRepository repository;
  const ListMedications(this.repository);

  Future<List<Medication>> call() => repository.getAll();
}
