import 'package:flutter/material.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/medications/data/repositories/in_memory_medication_repository.dart';
import '../features/medications/domain/usecases/delete_medication.dart';
import '../features/medications/domain/usecases/list_medications.dart';
import '../features/medications/domain/usecases/save_medication.dart';
import '../features/medications/presentation/controllers/medication_controller.dart';
import 'theme/app_theme.dart';

class MediTagApp extends StatefulWidget {
  const MediTagApp({super.key});

  @override
  State<MediTagApp> createState() => _MediTagAppState();
}

class _MediTagAppState extends State<MediTagApp> {
  late final MedicationController medicationController;

  @override
  void initState() {
    super.initState();
    final repository = InMemoryMedicationRepository();
    medicationController = MedicationController(
      listMedications: ListMedications(repository),
      saveMedication: SaveMedication(repository),
      deleteMedication: DeleteMedication(repository),
    );
  }

  @override
  void dispose() {
    medicationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MediTag',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: HomePage(medicationController: medicationController),
      );
}
