import 'package:flutter/foundation.dart';

import '../../domain/entities/medication.dart';
import '../../domain/usecases/delete_medication.dart';
import '../../domain/usecases/list_medications.dart';
import '../../domain/usecases/save_medication.dart';

class MedicationController extends ChangeNotifier {
  final ListMedications listMedications;
  final SaveMedication saveMedication;
  final DeleteMedication deleteMedication;

  MedicationController({
    required this.listMedications,
    required this.saveMedication,
    required this.deleteMedication,
  });

  List<Medication> medications = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      medications = await listMedications();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> add({
    required String name,
    required String dosage,
    required String schedule,
  }) async {
    try {
      await saveMedication(Medication(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.trim(),
        dosage: dosage.trim(),
        schedule: schedule.trim(),
      ));
      await load();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> remove(String id) async {
    try {
      await deleteMedication(id);
      await load();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
