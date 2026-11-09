import 'package:flutter/material.dart';

import '../../../medications/presentation/controllers/medication_controller.dart';
import '../../../medications/presentation/pages/medications_page.dart';

class HomePage extends StatelessWidget {
  final MedicationController medicationController;
  const HomePage({super.key, required this.medicationController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediTag 💊')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('¡Hola! 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Tu tratamiento, a un toque de distancia'),
              const SizedBox(height: 24),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MediTag · Primera versión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text('Gestiona medicamentos de ejemplo. Los datos se reinician al recargar Chrome.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => MedicationsPage(controller: medicationController),
                  ),
                ),
                icon: const Icon(Icons.medication),
                label: const Text('Mis medicamentos'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Escaneo NFC: próximo módulo. En Chrome será simulado.')),
                ),
                icon: const Icon(Icons.nfc),
                label: const Text('Escanear NFC (próximamente)'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
