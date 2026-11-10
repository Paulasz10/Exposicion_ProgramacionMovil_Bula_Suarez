
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Pantallas principales
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/welcome_page.dart';

// Medicamentos
import '../features/medications/data/repositories/in_memory_medication_repository.dart';
import '../features/medications/domain/usecases/delete_medication.dart';
import '../features/medications/domain/usecases/list_medications.dart';
import '../features/medications/domain/usecases/save_medication.dart';
import '../features/medications/presentation/controllers/medication_controller.dart';

// NFC
import '../features/nfc/data/repositories/native_nfc_reader_repository.dart';
import '../features/nfc/data/repositories/simulated_nfc_reader_repository.dart';
import '../features/nfc/domain/repositories/nfc_reader_repository.dart';
import '../features/nfc/domain/usecases/identify_medication_by_tag.dart';

// Historial de tomas
import '../features/dose_tracking/data/repositories/local_dose_repository.dart';
import '../features/dose_tracking/domain/usecases/confirm_dose.dart';
import '../features/dose_tracking/domain/usecases/list_doses.dart';
import '../features/dose_tracking/presentation/controllers/dose_controller.dart';

// Tema de la aplicación
import 'theme/app_theme.dart';

class MediTagApp extends StatefulWidget {
  const MediTagApp({super.key});

  @override
  State<MediTagApp> createState() => _MediTagAppState();
}

class _MediTagAppState extends State<MediTagApp> {
  late final MedicationController medicationController;
  late final IdentifyMedicationByTag identifyMedication;
  late final DoseController doseController;

  @override
  void initState() {
    super.initState();

    // -------------------------------------------------
    // 1. CONFIGURACIÓN DE MEDICAMENTOS
    // -------------------------------------------------

    final medicationRepository = InMemoryMedicationRepository();

    medicationController = MedicationController(
      listMedications: ListMedications(
        medicationRepository,
      ),
      saveMedication: SaveMedication(
        medicationRepository,
      ),
      deleteMedication: DeleteMedication(
        medicationRepository,
      ),
    );

    // -------------------------------------------------
    // 2. CONFIGURACIÓN DE NFC
    // -------------------------------------------------

    // En Android usamos NFC físico.
    // En Chrome mantenemos la simulación.

    final bool isAndroid =
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android;

    final NfcReaderRepository nfcReader = isAndroid
        ? NativeNfcReaderRepository()
        : SimulatedNfcReaderRepository();

    identifyMedication = IdentifyMedicationByTag(
      nfcReader,
      medicationRepository,
    );

    // -------------------------------------------------
    // 3. CONFIGURACIÓN DEL HISTORIAL
    // -------------------------------------------------

    final doseRepository = LocalDoseRepository();

    doseController = DoseController(
      confirmDose: ConfirmDose(
        doseRepository,
      ),
      listDoses: ListDoses(
        doseRepository,
      ),
    );

    // -------------------------------------------------
    // 4. CARGAR INFORMACIÓN INICIAL
    // -------------------------------------------------

    medicationController.load();
    doseController.load();
  }

  // -------------------------------------------------
  // LIBERAR RECURSOS
  // -------------------------------------------------

  @override
  void dispose() {
    medicationController.dispose();
    doseController.dispose();

    super.dispose();
  }

  // -------------------------------------------------
  // INTERFAZ PRINCIPAL DE MEDITAG
  // -------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTag',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      // Primero aparece la pantalla de bienvenida.
      home: WelcomeGate(
        // Al presionar "Comenzar",
        // se muestra la aplicación principal.
        child: HomePage(
          medicationController: medicationController,
          identifyMedication: identifyMedication,
          doseController: doseController,
        ),
      ),
    );
  }
}
