import '../../../medications/domain/entities/medication.dart';
import '../../../medications/domain/repositories/medication_repository.dart';
import '../repositories/nfc_reader_repository.dart';

class IdentifyMedicationByTag {
  final NfcReaderRepository reader;
  final MedicationRepository medicationRepository;
  const IdentifyMedicationByTag(this.reader, this.medicationRepository);

  Future<Medication?> call(String simulatedTagId) async {
    final tagId = await reader.readTag(simulatedTagId);
    final medications = await medicationRepository.getAll();
    for (final medication in medications) {
      if (medication.tagId == tagId) return medication;
    }
    return null;
  }
}
