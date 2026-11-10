import 'package:flutter/foundation.dart';
import '../../../medications/domain/entities/medication.dart';
import '../../domain/entities/dose_record.dart';
import '../../domain/usecases/confirm_dose.dart';
import '../../domain/usecases/list_doses.dart';

class DoseController extends ChangeNotifier {
  final ConfirmDose confirmDose;
  final ListDoses listDoses;
  DoseController({required this.confirmDose, required this.listDoses});

  List<DoseRecord> records = [];
  bool loading = false;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try { records = await listDoses(); }
    catch (_) { error = 'No se pudo cargar el historial de tomas.'; }
    finally { loading = false; notifyListeners(); }
  }

  Future<String> confirm(Medication medication) async {
    try {
      await confirmDose(medication);
      await load();
      return '¡Toma de demostración registrada!';
    } on DoseAlreadyRecordedException {
      return 'Esta toma ya fue registrada hoy.';
    } catch (_) {
      return 'No se pudo guardar la toma.';
    }
  }

  int get todayCount {
    final today = DateTime.now();
    return records.where((r) => r.takenAt.year == today.year &&
      r.takenAt.month == today.month && r.takenAt.day == today.day).length;
  }
}
