import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';

/// Repositorio temporal de demostración: se reinicia al recargar la aplicación.
class InMemoryMedicationRepository implements MedicationRepository {
  final List<Medication> _items = [
    const Medication(
      id: 'demo-a',
      name: 'Medicamento A (ejemplo)',
      dosage: 'Dosis indicada por un profesional',
      schedule: '8:00 a. m.',
      tagId: 'ETIQUETA_BLANCA',
    ),
    const Medication(
      id: 'demo-b',
      name: 'Medicamento B (ejemplo)',
      dosage: 'Dosis indicada por un profesional',
      schedule: '6:00 p. m.',
      tagId: 'ETIQUETA_CIRCULAR',
    ),
  ];

  @override
  Future<List<Medication>> getAll() async => List.unmodifiable(_items);

  @override
  Future<void> save(Medication medication) async {
    final index = _items.indexWhere((item) => item.id == medication.id);
    if (index >= 0) {
      _items[index] = medication;
    } else {
      _items.add(medication);
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((medication) => medication.id == id);
  }
}
