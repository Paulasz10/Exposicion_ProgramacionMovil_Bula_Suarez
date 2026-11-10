
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../medications/presentation/controllers/medication_controller.dart';
import '../../../medications/presentation/pages/medications_page.dart';

import '../../../nfc/domain/usecases/identify_medication_by_tag.dart';
import '../../../nfc/presentation/pages/nfc_scan_page.dart';

import '../../../dose_tracking/presentation/controllers/dose_controller.dart';
import '../../../dose_tracking/presentation/pages/dose_history_page.dart';

import '../../../statistics/presentation/pages/statistics_page.dart';
import '../../../reminders/presentation/pages/reminders_page.dart';

// Colores principales de MediTag
const Color primaryColor = Color(0xFF087D70);
const Color lightGreen = Color(0xFFD5F3E9);
const Color backgroundColor = Color(0xFFF1F8F6);
const Color darkText = Color(0xFF18342E);

class HomePage extends StatefulWidget {
  final MedicationController medicationController;
  final IdentifyMedicationByTag identifyMedication;
  final DoseController doseController;

  const HomePage({
    super.key,
    required this.medicationController,
    required this.identifyMedication,
    required this.doseController,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;

  void go(int value) {
    setState(() {
      tab = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _Dashboard(
        onGo: go,
        medications: widget.medicationController,
        doses: widget.doseController,
      ),

      MedicationsPage(
        controller: widget.medicationController,
        embedded: true,
      ),

      NfcScanPage(
        identifyMedication: widget.identifyMedication,
        doseController: widget.doseController,
        embedded: true,
      ),

      DoseHistoryPage(
        controller: widget.doseController,
        embedded: true,
      ),

      StatisticsPage(
        doses: widget.doseController,
        medications: widget.medicationController,
      ),

      const RemindersPage(),
    ];

    final screenWidth = MediaQuery.sizeOf(context).width;
    final wide = screenWidth >= 850;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: Row(
        children: [
          if (wide)
            NavigationRail(
              backgroundColor: Colors.white,
              extended: screenWidth > 1100,
              selectedIndex: tab,
              onDestinationSelected: go,

              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 22),
                child: Icon(
                  Icons.medication_liquid,
                  size: 38,
                  color: primaryColor,
                ),
              ),

              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.medication_outlined),
                  selectedIcon: Icon(Icons.medication),
                  label: Text('Medicamentos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.nfc),
                  label: Text('Escanear NFC'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Historial'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text('Estadísticas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.notifications_outlined),
                  label: Text('Recordatorios'),
                ),
              ],
            ),

          Expanded(
            child: IndexedStack(
              index: tab,
              children: pages,
            ),
          ),
        ],
      ),

      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              backgroundColor: Colors.white,
              indicatorColor: lightGreen,
              selectedIndex: tab >= 5 ? 0 : tab,
              onDestinationSelected: go,
              labelBehavior:
                  NavigationDestinationLabelBehavior.alwaysShow,

              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.medication_outlined),
                  selectedIcon: Icon(Icons.medication),
                  label: 'Medicinas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.nfc),
                  label: 'NFC',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history),
                  label: 'Historial',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Datos',
                ),
              ],
            ),

      // Los recordatorios se abren desde el inicio.
      floatingActionButton: null,
    );
  }
}

// --------------------------------------------------
// PANTALLA PRINCIPAL
// --------------------------------------------------

class _Dashboard extends StatelessWidget {
  final ValueChanged<int> onGo;
  final MedicationController medications;
  final DoseController doses;

  const _Dashboard({
    required this.onGo,
    required this.medications,
    required this.doses,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final bool isAndroid =
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android;

    return SafeArea(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          medications,
          doses,
        ]),
        builder: (context, _) {
          final total = medications.medications.length;
          final done = doses.todayCount;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 900,
              ),

              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),

                children: [
                  // ENCABEZADO
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: lightGreen,
                        child: Icon(
                          Icons.medication_liquid,
                          color: primaryColor,
                          size: 27,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MediTag',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: darkText,
                              ),
                            ),
                            Text(
                              'Tu tratamiento, a un toque',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        tooltip: 'Recordatorios',
                        onPressed: () => onGo(5),
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // SALUDO
                  const Text(
                    '¡Hola! 👋',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Consulta y registra tus medicamentos '
                    'fácilmente.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 23),

                  // TARJETA RESUMEN
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.circular(22),
                    ),

                    padding: const EdgeInsets.all(22),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'HOY · ${today.day}/'
                          '${today.month}/${today.year}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Tu resumen diario',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            Expanded(
                              child: _summaryStat(
                                '$total',
                                'Medicamentos',
                                Icons.medication_outlined,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: _summaryStat(
                                '$done',
                                'Tomas confirmadas',
                                Icons.check_circle_outline,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // BOTÓN DE ESCANEO
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryColor,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),

                            onPressed: () => onGo(2),

                            icon: const Icon(Icons.nfc),

                            label: Text(
                              isAndroid
                                  ? 'Escanear etiqueta NFC'
                                  : 'Probar escaneo NFC',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ACCESOS RÁPIDOS
                  const Text(
                    'Acceso rápido',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Dos columnas adaptables.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final availableWidth =
                          constraints.maxWidth;

                      final columns =
                          availableWidth >= 680 ? 4 : 2;

                      const spacing = 12.0;

                      final cardWidth =
                          (availableWidth -
                                  spacing * (columns - 1)) /
                              columns;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,

                        children: [
                          _quickTile(
                            Icons.medication_outlined,
                            'Mis medicamentos',
                            1,
                            cardWidth,
                          ),

                          _quickTile(
                            Icons.history,
                            'Historial de tomas',
                            3,
                            cardWidth,
                          ),

                          _quickTile(
                            Icons.notifications_outlined,
                            'Recordatorios',
                            5,
                            cardWidth,
                          ),

                          _quickTile(
                            Icons.bar_chart_outlined,
                            'Estadísticas',
                            4,
                            cardWidth,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // MENSAJE INFORMATIVO
                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: lightGreen.withValues(
                        alpha: 0.65,
                      ),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),

                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: primaryColor,
                          size: 23,
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            'El escaneo NFC permite '
                            'identificar un medicamento. '
                            'La toma debe confirmarse '
                            'manualmente en la aplicación.',
                            style: TextStyle(
                              fontSize: 12,
                              color: darkText,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ESTADÍSTICA DEL RESUMEN
  Widget _summaryStat(
    String number,
    String label,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 23,
        ),

        const SizedBox(height: 7),

        Text(
          number,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // TARJETAS DE ACCESO RÁPIDO
  Widget _quickTile(
    IconData icon,
    String label,
    int pageIndex,
    double width,
  ) {
    return SizedBox(
      width: width,
      height: 125,

      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onGo(pageIndex),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius:
                        BorderRadius.circular(11),
                  ),

                  child: Icon(
                    icon,
                    size: 23,
                    color: primaryColor,
                  ),
                ),

                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: darkText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
