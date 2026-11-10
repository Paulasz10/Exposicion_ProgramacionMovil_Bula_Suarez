
import 'package:flutter/material.dart';
import '../controllers/dose_controller.dart';

class DoseHistoryPage extends StatefulWidget {
  final DoseController controller;
  final bool embedded;

  const DoseHistoryPage({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  @override
  State<DoseHistoryPage> createState() => _DoseHistoryPageState();
}

class _DoseHistoryPageState extends State<DoseHistoryPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;

        if (controller.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error != null) {
          return Center(
            child: Text(controller.error!),
          );
        }

        if (controller.records.isEmpty) {
          return const Center(
            child: Text('Todavía no hay tomas confirmadas.'),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.records.length,
              itemBuilder: (context, i) {
                final record = controller.records[i];
                final time = record.takenAt;

                final dateText =
                    '${time.day.toString().padLeft(2, '0')}/'
                    '${time.month.toString().padLeft(2, '0')}/'
                    '${time.year}  '
                    '${time.hour.toString().padLeft(2, '0')}:'
                    '${time.minute.toString().padLeft(2, '0')}';

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF168A78),
                    ),
                    title: Text(record.medicationName),
                    subtitle: Text(
                      'Confirmada: $dateText\n'
                      'Horario registrado: ${record.scheduledSlot}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    // Si está integrada en otra pantalla, no crea otro Scaffold.
    if (widget.embedded) {
      return content;
    }

    // Si se abre como pantalla independiente.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de tomas'),
      ),
      body: content,
    );
  }
}
